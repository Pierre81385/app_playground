import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'menuItems.dart';

class StatefulMenuWidget extends StatefulWidget {
  final User user;
  const StatefulMenuWidget({required this.user});

  @override
  State<StatefulMenuWidget> createState() => _StatefulMenuWidgetState();
}

class _StatefulMenuWidgetState extends State<StatefulMenuWidget> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Scaffold(
            appBar: AppBar(
              title: Text('User: ${_currentUser.displayName}'),
            ),
            body: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          minimumSize: const Size.fromHeight(50) // NEW
                          ),
                      onPressed: () {
                        print('to Add Items Screen');
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => AddItem()
                              //ProfilePage(user: user),
                              ),
                        );
                      },
                      child: Text('Add Items')),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          minimumSize: const Size.fromHeight(50) // NEW
                          ),
                      onPressed: () {
                        print('to Happy Hour Menu');
                      },
                      child: Text('Happy Hour')),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        minimumSize: const Size.fromHeight(50), // NEW
                      ),
                      onPressed: () {
                        print('to Drink Menu');
                      },
                      child: Text('Drinks')),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        minimumSize: const Size.fromHeight(50), // NEW
                      ),
                      onPressed: () {
                        print('to Food Menu');
                      },
                      child: Text('Food')),
                ],
              ),
            )));
  }
}
