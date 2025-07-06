import 'dart:async';
import 'package:flutter/material.dart';
import 'phone_login_screen.dart';
import '../widgets/type_writer.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> appNames = [
    'Aakashavani',   // English
    'ఆకాశవాణి',        // Telugu
    'आकाशवाणी',       // Hindi
    'ஆகாசவாணி',         // Tamil
  ];

  int _currentIndex = 0;
  late Timer _timer;

  void _handleLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PhoneLoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % appNames.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Hope you have a nice day!'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TypewriterText(
              key: ValueKey<String>(appNames[_currentIndex]),
              text: appNames[_currentIndex],
              style: const TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                fontFamily: 'Poppins',
              ),
              duration: const Duration(milliseconds: 100), // Typing speed
            ),

            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white, // 👈 This sets the text color to white
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),

              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
