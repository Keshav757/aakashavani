import 'package:flutter/material.dart';
import '../widgets/chat_tile.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aakashavani"),
        actions: const [
          Icon(Icons.camera_alt),
          SizedBox(width: 16),
          Icon(Icons.more_vert),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search favourite chats",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                FilterChip(label: const Text("All"), onSelected: (_) {}),
                const SizedBox(width: 8),
                FilterChip(label: const Text("Unread"), onSelected: (_) {}),
                const SizedBox(width: 8),
                FilterChip(label: const Text("Favourites"), selected: true, onSelected: (_) {}),
                const SizedBox(width: 8),
                FilterChip(label: const Text("Groups"), onSelected: (_) {}),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Chat list
          Expanded(
            child: ListView(
              children: const [
                ChatTile(
                  name: "Tricia 🌷",
                  lastMessage: "📞 Missed voice call",
                  time: "10:00",
                  isUnread: false,
                ),
                ChatTile(
                  name: "Amanda",
                  lastMessage: "🥰🥰🥰",
                  time: "09:12",
                  isUnread: true,
                ),
                ChatTile(
                  name: "Psalm",
                  lastMessage: "✔️ Alright",
                  time: "08:50",
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          // open new chat
        },
        child: const Icon(Icons.chat),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Chats selected
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: "Updates"),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Communities"),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
        ],
      ),
    );
  }
}
