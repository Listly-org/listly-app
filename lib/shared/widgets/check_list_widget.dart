import 'package:flutter/material.dart';
import 'package:listly/shared/constants/options.dart';
import 'package:listly/shared/models/check_list.dart';
import 'package:listly/shared/services/api_service.dart';
import 'package:listly/shared/services/toast_service.dart';
import 'package:listly/shared/widgets/check_list_form_widget.dart';

class CheckListWidget extends StatelessWidget {
    final ValueChanged update;
    final CheckList checkList;

    const CheckListWidget({
        super.key,
        required this.update,
        required this.checkList
    });

    IconData getCheckListIcon() {
        return options[checkList.type] != null
            ? options[checkList.type]?.icon.icon as IconData
            : Icons.question_mark;
    }

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () {
                Navigator.pushNamed(context, '/list', arguments: { 'id': checkList.id });
            },
            child: Card(child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 5, 15),
                child: Column(
                    mainAxisSize: MainAxisSize.min, 
                    children: [
                        Row(children: [
                            Icon(
                                getCheckListIcon(),
                                color: Colors.white30,
                            ),
                            SizedBox(width: 10),
                            Expanded(child: Text(checkList.name)),
                            IconButton(
                                iconSize: 18,
                                onPressed: () {
                                    showModalBottomSheet(
                                        context: context, 
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                        builder: (BuildContext context) {
                                            return _CheckListWidgetBottomMenu(checkList: checkList, update: update);
                                        }
                                    );
                                },
                                icon: Icon(Icons.more_vert)
                            )
                        ]),
                        SizedBox(height: 5),
                        Row(children: [
                            Expanded(
                                flex: 1,
                                child: LinearProgressIndicator(
                                    value: checkList.itemsCount > 0 
                                        ? (checkList.completeditemsCount / checkList.itemsCount)
                                        : 0
                                )
                            ),
                            SizedBox(width: 20),
                            SizedBox(
                                child: Text('${checkList.completeditemsCount} / ${checkList.itemsCount}')
                            ),
                            SizedBox(width: 15)
                        ])
                    ]
                )
            ))
        );
    }
}

class _CheckListWidgetBottomMenu extends StatelessWidget {
    final ValueChanged update;
    final CheckList checkList;

    final ApiService api = ApiService();
    final ToastService toast = ToastService();

    _CheckListWidgetBottomMenu({
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
                ),
            ]
        );
    }
}
