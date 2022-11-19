import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:listly/shared/models/check_list.dart';
import 'package:listly/shared/models/check_list_item.dart';
import 'package:listly/shared/services/api_service.dart';
import 'package:listly/shared/services/toast_service.dart';
import 'package:listly/shared/widgets/check_list_item_form_widget.dart';
import 'package:listly/shared/widgets/check_list_item_widget.dart';
import 'package:listly/shared/widgets/check_list_options_widget.dart';
import 'package:listly/shared/widgets/scaffold_widget.dart';

class ListPage extends StatefulWidget {
    const ListPage({super.key});

    @override
    ListPageState createState() {
        return ListPageState();
    }
}

class ListPageState extends State<ListPage> {
    int? listId;
    ApiService api = ApiService();
    ToastService toast = ToastService();

    CheckList checkList = CheckList(0, '', '', 0, 0, 0, 0);
    List<CheckListItem> items = [];

    final addForm = GlobalKey<FormBuilderState>();

    Future<void> getList() async {
        final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
        listId = arguments['id'];
        if(listId == null) return;

        await api.get('/list/$listId').then((value) {
            checkList = CheckList(
                value.data['id'],
                value.data['name'],
                value.data['type'],
                value.data['value'],
                value.data['items_count'],
                value.data['completed_items_count'],
                value.data['group_id']
            );

            List newItems = value.data['listItems'];
            debugPrint(newItems.toString());
            items = newItems.map((item) => CheckListItem(
                item['id'],
                item['name'],
                item['completed'],
                item['list_id']
            )).toList();
        });
    }

    void addSubmit() {}

    @override
    Widget build(BuildContext context) {
        return FutureBuilder(
            future: getList(),
            builder: (context, snapshot) => ScaffoldWidget(
                title: checkList.name,
                barLeading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    tooltip: 'Get back to My Group lists',
                    onPressed: () => Navigator.pushNamed(context, '/lists')
                ),
                barActions: [
                    IconButton(
                        iconSize: 20,
                        onPressed: () {
                            showModalBottomSheet(
                                context: context, 
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                builder: (BuildContext context) => CheckListOptionsWidget(
                                    checkList: checkList, 
                                    update: (value) {
                                        setState(() {});
                                        Navigator.pop(context);
                                    }
                                )
                            );
                        },
                        icon: Icon(Icons.more_vert)
                    )
                ],
                floatingActionButton: FloatingActionButton(
                    onPressed: () => showDialog(
                        context: context, 
                        builder: (context) {
                            return CheckListItemFormWidget(
                                update: (value) => setState(() {}),
                                listId: listId
                            );
                        }
                    ),
                    tooltip: 'Add item',
                    child: Icon(Icons.add)
                ),
                body: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                    child: ListView(children: [
                        Row(children: [
                            Expanded(
                                flex: 1,
                                child: LinearProgressIndicator(
                                    value: checkList.itemsCount > 0 
                                        ? (checkList.completeditemsCount / checkList.itemsCount)
                                        : 0,
                                    backgroundColor: ColorScheme.dark().onTertiary
                                )
                            ),
                            SizedBox(width: 20),
                            SizedBox(child: Text('${checkList.completeditemsCount} / ${checkList.itemsCount}'))
                        ]),
                        SizedBox(height: 20),
                        ...items.map((item) {
                            return CheckListItemWidget(
                                item: item,
                                update: (value) => setState(() {}),
                            );
                        }).toList()
                    ]),
                )
            )
        );
    }
}
