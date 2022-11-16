import 'package:flutter/material.dart';
import 'package:listly/shared/services/api_service.dart';
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

    Future<void> getList() async {
        final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
        listId = arguments['id'];
        if(listId == null) return;

        await api.get('/list/$listId').then((value) {
            debugPrint(value.toString());
        });
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder(
            future: getList(),
            builder: (context, snapshot) => ScaffoldWidget(
                title: 'List page',
                body: Container(),
            ),
        );
    }
}
