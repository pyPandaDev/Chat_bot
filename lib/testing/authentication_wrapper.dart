import 'package:chatbot/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';  

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the connection is still in progress, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If the user is authenticated, navigate to the home page
        if (snapshot.hasData) {
          return MyHomePage();  // Replace with your HomePage widget
        } else {
          // If no user is authenticated, show the login page
          return LoginPage();
        }
      },
    );
  }
}
