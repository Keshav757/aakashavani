import 'package:flutter/foundation.dart'; // for Web
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/login_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {  //Checks for Web
    await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBlJTzZqZvTu7LyYSl-5HrlkhulVkEDOI0",
          authDomain: "aakashavani-82310.firebaseapp.com",
          projectId: "aakashavani-82310",
          storageBucket: "aakashavani-82310.appspot.com",
          messagingSenderId: "910152997717",
          appId: "1:910152997717:web:657ee19553953deedc2ddc",
        ),
    );

  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {  //Root Widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aakashavani',
      home: LoginScreen(), //Initial Displayed Screen
    );
  }
}
