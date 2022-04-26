import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../user/order.dart';

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
          appBar: AppBar(
            title: Text(_menuName),
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
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTileItem(
                  title: data['name'],
                  description: data['description'],
                  menu: data['menu'],
                  price: data['price'].toString(),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class ListTileItem extends StatefulWidget {
  final String title;
  final String description;
  final String menu;
  final String price;
  const ListTileItem(
      {required this.title,
      required this.description,
      required this.menu,
      required this.price});
  @override
  _ListTileItemState createState() => new _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  User? user = FirebaseAuth.instance.currentUser;

  int _itemCount = 0;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        cart.add({
          'name': widget.title,
          'quantity': _itemCount,
          'status': 'pending',
          'user': user?.uid,
          'menu': widget.menu,
          'price': widget.price
        });
        setState(() {
          _itemCount = 0;
        });
      },
      title: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Container(
              child: Text(widget.title, textAlign: TextAlign.left),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Container(
              child: Text(widget.description, style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            _itemCount != 0
                ? IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => setState(() => _itemCount--),
                  )
                : Container(),
            Text(_itemCount.toString()),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () => setState(() => _itemCount++))
          ],
        ),
      ),
    );
  }
}
