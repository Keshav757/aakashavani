import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final bool isUnread;
  final String? imageUrl; 
  final VoidCallback? onTap;// ✅ Add this line

  const ChatTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.isUnread = false,
    this.imageUrl, // ✅ Add this line
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey[300],
        backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
            ? NetworkImage(imageUrl!)
            : null,
        child: imageUrl == null || imageUrl!.isEmpty
            ? const Icon(Icons.person, color: Colors.white)
            : null,
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(lastMessage),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 12,
          color: isUnread ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
