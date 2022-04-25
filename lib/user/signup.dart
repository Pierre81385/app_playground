import 'login.dart';
import 'package:flutter/material.dart';
import '../validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../FirebaseAuth.dart';

class StatefulSignupWidget extends StatefulWidget {
  const StatefulSignupWidget({Key? key}) : super(key: key);

  @override
  State<StatefulSignupWidget> createState() => _StatefulSignupWidgetState();
}

class _StatefulSignupWidgetState extends State<StatefulSignupWidget> {
  final _signupFormKey = GlobalKey<FormState>();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusFName = FocusNode();
  final _focusLName = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusFName.unfocus();
        _focusLName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
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
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        controller: _usernameController,
                        focusNode: _focusFName,
                        validator: (value) =>
                            Validator.validateName(name: value),
                        decoration: InputDecoration(
                          hintText: "Userame",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        controller: _emailController,
                        focusNode: _focusEmail,
                        validator: (value) =>
                            Validator.validateEmail(email: value),
                        decoration: InputDecoration(
                          hintText: "E-Mail",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        controller: _passwordController,
                        focusNode: _focusPassword,
                        obscureText: true,
                        validator: (value) =>
                            Validator.validatePassword(password: value),
                        decoration: InputDecoration(
                          hintText: "Password",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.0),
                    _isProcessing
                        ? CircularProgressIndicator()
                        : Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                    minimumSize:
                                        const Size.fromHeight(50), // NEW
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _isProcessing = true;
                                    });

                                    if (_signupFormKey.currentState!
                                        .validate()) {
                                      User? user = await FireAuth
                                          .registerUsingEmailPassword(
                                        name: _usernameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );

                                      setState(() {
                                        _isProcessing = false;
                                      });

                                      if (user != null) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StatefulLoginWidget()),
                                          ModalRoute.withName('/'),
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Sign up',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
