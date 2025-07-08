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
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No users found"));
                    }

                    final users = snapshot.data!.docs
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

                        return FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('chats')
                              .doc(chatId)
                              .collection('messages')
                              .orderBy('timestamp', descending: true)
                              .limit(1)
                              .get(),
                          builder: (context, messageSnapshot) {
                            String lastMessage = 'Say hi to $name 👋';
                            String time = '';
                            bool isUnread = false;

                            if (messageSnapshot.hasData &&
                                messageSnapshot.data!.docs.isNotEmpty) {
                              final message = messageSnapshot.data!.docs.first;
                              lastMessage = message['text'];
                              final data = message.data() as Map<String, dynamic>?;
                              bool isUnread = false;
                              if (data != null) {
                                isUnread = !(data.containsKey('isRead') ? data['isRead'] : false) &&
                                          data['receiverId'] == currentUser?.uid;
                              }

                              final timestamp = message['timestamp'];
                              if (timestamp != null && timestamp is Timestamp) {
                                final dateTime = timestamp.toDate();
                                time = TimeOfDay.fromDateTime(dateTime).format(context);
                              }
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
                                      userId: receiverId,
                                      userName: name,
                                      userImage: profileUrl,
                                      userPhone: phone,
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
