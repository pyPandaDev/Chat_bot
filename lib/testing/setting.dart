import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  get context => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThemeToggle(context), // Theme Mode Toggle
            SizedBox(height: 20),
            _buildAccountSection(), // Account section
            SizedBox(height: 20),
            _buildAboutSection(), // About and License section
            Spacer(),
            _buildCopyrightSection(), // Copyright at the bottom
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Theme Mode', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          children: [
            Text('Light Mode', style: TextStyle(fontSize: 16)),
            Spacer(),
            GestureDetector(
              onTap: () {
                // Toggle between light and dark modes
                // Add your theme change logic here (e.g., using Provider or Riverpod)
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text('Toggle', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.email_outlined, size: 24),
            SizedBox(width: 10),
            Text(getUserEmail(), style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.subscriptions_outlined, size: 24),
            SizedBox(width: 10),
            Text('Free Plan', style: TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'ChatBot',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2024 Pava. All rights reserved.',
            );
          },
          child: Text(
            'About this app',
            style: TextStyle(fontSize: 16, decoration: TextDecoration.underline),
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            // Navigate to License page or show licenses
          },
          child: Text(
            'Licenses',
            style: TextStyle(fontSize: 16, decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }

  Widget _buildCopyrightSection() {
    return Center(
      child: Text(
        '© 2024 Pava. All rights reserved.',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }

  String getUserEmail() {
    // Your logic to get the user's email
    return 'user_email@example.com';
  }
}
