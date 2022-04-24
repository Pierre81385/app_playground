import 'package:flutter/material.dart';
import 'validator.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItem extends StatefulWidget {
  @override
  State<AddItem> createState() => _AddItem();
}

class _AddItem extends State<AddItem> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  final _focusName = FocusNode();
  final _focusDescription = FocusNode();
  final _focusPrice = FocusNode();

  String dropdownValue = 'Drinks Menu';
  String submenuValue = 'Specials';
  bool isChecked = false;
  bool shellChecked = false;
  bool vegChecked = false;
  bool veganChecked = false;
  bool glutenChecked = false;

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
            'price': _priceController.text, // Item Price
            'menu': dropdownValue,
            'submenu': submenuValue,
            'glutenFree': glutenChecked,
            'vegan': veganChecked,
            'vegetarian': vegChecked,
            'shellfishAllergy': shellChecked,
            'happyHour': isChecked
          })
          .then((value) => print("Item Added"))
          .catchError((error) => print("Failed to add item: $error"));
    }

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
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
                        DropdownButton<String>(
                          value: dropdownValue,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>['Drinks Menu', 'Food Menu']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        DropdownButton<String>(
                            value: submenuValue,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.black,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                submenuValue = newValue!;
                              });
                            },
                            items: dropdownValue == 'Drinks Menu'
                                ? <String>[
                                    'Specials',
                                    'Cocktails',
                                    'Beer',
                                    'Wine',
                                    'N/A'
                                  ].map<DropdownMenuItem<String>>(
                                    (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()
                                : <String>[
                                    'Specials',
                                    'Raw Bar Apps',
                                    'Sushi',
                                    'Rolls',
                                    'Cold Plates'
                                  ].map<DropdownMenuItem<String>>(
                                    (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()),
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
                        Row(
                          children: [
                            Text('Shellfish Allergy'),
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: shellChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  shellChecked = value!;
                                });
                              },
                            ),
                            Text('Gluten Free'),
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: glutenChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  glutenChecked = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Vegetarian'),
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: vegChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  vegChecked = value!;
                                });
                              },
                            ),
                            Text('Vegan'),
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: veganChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  veganChecked = value!;
                                });
                              },
                            ),
                            Text('Happy Hour'),
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: addItem,
                          child: Text("Add Item to ${dropdownValue} menu"),
                        )
                      ]),
                    )
                  ],
                ))));
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
