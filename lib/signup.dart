import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skkn/login.dart'; // Import your login page widget

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  DateTime? _selectedDate;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // After successful sign-up, navigate to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error signing up: $e');
      // Handle sign-up errors here (e.g., show a snackbar with error message)
      // For example:
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Error signing up. Please try again.'),
      // ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/4.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100), // Added SizedBox for spacing
                Text(
                  'Email',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email is required';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20), // Added SizedBox for spacing
                Text(
                  'Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                SizedBox(height: 20), // Added SizedBox for spacing
                Text(
                  'Confirm Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Confirm password is required';
                    } else if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Date of Birth: '),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text(_selectedDate?.formatted() ?? 'Select Date'), // Use formatted method
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: _signUp,
                    child: Text('Sign Up'),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on DateTime {
  String formatted() {
    return DateFormat.yMd().format(this);
  }
}
