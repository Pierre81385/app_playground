import 'package:flutter/material.dart';
import 'validator.dart';
import 'package:app_playground/signup.dart';

class StatefulSignupWidget extends StatefulWidget {
  const StatefulSignupWidget({Key? key}) : super(key: key);

  @override
  State<StatefulSignupWidget> createState() => _StatefulSignupWidgetState();
}

class _StatefulSignupWidgetState extends State<StatefulSignupWidget> {
  final _signupFormKey = GlobalKey<FormState>();

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusFName = FocusNode();
  final _focusLName = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('App Playground'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Form(
                key: _signupFormKey,
                child: Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        controller: fnameController,
                        focusNode: _focusFName,
                        validator: (value) =>
                            Validator.validateName(name: value),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First Name',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        controller: lnameController,
                        focusNode: _focusLName,
                        validator: (value) =>
                            Validator.validateName(name: value),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last Name',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        controller: emailController,
                        focusNode: _focusEmail,
                        validator: (value) =>
                            Validator.validateEmail(email: value),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'E-Mail',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        controller: passwordController,
                        focusNode: _focusPassword,
                        obscureText: true,
                        validator: (value) =>
                            Validator.validatePassword(password: value),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Signup'),
                          onPressed: () {
                            print(emailController.text);
                            print(passwordController.text);
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
