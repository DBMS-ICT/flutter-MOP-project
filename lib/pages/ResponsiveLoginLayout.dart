import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import for localization
import 'package:new_peshmargah_pro/pages/helthy.dart';
import 'fbi.dart';
import 'ict_page.dart'; // Import your Healthy page
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import for JSON encoding/decoding

class ResponsiveLoginLayout extends StatefulWidget {
  final Function(Locale) onLocaleChange; // Callback for language change

  ResponsiveLoginLayout(
      {required this.onLocaleChange}); // Add the required parameter

  @override
  State<ResponsiveLoginLayout> createState() => _ResponsiveLoginLayoutState();
}

class _ResponsiveLoginLayoutState extends State<ResponsiveLoginLayout> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    // Determine layout based on screen width
    if (screenWidth >= 1200) {
      return _buildLoginLayout(context, orientation, layoutType: 'desktop');
    } else if (screenWidth >= 600) {
      return _buildLoginLayout(context, orientation, layoutType: 'tablet');
    } else {
      return _buildLoginLayout(context, orientation, layoutType: 'mobile');
    }
  }

  // Build the login layout based on the type
  Widget _buildLoginLayout(BuildContext context, Orientation orientation,
      {required String layoutType}) {
    double fontSize;
    EdgeInsets buttonPadding;
    EdgeInsets margin;
    double imageWidth, imageHeight;

    // Customize layout based on device type
    if (layoutType == 'desktop') {
      fontSize = 40;
      buttonPadding = EdgeInsets.symmetric(horizontal: 100, vertical: 20);
      margin = EdgeInsets.fromLTRB(100, 90, 100, 0);
      imageWidth = 500;
      imageHeight = 300;
    } else if (layoutType == 'tablet') {
      fontSize = 35;
      buttonPadding = EdgeInsets.symmetric(horizontal: 70, vertical: 20);
      margin = EdgeInsets.fromLTRB(40, 90, 40, 0);
      imageWidth = 400;
      imageHeight = 200;
    } else {
      fontSize = 30;
      buttonPadding = EdgeInsets.symmetric(horizontal: 50, vertical: 15);
      margin = EdgeInsets.fromLTRB(20, 90, 20, 0);
      imageWidth = 400;
      imageHeight = 400;
    }

    return Scaffold(
      body: Container(
        margin: margin,
        child: SingleChildScrollView(
          child: layoutType == 'mobile'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildLoginContent(context, fontSize, buttonPadding,
                      imageWidth: imageWidth, imageHeight: imageHeight),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 2, child: _buildImage(imageWidth, imageHeight)),
                    SizedBox(width: layoutType == 'desktop' ? 60 : 40),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildLoginContent(
                            context, fontSize, buttonPadding),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // Build common login fields
  List<Widget> _buildLoginContent(
      BuildContext context, double fontSize, EdgeInsets buttonPadding,
      {double? imageWidth, double? imageHeight}) {
    return [
      if (imageWidth != null && imageHeight != null)
        _buildImage(imageWidth, imageHeight),
      SizedBox(height: imageWidth != null ? 20 : 0),
      AutoSizeText(
        AppLocalizations.of(context)!.signIn,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(135, 36, 36, 1.0),
        ),
      ),
      SizedBox(height: 30),
      _buildEmailField(context),
      SizedBox(height: 30),
      _buildPasswordField(context),
      SizedBox(height: 25),
      if (_errorMessage.isNotEmpty)
        Text(
          _errorMessage,
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      SizedBox(height: 10),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: buttonPadding,
          shape: ContinuousRectangleBorder(
            side: BorderSide(
              width: 5,
              color: Color.fromRGBO(135, 36, 36, 1.0),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: _login,
        child: Text(
          AppLocalizations.of(context)!.logIn,
          style: TextStyle(
            fontSize: fontSize * 0.75,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(135, 36, 36, 1.0),
          ),
        ),
      ),
    ];
  }

  // Image widget
  Widget _buildImage(double width, double height) {
    return Center(
      child: Image.asset(
        'assets/img/img1.png',
        width: width,
        height: height,
      ),
    );
  }

  // Email field widget
  TextField _buildEmailField(BuildContext context) {
    return TextField(
      controller: _emailController,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 5)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: AppLocalizations.of(context)!.email,
        labelStyle: TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(135, 36, 36, 1.0),
            fontWeight: FontWeight.bold),
        hintText: '*********@gmail.com',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 5)),
      ),
    );
  }

  // Password field widget with visibility toggle
  TextField _buildPasswordField(BuildContext context) {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 5)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: AppLocalizations.of(context)!.password,
        labelStyle: TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(135, 36, 36, 1.0),
            fontWeight: FontWeight.bold),
        hintText: '*********',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 5)),
      ),
    );
  }

  // Login action
  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validate email and password before sending the POST request
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Email and password cannot be empty';
      });
      return; // Exit if validation fails
    }

    // Call the method to send data via POST
    _sendDataToDatabase(email, password);
  }

