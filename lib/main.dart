import 'package:chatbot/home_page.dart';
import 'package:chatbot/testing/authentication_wrapper.dart';
import 'package:chatbot/testing/login_page.dart';
import 'package:chatbot/testing/signup_page.dart';
import 'package:chatbot/testing/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding before Firebase

  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    // Using logger instead of print for better production logging
    print("Error loading environment or initializing Firebase: $error");
  }

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return MaterialApp(
      title: 'SUPPORT.IO', 
      debugShowCheckedModeBanner: false,

      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(), // The splash screen is shown first
        '/auth': (context) => AuthWrapper(), // Decides auth state
        '/signup': (context) => SignupPage(), // Signup route
        '/home': (context) => MyHomePage(), // Home route
        '/login': (context) => LoginPage(),

      },
    );
  }
}
