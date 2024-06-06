import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_done/Pages/sign_in.dart';
import 'package:to_do_done/entities/user.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final String _title = 'Settings';
  final UserRepository _userRepository = UserRepository();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId != null) {
      User? user = await _userRepository.getUserById(userId);
      setState(() {
        _currentUser = user;
      });
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignIn()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
        title: Text(_title),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50),
            width: 400,
            height: 250,
            child: Card(
              color: Colors.grey[50],
              child: _currentUser != null
                  ? SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.only(top: 8)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '${_currentUser!.firstName} ${_currentUser!.lastName}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(_currentUser!.email)],
                          )
                        ],
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
          Container(
            width: 120,
            height: 120,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(blurRadius: 7, spreadRadius: 5, offset: const Offset(0, 5), color: Colors.grey.withOpacity(0.9))
            ]),
            child: Image.asset('assets/jpg/profile.jpeg'),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 6),
            child: SizedBox(
              height: 50,
              width: 360,
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.purple),
                    overlayColor: MaterialStatePropertyAll(Color.fromRGBO(247, 240, 249, 100))),
                onPressed: _logout,
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 20, color: Color.fromRGBO(247, 240, 249, 100)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
