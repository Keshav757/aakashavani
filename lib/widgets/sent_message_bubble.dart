import 'package:flutter/material.dart';

class SentMessageBubble extends StatelessWidget {
  const SentMessageBubble({super.key, required this.text});
  
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.teal.shade600, // dark color for sent messages
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text, // ✅ use text instead of message
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
