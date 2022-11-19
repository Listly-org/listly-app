import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:listly/shared/services/api_service.dart';
import 'package:listly/shared/services/toast_service.dart';

class SignUpPage extends StatefulWidget {
    const SignUpPage({super.key});

    @override
    SignUpPageState createState() {
        return SignUpPageState();
    }
}

class SignUpPageState extends State<SignUpPage> {
    ToastService toast = ToastService();
    ApiService api = ApiService();

    final formKey = GlobalKey<FormBuilderState>();

    void submit() {
        final formData = formKey.currentState?.value;
            
        api.post('/user', formData, useAuth: false)
            .then((value) {
                toast.displayToast('Account created successfully!', 'success');
                Navigator.pushNamed(context, '/');
            });
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
                        width: MediaQuery.of(context).size.width / 4
                    ),
                    Text(
                        'Let\'s get started!', 
                        style: Theme.of(context).textTheme.headline3
                    ),
                    Text(
                        'Create an account to Listly to get all the features',
                        style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(height: 40),
                    FormBuilder(
                        autovalidateMode: AutovalidateMode.disabled,
                        key: formKey,
                        child: Column(children: [
                            FormBuilderTextField(
                                name: 'name',
                                autofocus: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.person),
                                    labelText: 'Name',
                                    border: OutlineInputBorder()
                                ),
                                validator: FormBuilderValidators.required(errorText: 'Name is required')
                            ),
                            SizedBox(height: 20),
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
                                child: Text('Create account'),
                            )
                        ])
                    ),
                    SizedBox(height: 40),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text('Already have an account? '),
                            TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/'), 
                                child: Text('Login here')
                            )
                        ],
                    ),
                ])
            )
        );
    }
}
