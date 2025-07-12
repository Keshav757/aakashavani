import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String receiverId;
  final String name;
  final String? profileUrl;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.receiverId,
    required this.name,
    this.profileUrl,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || uid == null) return;

    final messageRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .doc();

    await messageRef.set({
      'text': text,
      'senderId': uid,
      'receiverId': widget.receiverId,
      'timestamp': FieldValue.serverTimestamp(),
      'isDelivered': false,
      'isRead': false,
    });

    await FirebaseFirestore.instance.collection('chats').doc(widget.chatId).set({
      'participants': [uid, widget.receiverId],
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.profileUrl != null
                  ? NetworkImage(widget.profileUrl!)
                  : null,
              child: widget.profileUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(widget.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                // Update delivery & read status
                for (var msg in messages) {
                  final data = msg.data() as Map<String, dynamic>;

                  if (data['receiverId'] == uid) {
                    if (data['isDelivered'] == false) {
                      msg.reference.update({'isDelivered': true});
                    }

                    // Optionally mark as read
                    if (data['isRead'] == false) {
                      msg.reference.update({'isRead': true});
                    }
                  }
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final data = message.data() as Map<String, dynamic>;

                    final isMe = data['senderId'] == uid;
                    final text = data['text'] ?? '';
                    final timestamp = data['timestamp'];
                    final isDelivered = data.containsKey('isDelivered') ? data['isDelivered'] : false;
                    final isRead = data.containsKey('isRead') ? data['isRead'] : false;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(text),
                            if (isMe)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 4),
                                  Icon(
                                    isRead
                                        ? Icons.done_all
                                        : isDelivered
                                            ? Icons.done_all
                                            : Icons.check,
                                    size: 16,
                                    color: isRead ? Colors.blue : Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  if (timestamp != null && timestamp is Timestamp)
                                    Text(
                                      TimeOfDay.fromDateTime(timestamp.toDate()).format(context),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
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
                    onSubmitted: (_) => _sendMessage(),
                    textInputAction: TextInputAction.send,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
