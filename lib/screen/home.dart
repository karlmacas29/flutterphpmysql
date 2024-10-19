import 'package:flutter/material.dart';
import 'package:fluttermysql2/controller/php_auth.dart';
import 'package:fluttermysql2/screen/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var userData = await PhpAuth().getSessionUserInfo();
    if (userData != null) {
      setState(() {
        user = userData;
      });
    } else {
      Navigator.pushReplacementNamed(context, '/login');
      print('err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            user == null
                ? const CircularProgressIndicator() // Show loader while fetching user data
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username: ${user!['username']}'),
                        Text('Email: ${user!['email']}'),
                        Text('Created At: ${user!['created_at']}'),
                      ],
                    ),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                PhpAuth().logout().then((value) {
                  if (value == "Logout") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        value,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ));
                  }
                });
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
