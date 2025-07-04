import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  final String name;
  final String? profileUrl;

  const UserProfileScreen({
    super.key,
    required this.name,
    this.profileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EDF9), // WhatsApp-like light background
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center( // Ensures everything is centered both vertically and horizontally
        child: Column(
          mainAxisSize: MainAxisSize.min, // Only takes the needed vertical space
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.purple.shade100,
              backgroundImage:
                  profileUrl != null ? NetworkImage(profileUrl!) : null,
              child: profileUrl == null
                  ? Icon(Icons.person, size: 50, color: Colors.purple.shade700)
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Hey there! I am using Aakashavani",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
