import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:listly/shared/models/check_list_item.dart';
import 'package:listly/shared/services/api_service.dart';
import 'package:listly/shared/services/toast_service.dart';

class CheckListItemFormWidget extends StatefulWidget {
    final ValueChanged update;
    final CheckListItem? item;
    final int? listId;

    const CheckListItemFormWidget({
        super.key,
        required this.update,
        this.item,
        this.listId
    });

    @override 
    CheckListItemFormWidgetState createState() {
        return CheckListItemFormWidgetState();
    }
}

class CheckListItemFormWidgetState extends State<CheckListItemFormWidget> {
    ApiService api = ApiService();
    ToastService toast = ToastService();

    final form = GlobalKey<FormBuilderState>();

    void addSubmit() async {
        final payload = {
            'name': form.currentState?.value['name'],
            'completed': false,
            'list_id': widget.listId
        };

        api.post('/list-item', payload).then((value) {
            Navigator.of(context).pop();
            toast.displayToast('List created successfully!', 'success');
            widget.update('');
        });
    }

    void editSubmit() async {
        final payload = {
            'name': form.currentState?.value['name'],
            'completed': widget.item?.completed,
            'list_id': widget.item?.listId
        };

        api.put('/list-item/${widget.item?.id}', payload).then((value) {
            Navigator.of(context).pop();
            toast.displayToast('List updated successfully!', 'success');
            widget.update('');
        });
    }

    @override
    Widget build(BuildContext context) {
        final Map<String, dynamic> initialValue = widget.item == null
            ? {}
            : { 'name': widget.item?.name };
        
        return AlertDialog(
            title: Text(widget.item == null ? 'Create list item' : 'Edit list item'),
            content: FormBuilder(
                autovalidateMode: AutovalidateMode.disabled,
                key: form,
                initialValue: initialValue,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        FormBuilderTextField(
                            name: 'name',
                            autofocus: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                labelText: 'List item name',
                                border: OutlineInputBorder()
                            ),
                            validator: FormBuilderValidators.required(errorText: 'List item name is required'),
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
                        form.currentState!.save();
                        form.currentState!.validate();
                        if(form.currentState!.isValid) {
                            widget.item == null ? addSubmit() : editSubmit();
                        } else {
                            toast.displayToast('Check the fields and try again', 'info');
                        }
                    },
                    child: Text(widget.item == null ? 'Create list item' : 'Edit list item')
                )
            ]
        );
    }
}
