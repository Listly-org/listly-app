import 'package:flutter/material.dart';
import 'package:listly/shared/services/storage_service.dart';

class ScaffoldWidget extends StatefulWidget {
    final String title;
    final Widget? barLeading;
    final List<Widget>? barActions;
    final Widget body;
    final Widget? floatingActionButton;

    const ScaffoldWidget({
        super.key, 
        required this.title, 
        this.barLeading,
        this.barActions,
        required this.body,
        this.floatingActionButton
    });

    @override
    ScaffoldWidgetState createState() {
        return ScaffoldWidgetState();
    }
}

class ScaffoldWidgetState extends State<ScaffoldWidget> {
    StorageService storage = StorageService();

    void logout() async {
        await storage.clear();
        if(mounted) Navigator.pushNamed(context, '/');
    }

    @override build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
                leading: widget.barLeading,
                actions: widget.barActions
            ),
            body: widget.body,
            floatingActionButton: widget.floatingActionButton,
            drawer: Drawer(child: ListView(
                padding: EdgeInsets.zero,
                children: [
                    DrawerHeader(child: Image(
                        image: AssetImage('assets/images/logo.png'), 
                        width: MediaQuery.of(context).size.width / 4
                    )),
                    ListTile(
                        leading: Icon(Icons.list_alt),
                        title: Text('My group lists'),
                        onTap: () => Navigator.pushNamed(context, '/lists'),
                    ),
                    ListTile(
                        leading: Icon(Icons.groups),
                        title: Text('Change group'),
                        onTap: () => Navigator.pushNamed(context, '/group'),
                    ),
                    ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Profile'),
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                    ),
                    ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                        onTap: () => logout(),
                    )
                ]
            ))
        );
    }
}
