import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:listly/shared/models/group.dart';
import 'package:listly/shared/models/user.dart';
import 'package:listly/shared/services/api_service.dart';
import 'package:listly/shared/services/storage_service.dart';
import 'package:listly/shared/services/toast_service.dart';
import 'package:listly/shared/widgets/scaffold_widget.dart';

class GroupPage extends StatefulWidget {
    const GroupPage({super.key});

    @override
    GroupPageState createState() {
        return GroupPageState();
    }
}

class GroupPageState extends State<GroupPage> {
    ToastService toast = ToastService();
    StorageService storage = StorageService();
    ApiService api = ApiService();

    User user = User(0, '', '', '', null);
    List<Group> groups = [];

    final formKey = GlobalKey<FormBuilderState>();

    Future<void> loadData() async {
        User? currentUser = await storage.getUser();
        if(currentUser != null) user = currentUser;
        
        await api.get('/group').then((value) {
            List newGroups = value.data['groups'];
            groups = newGroups.map((e) => Group(e['id'], e['name'])).toList();
        });
    }

    void submit() async {
        final payload = {
            'group_id': formKey.currentState?.value['group'].id
        };

        api.put('/user/join-group', payload)
            .then((value) async {
                await storage.setUser(json.encode(value.data['user']));
                await storage.setToken(value.data['token'].toString());
            })
            .then((value) {
                toast.displayToast('Joined group successfully!', 'success');
                Navigator.pushNamed(context, '/lists');
            });
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder(
            future: loadData(),
            builder: (context, snapshot) => ScaffoldWidget(
                title: user.groupId == null ? 'Welcome, ${user.name}!' : 'Change group',
                body: Container(
                    width: MediaQuery.of(context).size.width, 
                    padding: EdgeInsets.only(top: 40, left: 40, right: 40, bottom: 40),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Text(
                                user.groupId == null ? 'Before we get started...' : 'Be Careful!',
                                style: Theme.of(context).textTheme.headline4,
                            ),
                            SizedBox(height: 20),
                            Text(
                                user.groupId == null 
                                ? 'You need to be part of a group, so join in an existing one or create it'
                                : 'Changing your group means that all your current lists will be replaced by the new ones',
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 40),
                            FormBuilder(
                                autovalidateMode: AutovalidateMode.disabled,
                                key: formKey,
                                child: Column(children: [
                                    FormBuilderDropdown<Group>(
                                        name: 'group',
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                            hintText: 'Select a group',
                                            labelText: 'Group',
                                            border: OutlineInputBorder()
                                        ),
                                        items: groups.map((e) => DropdownMenuItem(
                                            alignment: AlignmentDirectional.centerStart,
                                            value: e,
                                            child: Text(e.name),
                                        )).toList(),
                                        validator: FormBuilderValidators.required(errorText: 'Group is required')
                                    ),
                                    SizedBox(height: 40),
                                    ElevatedButton(
                                        onPressed: () {
                                            formKey.currentState!.save();
                                            formKey.currentState!.validate();
                                            if(formKey.currentState!.isValid) {
                                                submit();
                                            } else {
                                                toast.displayToast('Check the fields and try again', 'info');
                                            }
                                        },
                                        child: Text('Join group')
                                    )
                                ])
                            )
                        ]
                    )
                )
            )
        );
    }
}
