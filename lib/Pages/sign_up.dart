import 'package:flutter/material.dart';
import 'package:to_do_done/Pages/sign_in.dart';
import 'package:to_do_done/entities/user.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final String _appTitle = 'Food Delivery';
  final String _signUp = 'Sign Up';
  final String _emailAddress = 'Email Address';
  final String _exampleEmail = 'username@hotmail.com';
  final String _password = 'Password';
  bool _passwordVisible = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
        title: Text(_appTitle),
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 30)),
          Text(
            _signUp,
            style: const TextStyle(fontSize: 40),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                labelText: 'Username',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 195,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                      labelText: 'First Name',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 195,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                      labelText: 'Last Name',
                    ),
                  ),
                ),
              ),
            ],
          ),
          _mailInput(),
          _passwordInput(),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          _signUpButton()
        ],
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
          overlayColor: MaterialStatePropertyAll(Color.fromRGBO(247, 240, 249, 100)),
        ),
        onPressed: () async {
          String username = _usernameController.text.trim();
          String firstName = _firstNameController.text.trim();
          String lastName = _lastNameController.text.trim();
          String email = _emailController.text.trim();
          String password = _passwordController.text.trim();

          User newUser = User(
            username: username,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
          );

          await _userRepository.insertUser(newUser);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User registered successfully')),
          );

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignIn()));
        },
        child: Text(
          _signUp,
          style: const TextStyle(fontSize: 20, color: Color.fromRGBO(247, 240, 249, 100)),
        ),
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
}
