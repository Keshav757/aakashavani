import 'package:flutter/material.dart';
import '../screens/chat_detail_screen.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final String? profileUrl;
  final bool isUnread;

  const ChatTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.profileUrl,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              name: name,
              profileUrl: profileUrl,
            ),
          ),
        );
      },
      leading: CircleAvatar(
        backgroundImage: profileUrl != null ? NetworkImage(profileUrl!) : null,
        child: profileUrl == null ? const Icon(Icons.person) : null,
      ),
      title: Text(name),
      subtitle: Text(lastMessage),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: const TextStyle(fontSize: 12)),
          if (isUnread)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: const Text(
                "1",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            )
        ],
      ),
    );
  }
}