// Method to simulate sending data via POST
  Future<void> _sendDataToDatabase(String email, String password) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(Duration(seconds: 2));

    // Default simulated response
    String role = 'unknown'; // Default role if credentials don't match
    String message = 'Login failed'; // Default error message

    print('Simulating POST request...');
    print('Email: $email');
    print('Password: $password');

    // Check the email and password combinations
    if (email == 'ict123@gmail.com' && password == '12345ict') {
      role = 'ict';
      message = 'Login successful';
    } else if (email == 'helthy123@gmail.com' && password == 'heltht123') {
      role = 'healthy';
      message = 'Login successful';
    } else if (email == 'fbi123@gmail.com' && password == 'fbi12345') {
      role = 'fbi';
      message = 'Login successful';
    } else {
      // If none of the credentials matched, set the error message
      message = 'Invalid email or password';
    }

    // Print the simulated response
    print(
        'Simulated Response: { "status": "success", "role": "$role", "message": "$message" }');

    // Mocking the success scenario
    if (message == 'Login successful') {
      print('Login successful, navigating to role-specific page: $role');
      // Navigate to appropriate page based on user role
      switch (role) {
        case 'ict':
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => IctPage()));
          break;
        case 'fbi':
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => FbiPage()));
          break;
        case 'healthy':
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HealthtPage()));
          break;
        default:
          setState(() {
            _errorMessage = 'Invalid credentials';
          });
      }
    } else {
      // Handle unsuccessful login
      print('Login failed: $message');
      setState(() {
        _errorMessage = message; // Set the error message
      });
    }
  }
}
// // Method to send data via POST
// Future<void> _sendDataToDatabase(String email, String password) async {
//   final url = 'https://yourapiendpoint.com/api/login'; // Replace with your API endpoint
//   print('Attempting to send POST request to: $url'); // Print the URL being requested
//
//   try {
//     // Create the request body
//     final requestBody = jsonEncode({
//       'email': email,
//       'password': password,
//     });
//     print('Request Body: $requestBody'); // Print the request body
//
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json', // Specify the content type
//       },
//       body: requestBody,
//     );
//
//     // Print the response status code and body
//     print('Response Status Code: ${response.statusCode}'); // Print the status code
//     print('Response Body: ${response.body}'); // Print the response body
//
//     // Check the response status
//     if (response.statusCode == 200) {
//       // Successfully sent data
//       // Handle the response from the server
//       final responseData = jsonDecode(response.body);
//       print('Response Data: $responseData'); // Print the decoded response data
//
//       // Optionally navigate based on response data
//       if (responseData['status'] == 'success') {
//         print('Login successful, navigating to role-specific page: ${responseData['role']}'); // Print role
//         // Navigate to appropriate page based on user role
//         switch (responseData['role']) {
//           case 'ict':
//             Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (context) => IctPage()));
//             break;
//           case 'fbi':
//             Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (context) => FbiPage()));
//             break;
//           case 'healthy':
//             Navigator.pushReplacement(context,
//                 MaterialPageRoute(builder: (context) => HealthtPage()));
//             break;
//           default:
//             setState(() {
//               _errorMessage = 'Invalid credentials';
//             });
//         }
//       } else {
//         setState(() {
//           _errorMessage = responseData['message'] ?? 'Login failed';
//         });
//       }
//     } else {
//       // Handle error response
//       print('Error response: ${response.reasonPhrase}'); // Print error reason phrase
//       setState(() {
//         _errorMessage = 'Failed to login: ${response.reasonPhrase}';
//       });
//     }
//   } catch (error) {
//     // Handle any exceptions that occur
//     print('Exception occurred: $error'); // Print the exception
//     setState(() {
//       _errorMessage = 'An error occurred: $error';
//     });
//   }
// }
