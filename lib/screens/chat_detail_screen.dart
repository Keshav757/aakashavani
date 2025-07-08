import 'package:flutter/material.dart';

class ChatDetailScreen extends StatelessWidget {
  final String name;
  final String? profileUrl;

  const ChatDetailScreen({
    super.key,
    required this.name,
    this.profileUrl, // ✅ Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  profileUrl != null ? NetworkImage(profileUrl!) : null,
              child: profileUrl == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 10),
            Text(name),
          ],
        ),
      ),
      body: const Center(
        child: Text("Chat messages will appear here."),
      ),
    );
  }
}
