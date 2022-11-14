import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:listly/pages/login_page.dart';

Future main() async {
    await dotenv.load(fileName: '.env');

    runApp(
        MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Listly',
            theme: ThemeData.from(colorScheme: ColorScheme.dark()),
            themeMode: ThemeMode.dark,
            routes: <String, WidgetBuilder>{
                '/': (BuildContext context) => const LoginPage()
            },
        )
    );
}
