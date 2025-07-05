import 'package:flutter/material.dart';

class ChatDetailScreen extends StatelessWidget {
  final String userId;
  final String userName;
  final String userImage;
  final String userPhone;

  const ChatDetailScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userPhone,
  });

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: userImage.isNotEmpty ? NetworkImage(userImage) : null,
              child: userImage.isEmpty ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 10),
            Text(userName),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Displaying the user's name and phone number
            Text(
              "Name: $userName",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Phone: $userPhone",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text("Chat messages will go here"),
          ],
        ),
      ),
    );
  }
}