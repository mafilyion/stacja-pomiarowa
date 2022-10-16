import 'package:flutter/material.dart';
import 'package:stacja_pomiarowa/author.dart';
import 'package:stacja_pomiarowa/home.dart';
import 'package:stacja_pomiarowa/credits.dart';

void main() {
  runApp(const Aplikacja());
}

class Aplikacja extends StatelessWidget {
  const Aplikacja({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: "Measurement station", home: BottomBar());
  }
}

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Measurements(),
    AuthorPage(),
    CreditsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.timeline, color: Colors.blue, size: 30),
                  label: 'Measurements'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person, color: Colors.blue, size: 30),
                  label: 'Author'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.copyright, color: Colors.blue, size: 30),
                  label: 'Copyrights')
            ],
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue));
  }
}
