import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String verificationId = "";
  bool otpSent = false;

  void sendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          otpSent = true;
          verificationId = verId;
        });
      },
      codeAutoRetrievalTimeout: (String verId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpController.text,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged in successfully!")));
      // TODO: Navigate to Chat Screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid OTP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login with Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: otpSent
            ? Column(
                children: [
                  TextField(
                    controller: otpController,
                    decoration: InputDecoration(labelText: 'Enter OTP'),
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(onPressed: verifyOTP, child: Text("Verify OTP")),
                ],
              )
            : Column(
                children: [
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Enter phone number (e.g. +91...)'),
                    keyboardType: TextInputType.phone,
                  ),
                  ElevatedButton(onPressed: sendOTP, child: Text("Send OTP")),
                ],
              ),
      ),
    );
  }
}
