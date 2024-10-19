import 'package:flutter/material.dart';
import 'package:fluttermysql2/controller/php_auth.dart';
import 'package:fluttermysql2/screen/home.dart';
import 'package:fluttermysql2/screen/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _showPass = true;
  bool _isAuth = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    controller: _email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username cannot be empty';
                      }
                      if (!validateEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    obscureText: _showPass,
                    controller: _password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      }

                      final passwordError = validatePassword(value);
                      if (passwordError != null) {
                        return passwordError; // Return specific error message
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.password),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _showPass = !_showPass;
                          });
                        },
                        icon: Icon(
                          _showPass ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 50,
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          _isAuth = !_isAuth;
                        });
                        PhpAuth()
                            .loginUser(_email.text, _password.text)
                            .then((value) {
                          if (value == "Login Successful") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                value,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                            ));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                            setState(() {
                              _isAuth = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                value,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ));
                            setState(() {
                              _isAuth = false;
                            });
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                    ),
                    child: (_isAuth)
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Login'),
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  indent: 10,
                  endIndent: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have account? '),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: const Text('Signup'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateEmail(String email) {
    // Basic email validation using a regular expression
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]+$",
    );
    return emailRegex.hasMatch(email);
  }

  String? validatePassword(String password) {
    // Check if password is at least 12 characters long
    if (password.length < 12) {
      return 'Password must be at least 12 characters long';
    }

    // Check if password contains at least one symbol
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Password must contain at least one special character';
    }

    // Check if password contains at least one number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one number';
    }

    return null; // Password is valid
  }
}
