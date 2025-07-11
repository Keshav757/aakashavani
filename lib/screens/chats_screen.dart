import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/chat_tile.dart';
import './chat_detail_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  String _getChatId(String uid1, String uid2) {
    return uid1.compareTo(uid2) < 0 ? '$uid1\_$uid2' : '$uid2\_$uid1';
  }

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
            child: FutureBuilder<User?>(
              future: FirebaseAuth.instance.authStateChanges().first,
              builder: (context, authSnapshot) {
                if (!authSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final currentUser = authSnapshot.data!;
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No users found"));
                    }

                    final users = userSnapshot.data!.docs
                        .where((doc) => doc['uid'] != currentUser.uid)
                        .toList();

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final data = user.data() as Map<String, dynamic>;
                        final name = data['name'] ?? 'No Name';
                        final profileUrl = data['profileImageUrl'] ?? '';
                        final phone = data['phone'] ?? '';
                        final receiverId = data['uid'];
                        final chatId = _getChatId(currentUser.uid, receiverId);

                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chats')
                              .doc(chatId)
                              .snapshots(),
                          builder: (context, chatSnapshot) {
                            String lastMessage = 'Say hi to $name 👋';
                            String time = '';
                            bool isUnread = false;

                            if (chatSnapshot.hasData && chatSnapshot.data!.exists) {
                              final chatData = chatSnapshot.data!.data() as Map<String, dynamic>;

                              lastMessage = chatData['lastMessage'] ?? lastMessage;

                              final timestamp = chatData['lastMessageTime'];
                              if (timestamp != null && timestamp is Timestamp) {
                                final dateTime = timestamp.toDate();
                                time = TimeOfDay.fromDateTime(dateTime).format(context);
                              }

                              // Optional: You could enhance unread tracking using 'isRead' logic
                              // if you store it on the last message.
                            }

                            return ChatTile(
                              name: name,
                              lastMessage: lastMessage,
                              time: time,
                              isUnread: isUnread,
                              imageUrl: profileUrl,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatDetailScreen(
                                      chatId: chatId,
                                      receiverId: receiverId,
                                      name: name,
                                      profileUrl: profileUrl,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
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
          // Add logic for starting a new chat
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
