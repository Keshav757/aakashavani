import 'package:flutter/material.dart';
import '../widgets/sent_message_bubble.dart';
import '../widgets/received_message_bubble.dart';

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String? profileUrl;

  const ChatDetailScreen({
    super.key,
    required this.name,
    this.profileUrl,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Sample messages
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hey there!', 'isMe': true},
    {'text': 'Hello! How are you?', 'isMe': false},
    {'text': 'I’m good. What about you?', 'isMe': true},
  ];

  void _sendMessage() {
    String msg = _messageController.text.trim();
    if (msg.isEmpty) return;

    setState(() {
      _messages.add({'text': msg, 'isMe': true});
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  widget.profileUrl != null ? NetworkImage(widget.profileUrl!) : null,
              child: widget.profileUrl == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 10),
            Text(widget.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return message['isMe']
                    ? SentMessageBubble(text: message['text'])
                    : ReceivedMessageBubble(text: message['text']);
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
