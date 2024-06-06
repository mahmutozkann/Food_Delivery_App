import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:to_do_done/CustomWidgets/home_page_widget.dart";
import "package:to_do_done/CustomWidgets/my_cart_widget.dart";
import "package:to_do_done/CustomWidgets/settings_widget.dart";

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[HomePageWidget(), MyCartPage(), SettingsPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_checkout), label: 'My Cart'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class PngImages extends StatelessWidget {
  const PngImages({super.key, required this.path});
  final String path;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/png/$path.png',
      fit: BoxFit.fitWidth,
    );
  }
}

class JpgImages extends StatelessWidget {
  const JpgImages({super.key, required this.path});
  final String path;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/jpg/$path.jpeg',
      fit: BoxFit.fitWidth,
    );
  }
}
