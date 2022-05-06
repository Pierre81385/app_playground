import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderTicket extends StatefulWidget {
  @override
  _OrderTicket createState() => _OrderTicket();
}

class _OrderTicket extends State<OrderTicket> {
  late Stream<QuerySnapshot> _orderStream;

  User? user = FirebaseAuth.instance.currentUser;
  final _fireStore = FirebaseFirestore.instance;
  late num _totalPrice = 0;

  @override
  void initState() {
    _orderStream = FirebaseFirestore.instance
        .collection('cart')
        .where('user', isEqualTo: user?.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Order')),
      body: Column(
        children: [
          Text('--- BAR ---'),
          DrinkOrderTicket(),
          Text('--- KITCHEN ---'),
          FoodOrderTicket(),
          ElevatedButton(onPressed: () {}, child: Text('ORDER'))
        ],
      ),
    );
  }
}

class DrinkOrderTicket extends StatefulWidget {
  @override
  _DrinkOrderTicket createState() => _DrinkOrderTicket();
}

class _DrinkOrderTicket extends State<DrinkOrderTicket> {
  late Stream<QuerySnapshot> _drinkStream;
  var _drinkTotal = 0;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _drinkStream = FirebaseFirestore.instance
        .collection('cart')
        .where('menu', isEqualTo: 'Drink Menu')
        .where('user', isEqualTo: user?.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _drinkStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        child: Text(data['name'], textAlign: TextAlign.left),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        child: Text('QTY: ${data['quantity'].toString()}',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        child: Text('@: \$${data['price']} each',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        });
  }
}

class FoodOrderTicket extends StatefulWidget {
  @override
  _FoodOrderTicket createState() => _FoodOrderTicket();
}

class _FoodOrderTicket extends State<FoodOrderTicket> {
  late Stream<QuerySnapshot> _foodStream;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _foodStream = FirebaseFirestore.instance
        .collection('cart')
        .where('menu', isEqualTo: 'Food Menu')
        .where('user', isEqualTo: user?.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _foodStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        child: Text(data['name'], textAlign: TextAlign.left),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        child: Text('QTY: ${data['quantity'].toString()}',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        child: Text('@: \$${data['price']} each',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        });
  }
}
