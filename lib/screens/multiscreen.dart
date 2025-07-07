import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../utils/chat_utils.dart';
import '../widgets/bubble.dart';
import '../widgets/message_input_field.dart';

class MultiUserChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;

  const MultiUserChatScreen({
    required this.currentUserId,
    required this.otherUserId,
    super.key,
  });

  @override
  State<MultiUserChatScreen> createState() => _MultiUserChatScreenState();
}

class _MultiUserChatScreenState extends State<MultiUserChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late final String chatId;

  @override
  void initState() {
    super.initState();
    chatId = generateChatId(widget.currentUserId, widget.otherUserId);
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
          'text': text,
          'senderId': widget.currentUserId,
          'timestamp': FieldValue.serverTimestamp(),
        });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        leading: const BackButton(color: Colors.white),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(radius: 20, backgroundImage: NetworkImage(' ')),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherUserId,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'Online',
                  style: TextStyle(color: Color(0xFF64D2FF), fontSize: 13),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.video_call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == widget.currentUserId;
                    DateTime time = DateTime.now();
                    if (msg['timestamp'] != null) {
                      time = (msg['timestamp'] as Timestamp).toDate();
                    }
                    return MessageBubble(
                      text: msg['text'],
                      isMe: isMe,
                      timestamp: time,
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          MessageInputField(controller: _controller, onSend: _sendMessage),
        ],
      ),
    );
  }
}
