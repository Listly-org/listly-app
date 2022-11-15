import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget {
    const GroupPage({super.key});

    @override
    GroupPageState createState() {
        return GroupPageState();
    }
}

class GroupPageState extends State<GroupPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
              appBar: AppBar(title: Text('Group')),
            body: Column(children: []),
        );
    }
}
