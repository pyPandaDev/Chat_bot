import 'package:chatbot/message.dart';
import 'package:chatbot/testing/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = false;
  String _typingText = "";

  callGeminiModel() async {
    try {
      if (_controller.text.isNotEmpty) {
        setState(() {
          _messages.add(Message(text: _controller.text, isUser: true));
          _isLoading = true;
          _typingText = "Bot is typing...";
        });

        final model = GenerativeModel(model: 'gemini-pro', apiKey: dotenv.env['GOOGLE_API_KEY']!);
        final prompt = _controller.text.trim();
        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);

        final generatedText = response.text?.replaceAll('*', '').replaceAll(':', '') ?? "No response received";
        setState(() {
          _messages.add(Message(text: generatedText, isUser: false));
          _isLoading = false;
          _typingText = "";
        });

        _controller.clear();
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
        _typingText = "";
      });
    }
  }

  _logout(BuildContext context) async {
    bool? logoutConfirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Do you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (logoutConfirmed ?? false) {
      Navigator.pushReplacementNamed(context, '/signin'); // Replace with your sign-in page route
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('ChatBot'),
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return SettingsScreen(); // Settings screen shown as half-screen
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildTypingAnimation();
                }
                final message = _messages[index];
                bool isCode = message.text.startsWith('```') && message.text.endsWith('```');

                return ListTile(
                  title: Align(
                    alignment: message.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? Colors.grey[300] 
                            : Colors.transparent, 
                        borderRadius: message.isUser
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              )
                            : const BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                      ),
                      child: isCode
                          ? _buildCodeSection(message.text) 
                          : _buildTextMessage(message.text, message.isUser),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_typingText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _typingText,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 32, top: 16.0, left: 16.0, right: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: null, 
                      style: Theme.of(context).textTheme.titleSmall,
                      decoration: InputDecoration(
                        hintText: 'Write your message',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            child: Image.asset('assets/send.png'),
                            onTap: callGeminiModel,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingAnimation() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            CircleAvatar(
              child: Image.asset('assets/logo.png'),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Text(
              'Bot is typing...',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextMessage(String text, bool isUser) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: isUser
                ? Theme.of(context).textTheme.bodyMedium
                : Theme.of(context).textTheme.bodySmall,
          ),
        ),
        if (!isUser)
          IconButton(
            icon: Icon(Icons.copy, size: 16),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Copied to clipboard")),
              );
            },
          ),
      ],
    );
  }

  Widget _buildCodeSection(String code) {
    final cleanCode = code.replaceAll('```', ''); 
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              cleanCode,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontFamily: 'Courier', 
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 16, color: Colors.white),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: cleanCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Code copied to clipboard")),
              );
            },
          ),
        ],
      ),
    );
  }
}
