import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:listly/shared/constants/options.dart';
import 'package:listly/shared/services/api_service.dart';
import 'package:listly/shared/services/toast_service.dart';
import 'package:listly/shared/widgets/scaffold_widget.dart';

class ListsPage extends StatefulWidget {
    const ListsPage({super.key});

    @override
    ListsPageState createState() {
        return ListsPageState();
    }
}

class ListsPageState extends State<ListsPage> {
    ApiService api = ApiService();
    ToastService toast = ToastService();

    final addForm = GlobalKey<FormBuilderState>();

    Future<void> getLists() async {
        api.get('/list', useAuth: true)
            .then((value) {
                debugPrint(value.data.toString());
            });
    }

    void addSubmit() async {
        final payload = {
            'name': addForm.currentState?.value['name'],
            'type': addForm.currentState?.value['type']
        };

        api.post('/list', payload).then((value) {
            Navigator.of(context).pop();
            setState(() {});
            toast.displayToast('List created successfully!', 'success');
        });
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder(
            future: getLists(),
            builder: (context, snapshot) => ScaffoldWidget(
                title: 'My group lists',
                body: Text('Aqui terá a listagem das listas'),
                floatingActionButton: FloatingActionButton(
                    tooltip: 'Create list',
                    onPressed: () => showDialog(context: context, builder: (context) => AlertDialog(
                        title: Text('Create list'),
                        content: FormBuilder(
                            autovalidateMode: AutovalidateMode.disabled,
                            key: addForm,
                            child: Column(
                                mainAxisSize: MainAxisSize.min, 
                                children: [
                                    FormBuilderTextField(
                                        name: 'name',
                                        autofocus: true,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                            labelText: 'List name',
                                            hintText: 'My awesome list',
                                            border: OutlineInputBorder()
                                        ),
                                        validator: FormBuilderValidators.required(errorText: 'List name is required')
                                    ),
                                    SizedBox(height: 20),
                                    FormBuilderDropdown<String>(
                                        name: 'type',
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                            labelText: 'List type',
                                            border: OutlineInputBorder()
                                        ),
                                        items: options.values.map((option) => DropdownMenuItem(
                                            alignment: AlignmentDirectional.centerStart,
                                            value: option.value,
                                            child: Row(children: [option.icon, SizedBox(width: 10), option.label])
                                        )).toList(),
                                        validator: FormBuilderValidators.required(errorText: 'List type is required')
                                    )
                                ]
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
                                child: Text('Create list')
                            )
                        ]
                    )),
                    child: Icon(Icons.add)
                ),
            )
        );
    }
}
