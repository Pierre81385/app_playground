import 'package:app_playground/menus/menuContent.dart';
import 'package:flutter/material.dart';
import 'menuContent.dart';
import 'package:badges/badges.dart';

class menuItem {
  final String title;

  menuItem(this.title);
}

class Menu extends StatefulWidget {
  final String menuSelected;
  const Menu({required this.menuSelected});
  @override
  State<Menu> createState() => _Menu();
}

class _Menu extends State<Menu> {
  late List _menu;

  final List<menuItem> _foodMenuItems = [
    menuItem('Specials'),
    menuItem('Raw Bar Apps'),
    menuItem('Nigiri | Sashimi | Handrolls'),
    menuItem('Rolls'),
    menuItem('Cold Plates'),
    menuItem('Hot Plates'),
    menuItem('Yakitori'),
    menuItem('Desserts')
  ];

  final List<menuItem> _drinkMenuItems = [
    menuItem('Cocktails'),
    menuItem('Specials'),
    menuItem('Draft'),
    menuItem('Bottled and Canned Beer'),
    menuItem('Red Wine'),
    menuItem('White Wine'),
    menuItem('Sake'),
    menuItem('N/A')
  ];

  final List<menuItem> _happyHourMenuItems = [
    menuItem('HH Drinks'),
    menuItem('HH Food')
  ];

  @override
  void initState() {
    if (widget.menuSelected == 'Happy Hour') {
      _menu = _happyHourMenuItems;
    } else if (widget.menuSelected == 'Drink Menu') {
      _menu = _drinkMenuItems;
    } else if (widget.menuSelected == 'Food Menu') {
      _menu = _foodMenuItems;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menuSelected),
        actions: <Widget>[
          Badge(
            badgeContent: null,
            child: IconButton(
              icon: Icon(Icons.article),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            crossAxisCount: 3,
          ),
          itemCount: _menu.length,
          itemBuilder: (context, index) {
            // Item rendering
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MenuContent(content: _menu[index].title)),
                );
              },
              child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(_menu[index].title,
                        style: TextStyle(color: Colors.white)),
                  ),
                  color: Colors.black),
            );
          },
        ),
      ),
    );
  }
}
