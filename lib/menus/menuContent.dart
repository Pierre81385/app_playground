import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuContent extends StatefulWidget {
  final String content;
  const MenuContent({required this.content});

  @override
  _MenuContentState createState() => _MenuContentState();
}

class _MenuContentState extends State<MenuContent> {
  late String _menuName;
  late Stream<QuerySnapshot> _itemsStream;
  @override
  void initState() {
    _menuName = widget.content;
    if (_menuName == 'HH Drinks') {
      _itemsStream = FirebaseFirestore.instance
          .collection('items')
          .where('happyHour', isEqualTo: true)
          .where('menu', isEqualTo: 'Drink Menu')
          .snapshots();
    } else if (_menuName == 'HH Food') {
      _itemsStream = FirebaseFirestore.instance
          .collection('items')
          .where('happyHour', isEqualTo: true)
          .where('menu', isEqualTo: 'Food Menu')
          .snapshots();
    } else {
      _itemsStream = FirebaseFirestore.instance
          .collection('items')
          .where('submenu', isEqualTo: _menuName)
          .snapshots();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference cart = FirebaseFirestore.instance.collection('cart');
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
                  onTap: () {
                    print('add 1 to the cart');
                  },
                  onLongPress: () {
                    cart.add({
                      'name': data['name'],
                      'price': data['price'],
                    });
                  },
                  title: Text(data['name']),
                  subtitle: Column(
                    children: [Text(data['description']), Text('qty: 0')],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
