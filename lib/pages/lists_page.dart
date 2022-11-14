import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:listly/services/api_service.dart';
import 'package:listly/storage.dart';

class ListsPage extends StatefulWidget {
    const ListsPage({super.key});

    @override
    ListsPageState createState() {
        return ListsPageState();
    }
}

class ListsPageState extends State<ListsPage> {
    ApiService api = ApiService();

    void getLists() async {
        api.get('/list', useAuth: true)
            .then((value) {
                debugPrint(value.data.toString());
            });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text('Lists')),
            body: Column(children: [
                TextButton(
                    onPressed: () => getLists(), 
                    child: Text('Get lists')
                )
            ]),
        );
    }
}
