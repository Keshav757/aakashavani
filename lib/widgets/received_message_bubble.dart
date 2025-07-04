import 'package:flutter/material.dart';

class ReceivedMessageBubble extends StatelessWidget {
  const ReceivedMessageBubble({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.teal.shade100, // light color
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}
