import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:listly/shared/services/api_service.dart';
import 'package:listly/shared/services/storage_service.dart';
import 'package:listly/shared/services/toast_service.dart';
import 'package:listly/shared/models/user.dart';

class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    LoginPageState createState() {
        return LoginPageState();
    }
}

class LoginPageState extends State<LoginPage> {
    ToastService toast = ToastService();
    ApiService api = ApiService();
    StorageService storage = StorageService();

    final formKey = GlobalKey<FormBuilderState>();

    void submit() async {
        final formData = formKey.currentState?.value;

        api.post('/login', formData, useAuth: false)
            .then((value) async {
                await storage.setUser(json.encode(value.data['user']));
                await storage.setToken(value.data['token'].toString());
                User? user = await storage.getUser();
                return user;
            })
            .then((user) {
                if(user != null) {
                    Navigator.pushNamed(
                        context, 
                        user.groupId == null ? '/group' : '/lists'
                    );
                }
            });
    }
    
    void checkUser() async {
        User? user = await storage.getUser();

        if(user == null) return;
        
        if(mounted) {
            Navigator.pushNamed(
                context, 
                user.groupId == null ? '/group' : '/lists'
            );
        }
    }

    @override
    void initState() {
        super.initState();

        checkUser();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
                width: MediaQuery.of(context).size.width, 
                padding: EdgeInsets.only(top: 40, left: 40, right: 40, bottom: 40),
                child: Column(children: [
                    Image(
                        image: AssetImage('assets/images/logo.png'), 
                        width: MediaQuery.of(context).size.width / 3
                    ),
                    Text(
                        'Welcome back!', 
                        style: Theme.of(context).textTheme.headline3
                    ),
                    Text(
                        'Log in to your existing account of Listly',
                        style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(height: 40),
                    FormBuilder(
                        autovalidateMode: AutovalidateMode.disabled,
                        key: formKey,
                        child: Column(children: [
                            FormBuilderTextField(
                                name: 'email',
                                autofocus: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.email_outlined),
                                    hintText: 'example@email.com',
                                    labelText: 'Email',
                                    border: OutlineInputBorder()
                                ),
                                validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(errorText: 'Email is required'),
                                    FormBuilderValidators.email(errorText: 'Must be a valid email')
                                ]),
                            ),
                            SizedBox(height: 20),
                            FormBuilderTextField(
                                name: 'password',
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                obscureText: true,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.lock_outline),
                                    hintText: '********',
                                    labelText: 'Password',
                                    border: OutlineInputBorder()
                                ),
                                validator: FormBuilderValidators.required(errorText: 'Password is required')
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: () {
                                    formKey.currentState!.save();
                                    formKey.currentState!.validate();
                                    if(formKey.currentState!.isValid) {
                                        submit();
                                    } else {
                                        toast.displayToast('Check the fields and try again', 'info');
                                    }
                                },
                                child: Text('Log in'),
                            )
                        ])
                    ),
                    SizedBox(height: 40),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text('Doesn\'t have an account? '),
                            TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/sign-up'), 
                                child: Text('Sign Up')
                            )
                        ],
                    ),
                ])
            )
        );
    }
}
