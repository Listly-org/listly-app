import 'package:flutter/material.dart';
import 'package:listly/shared/models/check_list.dart';
import 'package:listly/shared/services/api_service.dart';
import 'package:listly/shared/services/toast_service.dart';
import 'package:listly/shared/widgets/check_list_form_widget.dart';

class CheckListOptionsWidget extends StatelessWidget {
    final ValueChanged update;
    final CheckList checkList;

    final ApiService api = ApiService();
    final ToastService toast = ToastService();

    CheckListOptionsWidget({
        super.key,
        required this.update,
        required this.checkList
    });

    void deleteCheckList(BuildContext context) async {
        api.delete('/list/${checkList.id}', {}).then((value) {
            toast.displayToast('List deleted successfully', 'success');
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
                    'Manage list',
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
                                return CheckListFormWidget(
                                    checkList: checkList,
                                    update: (value) => update('')
                                );
                            }
                        );
                    }
                ),
                ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete', style: TextStyle(color: Colors.red)),
                    onTap: () => deleteCheckList(context)
                )
            ]
        );
    }
}
