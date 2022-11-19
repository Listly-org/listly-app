import 'package:flutter/material.dart';
import 'package:listly/shared/models/check_list_item.dart';
import 'package:listly/shared/services/api_service.dart';
import 'package:listly/shared/services/toast_service.dart';
import 'package:listly/shared/widgets/check_list_item_form_widget.dart';

class CheckListItemOptionsWidget extends StatelessWidget {
    final ValueChanged update;
    final CheckListItem item;

    final ApiService api = ApiService();
    final ToastService toast = ToastService();

    CheckListItemOptionsWidget({
        super.key,
        required this.update,
        required this.item
    });

    void deleteItem(BuildContext context) async {
        api.delete('/list-item/${item.id}', {}).then((value) {
            toast.displayToast('Item deleted successfully', 'success');
            Navigator.pop(context);
            update('');
        });
    }

    @override
    Widget build(BuildContext context) {
        return ListView(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 40),
            shrinkWrap: true,
            children: [
                Text(
                    'Manage item',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6
                ),
                SizedBox(height: 15),
                ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                                return CheckListItemFormWidget(
                                    item: item,
                                    listId: item.id,
                                    update: (value) {
                                        Navigator.pop(context);
                                        update('');
                                    }
                                );
                            }
                        );
                    }
                ),
                ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete', style: TextStyle(color: Colors.red)),
                    onTap: () => deleteItem(context)
                )
            ],
        );
    }
}
