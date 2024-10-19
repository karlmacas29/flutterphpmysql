import 'dart:convert';
import 'package:fluttermysql2/controller/php_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SplashScreenLoading extends StatefulWidget {
  const SplashScreenLoading({super.key});

  @override
  State<SplashScreenLoading> createState() => _SplashScreenLoadingState();
}

class _SplashScreenLoadingState extends State<SplashScreenLoading> {
  String _errorMessage = ''; // Error message to display if connection fails
  bool _isLoading = true; // Loading indicator

  @override
  void initState() {
    super.initState();
    _checkDatabaseStatus();
  }

  Future<void> _checkDatabaseStatus() async {
    var url = Uri.parse(
        'http://apifluttermysql.mooo.com/check_connection.php'); // Change to your server URL

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            _checkSession();
          });
        } else {
          setState(() {
            _errorMessage = data['message'] ?? 'Unknown error';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error connecting to the server.';
        _isLoading = false;
      });
    }
  }

  Future<void> _checkSession() async {
    bool isLoggedIn = await PhpAuth().checkSession();
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (_isLoading)
              ? const CircularProgressIndicator()
              : ElevatedButton.icon(
                  label: Text(_errorMessage),
                  onPressed: () {
                    _checkDatabaseStatus();
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                ),
        ],
      ) // Simple loading indicator while checking session
          ),
    );
  }
}
