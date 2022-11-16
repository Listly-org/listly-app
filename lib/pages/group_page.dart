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

    final joinForm = GlobalKey<FormBuilderState>();

    final addForm = GlobalKey<FormBuilderState>();

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
            'group_id': joinForm.currentState?.value['group']
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

    void addSubmit() async {
        final payload = {
            'name': addForm.currentState?.value['name']
        };

        api.post('/group', payload).then((value) {
            Navigator.of(context).pop();
            setState(() {});
            toast.displayToast('Group created successfully!', 'success');
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
                                key: joinForm,
                                child: Column(children: [
                                    FormBuilderDropdown<int>(
                                        name: 'group',
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                            hintText: 'Select a group',
                                            labelText: 'Group',
                                            border: OutlineInputBorder()
                                        ),
                                        items: groups.map((e) => DropdownMenuItem(
                                            alignment: AlignmentDirectional.centerStart,
                                            value: e.id,
                                            child: Text(e.name),
                                        )).toList(),
                                        validator: FormBuilderValidators.required(errorText: 'Group is required')
                                    ),
                                    SizedBox(height: 40),
                                    ElevatedButton(
                                        onPressed: () {
                                            joinForm.currentState!.save();
                                            joinForm.currentState!.validate();
                                            if(joinForm.currentState!.isValid) {
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
                ),
                floatingActionButton: FloatingActionButton(
                    tooltip: 'Create group',
                    onPressed: () => showDialog(context: context, builder: (context) => AlertDialog(
                        title: Text('Create group'),
                        content: FormBuilder(
                            autovalidateMode: AutovalidateMode.disabled,
                            key: addForm,
                            child: FormBuilderTextField(
                                name: 'name',
                                autofocus: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                    labelText: 'Group name',
                                    hintText: 'My awesome group',
                                    border: OutlineInputBorder()
                                ),
                                validator: FormBuilderValidators.required(errorText: 'Group name is required')
                            )
                        ),
                        actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(), 
                                child: Text('Cancel')
                            ),
                            ElevatedButton(
                                onPressed: () {
                                    addForm.currentState!.save();
                                    addForm.currentState!.validate();
                                    if(addForm.currentState!.isValid) {
                                        addSubmit();
                                    } else {
                                        toast.displayToast('Check the fields and try again', 'info');
                                    }
                                },
                                child: Text('Create group')
                            )
                        ],
                    )),
                    child: Icon(Icons.add)
                ),
            )
        );
    }
}
