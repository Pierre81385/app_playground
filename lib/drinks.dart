import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrinkMenu extends StatefulWidget {
  @override
  _DrinkMenuState createState() => _DrinkMenuState();
}

class _DrinkMenuState extends State<DrinkMenu> {
  final Stream<QuerySnapshot> _itemsStream = FirebaseFirestore.instance
      .collection('items')
      .where('menu', isEqualTo: 'Drink Menu')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _itemsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Scaffold(
          appBar: AppBar(title: Text('Items in DB')),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['name']),
                  subtitle: Text(data['description']),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
