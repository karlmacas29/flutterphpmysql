import 'dart:convert';

import 'package:http/http.dart' as http;

// Store session cookie globally
String? sessionId;

class PhpAuth {
  String baseUrl = 'apifluttermysql.mooo.com';
  String urlPathRegister = '/register.php';
  String urlPathLogin = '/login.php';
  String urlPathCheck = '/check_session.php';
  String urlPathLogout = '/logout.php';

  //register
  Future<String> registerUser(
    String username,
    String email,
    String password,
  ) async {
    var url = Uri.http(baseUrl, urlPathRegister);
    var response = await http.post(
      url,
      body: {
        "username": username,
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["status"] == "Success") {
        // Store session ID from the response
        // Assign the session ID from the response
        sessionId = data["session_id"];
        print("Session ID stored: $sessionId");

        return "Registration successful";
      } else {
        return "Error: $data"; // Return the error message
      }
    } else {
      return "Error: Failed to connect ${response.statusCode}";
    }
  }

  //login
  Future<String> loginUser(
    String email,
    String password,
  ) async {
    var url = Uri.http(baseUrl, urlPathLogin);
    var response = await http.post(
      url,
      body: {
        "email": email,
        "password": password,
      },
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 'Success') {
        // Store session ID from the response
        sessionId = data["session_id"];
        print("Session ID stored: $sessionId");

        return "Login Successful";
      } else {
        return "Error: $data"; // Return the error message
      }
    } else {
      return "Error: Failed to connect: ${response.statusCode}";
    }
  }

  //checking
  Future<bool> checkSession() async {
    final response = await http.get(
      Uri.http(baseUrl, urlPathCheck),
      headers: {
        'Cookie': 'PHPSESSID=$sessionId',
      },
    );
    print('Checking session id:$sessionId');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'No active session') {
        return false;
      } else {
        return true;
      }
    }
    return true;
  }

  // Getting user session info
  Future<Map<String, dynamic>?> getSessionUserInfo() async {
    try {
      // Replace baseUrl with session URL directly
      var sessionUrl = Uri.http(baseUrl, urlPathCheck);
      final sessionResponse = await http.get(
        sessionUrl,
        headers: {
          'Cookie':
              'PHPSESSID=$sessionId', // Use the session ID stored during login
        },
      );
      print('check ssis $sessionId');
      // Check if the request was successful
      if (sessionResponse.statusCode == 200) {
        var sessionData = json.decode(sessionResponse.body);

        // Check if the status is success
        if (sessionData['status'] == 'Success') {
          // Extract the user data from the nested 'user' object
          var user = sessionData['user'];
          print(
              'Data: ${user['username']} , ${user['email']} , ${user['created_at']}');
          // Validate if the 'user' contains the expected fields
          if (user != null &&
              user['username'] != null &&
              user['email'] != null &&
              user['created_at'] != null) {
            // Map the data directly from the 'user' object
            Map<String, dynamic> userData = {
              'username': user['username'],
              'email': user['email'],
              'created_at': user['created_at'],
            };

            return userData;
          } else {
            // If any required field is missing
            print('Session data missing required user fields');
            return null;
          }
        } else {
          // If the status is not 'Success'
          print(
              'Failed to retrieve user session info: ${sessionData['status']}');
          return null;
        }
      } else {
        // If the status code is not 200
        print(
            'Failed to load session data, status code: ${sessionResponse.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle errors gracefully
      print('Error fetching session data: $e');
      return null;
    }
  }

  // Logout function
  Future<String> logout() async {
    var url = Uri.http(baseUrl, urlPathLogout);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == "Logout successful") {
        print('logout');
        sessionId = null;
        return 'Logout';
      }
    }
    return 'error: ${response.statusCode}';
  }
}
