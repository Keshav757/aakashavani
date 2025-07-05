import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/chat_tile.dart';
import './chat_detail_screen.dart';
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
                FilterChip(label: const Text("All"), selected: true, onSelected: (_) {}),
                const SizedBox(width: 8),
                FilterChip(label: const Text("Unread"), onSelected: (_) {}),
                const SizedBox(width: 8),
                FilterChip(label: const Text("Favourites"), onSelected: (_) {}),
                const SizedBox(width: 8),
                FilterChip(label: const Text("Groups"), onSelected: (_) {}),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Chat list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No users found"));
                }

                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final data = user.data() as Map<String, dynamic>;

                    final name = data['name'] ?? 'No Name';
                    final profileUrl = data.containsKey('profileImageUrl') ? data['profileImageUrl'] : '';
                    final lastMessage = 'Say hi to $name 👋';
                    final time = "Now";
                    final phone = data['phone'] ?? 'No Phone'; // Assuming you have 'phone' in Firestore

                    return ChatTile(
                      name: name,
                      lastMessage: lastMessage,
                      time: time,
                      isUnread: false,
                      imageUrl: profileUrl,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatDetailScreen(
                              userId: data['uid'],
                              userName: name,
                              userImage: profileUrl,
                              userPhone: phone, // Pass the phone number here
                            ),
                          ),
                        );
                      },
                    );
                  },
                );

              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          // open new chat logic
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
