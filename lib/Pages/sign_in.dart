import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_done/Pages/home_page.dart';
import 'package:to_do_done/Pages/sign_up.dart';
import 'package:to_do_done/entities/user.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final String _appTitle = 'Food Delivery';
  final String _signIn = 'Sign In';
  final String _signUp = 'Sign Up';
  final String _emailAddress = 'Email Address';
  final String _exampleEmail = 'username@hotmail.com';
  final String _password = 'Password';
  bool _passwordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
        title: Text(_appTitle),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 30)),
            Text(
              _signIn,
              style: const TextStyle(fontSize: 40),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 4)),
            _mailInput(),
            _passwordInput(),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            _signInButton(),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            const Row(
              children: [
                Expanded(
                    child: Divider(
                  endIndent: 10,
                )),
                Text('OR'),
                Expanded(
                    child: Divider(
                  indent: 10,
                )),
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            _signUpButton(),
          ],
        ),
      ),
    );
  }

  SizedBox _signInButton() {
    return SizedBox(
      height: 50,
      width: 360,
      child: ElevatedButton(
        onPressed: () async {
          String email = _emailController.text.trim();
          String password = _passwordController.text.trim();

          User? user = await _userRepository.getUserByEmailAndPassword(email, password);

          if (user != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('userId', user.userId!);
            await prefs.setString('username', user.username);

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid email or password')),
            );
          }
        },
        child: Text(
          _signIn,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  SizedBox _signUpButton() {
    return SizedBox(
      height: 50,
      width: 360,
      child: ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.purple),
            overlayColor: MaterialStatePropertyAll(Color.fromRGBO(247, 240, 249, 100))),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
        },
        child: Text(
          _signUp,
          style: const TextStyle(fontSize: 20, color: Color.fromRGBO(247, 240, 249, 100)),
        ),
      ),
    );
  }

  Padding _passwordInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_passwordVisible,
        obscuringCharacter: '#',
        decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off)),
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
            labelText: _password),
      ),
    );
  }

  Padding _mailInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
            labelText: _emailAddress,
            hintText: _exampleEmail),
      ),
    );
  }
}
