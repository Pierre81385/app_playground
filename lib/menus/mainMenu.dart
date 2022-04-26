import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart';
import 'menuItems.dart';
import 'menuContent.dart';
import 'subMenus.dart';
import '../user/profile.dart';
import '../user/order.dart';

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
              title: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        user: _currentUser,
                      ),
                    ),
                  );
                },
                child: Text('User: ${_currentUser.displayName}'),
              ),
              leading: GestureDetector(
                onTap: () {
                  print('to Add Items Screen');
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddItem()
                        //ProfilePage(user: user),
                        ),
                  );
                },
                child: Icon(
                  Icons.add, // add custom icons also
                ),
              ),
              actions: <Widget>[
                Badge(
                  badgeContent: null,
                  child: IconButton(
                    icon: Icon(Icons.article),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderTicket()),
                      );
                    },
                  ),
                ),
              ],
            ),
            body: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  SizedBox(height: 16.0),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          minimumSize: const Size.fromHeight(50) // NEW
                          ),
                      onPressed: () {
                        print('to Happy Hour Menu');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  Menu(menuSelected: 'Happy Hour')
                              //ProfilePage(user: user),
                              ),
                        );
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  Menu(menuSelected: 'Drink Menu')),
                        );
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  Menu(menuSelected: 'Food Menu')),
                        );
                      },
                      child: Text('Food')),
                ],
              ),
            )));
  }
}
