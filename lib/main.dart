import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBlJTzZqZvTu7LyYSl-5HrlkhulVkEDOI0", // required
        authDomain: "aakashavani-82310.firebaseapp.com", // required
        projectId: "aakashavani-82310", // required
        storageBucket: "aakashavani-82310.firebasestorage.app",
        messagingSenderId: "910152997717",
        appId: "1:910152997717:web:657ee19553953deedc2ddc", // required
       
      ),
    );
  } else {
    await Firebase.initializeApp(); // Android/iOS
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aakashavani',
      home: LoginScreen(),
    );
  }
}
