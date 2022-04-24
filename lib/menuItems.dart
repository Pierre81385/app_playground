import 'package:flutter/material.dart';
import 'validator.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItem extends StatelessWidget {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  final _focusName = FocusNode();
  final _focusDescription = FocusNode();
  final _focusPrice = FocusNode();

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference item = FirebaseFirestore.instance.collection('items');

    Future<void> addItem() {
      // Call the user's CollectionReference to add a new user
      return item
          .add({
            'name': _nameController.text, // Item Name
            'description': _descriptionController.text, // Item Description
            'price': _priceController.text // Item Price
          })
          .then((value) => print("Item Added"))
          .catchError((error) => print("Failed to add item: $error"));
    }

    return GestureDetector(
        onTap: () {
          _focusName.unfocus();
          _focusDescription.unfocus();
          _focusPrice.unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Add Item'),
            ),
            body: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    Form(
                      child: Column(children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'Add Items',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            controller: _nameController,
                            focusNode: _focusName,
                            obscureText: false,
                            validator: (value) =>
                                Validator.validateName(name: value),
                            decoration: InputDecoration(
                              hintText: "Item Name",
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
                            controller: _descriptionController,
                            focusNode: _focusDescription,
                            obscureText: false,
                            validator: (value) => Validator.validateDescription(
                                description: value),
                            decoration: InputDecoration(
                              hintText:
                                  "Item Description (500 or less characters)",
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
                          //this needs to be more number specific.
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            controller: _priceController,
                            focusNode: _focusPrice,
                            obscureText: false,
                            validator: (value) => Validator.validateDescription(
                                description: value),
                            decoration: InputDecoration(
                              hintText: "Item price (numbers only)",
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
                          onPressed: addItem,
                          child: Text(
                            "Add Item",
                          ),
                        )
                      ]),
                    )
                  ],
                ))));
    //needs input fields
    // return TextButton(
    //   onPressed: addItem,
    //   child: Text(
    //     "Add Item",
    //   ),
    // );
  }
}

class ItemInformation extends StatefulWidget {
  @override
  _ItemInformationState createState() => _ItemInformationState();
}

class _ItemInformationState extends State<ItemInformation> {
  final Stream<QuerySnapshot> _itemsStream =
      FirebaseFirestore.instance.collection('items').snapshots();

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
