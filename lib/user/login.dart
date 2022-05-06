import 'signup.dart';
import 'package:flutter/material.dart';
import '../validator.dart';
import '../FirebaseAuth.dart';
import 'profile.dart';
import '../menus/mainMenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatefulLoginWidget extends StatefulWidget {
  const StatefulLoginWidget({Key? key}) : super(key: key);

  @override
  State<StatefulLoginWidget> createState() => _StatefulLoginWidgetState();
}

class _StatefulLoginWidgetState extends State<StatefulLoginWidget> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ProfilePage(user: user),
      ));
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )),
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
                    TextButton(
                      onPressed: () {
                        //forgot password screen
                      },
                      child: const Text('Forgot Password',
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            minimumSize: const Size.fromHeight(50), // NEW
                          ),
                          child: const Text('Login'),
                          onPressed: () async {
                            _focusEmail.unfocus();
                            _focusPassword.unfocus();

                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isProcessing = true;
                              });

                              User? user =
                                  await FireAuth.signInUsingEmailPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              setState(() {
                                _isProcessing = false;
                              });

                              if (user != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StatefulMenuWidget(user: user)
                                      //ProfilePage(user: user),
                                      ),
                                );
                              }
                            }
                          }),
                    ),
                    Row(
                      children: <Widget>[
                        const Text('Don\'t have an account?'),
                        TextButton(
                          child: const Text(
                            'Signup',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          onPressed: () {
                            //signup screen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => StatefulSignupWidget(),
                              ),
                            );
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
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
