import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './profile_setup_screen.dart';
import './chats_screen.dart'; 

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});
  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationId;
  bool _isOtpSent = false;
  bool _isLoading = false;

  void _sendOtp() async {
    setState(() => _isLoading = true);
    final phone = '+91${_phoneController.text.trim()}';

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          await _savePhoneNumberToDatabase(phone);
          await navigateAfterLogin(context); // 🔁 Directly navigate after auto verification
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed: ${e.message}")),
          );
          setState(() => _isLoading = false);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isOtpSent = true;
            _verificationId = verificationId;
            _isLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
      setState(() => _isLoading = false);
    }
  }

  void _verifyOtp() async {
    setState(() => _isLoading = true);
    final otp = _otpController.text.trim();

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);

      final phone = '+91${_phoneController.text.trim()}';
      await _savePhoneNumberToDatabase(phone);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number verified.")),
      );

      await navigateAfterLogin(context); // ✅ Check if profile exists
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error verifying OTP: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _savePhoneNumberToDatabase(String phone) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        await _firestore.collection('users').doc(uid).set({
          'phone': phone,
          'uid': uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  Future<void> navigateAfterLogin(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDoc.exists && userDoc.data()?['name'] != null) {
        // Profile is set up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ChatsScreen()),
        );
      } else {
        // First-time login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ProfileSetupScreen(uid: user.uid)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Login"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isOtpSent) ...[
              const Text("Enter your phone number", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                  prefixText: '+91 ',
                ),
              ),
            ] else ...[
              const Text("Enter the OTP", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 12),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'OTP',
                ),
              ),
            ],
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: Text(_isOtpSent ? "Verify OTP" : "Send OTP"),
                  ),
          ],
        ),
      ),
    );
  }
}
