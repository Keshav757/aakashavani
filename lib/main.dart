import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'screens/profile_setup_screen.dart'; // Make sure the path is correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBlJTzZqZvTu7LyYSl-5HrlkhulVkEDOI0",
        authDomain: "aakashavani-82310.firebaseapp.com",
        projectId: "aakashavani-82310",
        storageBucket: "aakashavani-82310.firebasestorage.app",
        messagingSenderId: "910152997717",
        appId: "1:910152997717:web:657ee19553953deedc2ddc",
      ),
    );
  } else {
    await Firebase.initializeApp(); // for Android/iOS
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aakashavani',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ProfileSetupScreen(), // ✅ Use your screen directly
    );
  }
}
