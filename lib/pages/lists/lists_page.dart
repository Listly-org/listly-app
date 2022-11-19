import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:listly/pages/lists/widgets/check_list_widget.dart';
import 'package:listly/shared/models/check_list.dart';
import 'package:listly/shared/services/api_service.dart';
import 'package:listly/shared/widgets/check_list_form_widget.dart';
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

    List<CheckList> checkLists = [];

    final addForm = GlobalKey<FormBuilderState>();

    Future<void> getLists() async {
        await api.get('/list').then((value) {
            List newChecklists = value.data['formated_lists'];
            checkLists = newChecklists.map((checkList) => CheckList(
                checkList['id'],
                checkList['name'],
                checkList['type'],
                checkList['value'],
                checkList['items_count'],
                checkList['completed_items_count'],
                checkList['group_id']
            )).toList();
        });
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder(
            future: getLists(),
            builder: (context, snapshot) => ScaffoldWidget(
                title: 'My group lists',
                body: Container(
                    width: MediaQuery.of(context).size.width, 
                    padding: EdgeInsets.all(20),
                    child: ListView(
                        children: checkLists.map((checkList) => Column(children: [
                            CheckListWidget(
                                checkList: checkList,
                                update: (value) => setState(() {})
                            ),
                            SizedBox(height: 5),
                        ])).toList()
                    )
                ),
                floatingActionButton: FloatingActionButton(
                    tooltip: 'Create list',
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                            return CheckListFormWidget(update: (value) => setState(() {}));
                        }
                    ),
                    child: Icon(Icons.add)
                )
            )
        );
    }
}
