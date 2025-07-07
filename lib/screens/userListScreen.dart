import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

import '/screens/multiscreen.dart';
import '/screens/profile_image_screen.dart';

class UserListScreen extends StatefulWidget {
  final String currentUserId;

  const UserListScreen({super.key, required this.currentUserId});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final List<String> avatarUrls = [
    'https://i1.sndcdn.com/avatars-000112742232-y1bpmi-t500x500.jpg',
    'https://miro.medium.com/v2/resize:fit:2400/2*VbG-KPhDrqdcBpcU6GGsYA.png',
    'https://t4.ftcdn.net/jpg/00/94/66/91/360_F_94669163_taoLbRaIz4V2DnEjWZg17V9WygRubBuK.jpg',
    'https://p0.zoon.ru/preview/OLyGnGSBgJX7deGc0gRtPA/2400x1500x85/1/f/a/original_57d8b60640c08816228bf876_57e826c695508.jpg',
    'https://i.pinimg.com/originals/fc/67/03/fc6703e79d41363832817cbdf297beaa.jpg',
    'https://m.media-amazon.com/images/I/B1iSr2M+s-S.jpg',
    'https://jobhelp.campaign.gov.uk/cymraeg/wp-content/uploads/sites/3/2024/04/Capture1.jpg',
    'https://yudent.ru/wp-content/uploads/2020/03/slide3.jpg',
    'https://thumbs.dreamstime.com/b/young-smiling-relaxed-corporate-guy-38456451.jpg',
    'https://avatars.mds.yandex.net/i?id=9fd484d6ce1e2e4fb961f8a5333b64c06155d66f-2037526-images-thumbs&n=13',
    'https://www.mehmetkazandi.com/wp-content/uploads/2015/09/implant-09.jpg',
  ];

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  late Timer _timer;
  String currentTime = '';

  @override
  void initState() {
    super.initState();
    currentTime = _getCurrentTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = _getCurrentTime();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    searchController.dispose();
    super.dispose();
  }

  String _getCurrentTime() {
    return DateFormat('HH:mm:ss').format(DateTime.now());
  }

  String _getDefaultAvatar(int index) {
    return avatarUrls[index % avatarUrls.length];
  }

  Future<String> _getLastMessage(String otherUserId) async {
    final users = [widget.currentUserId, otherUserId]..sort();
    final chatId = md5
        .convert(utf8.encode('${users[0]}_${users[1]}'))
        .toString();

    final messagesRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    final querySnapshot = await messagesRef
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['text'];
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.more_horiz, color: Color(0xFF1DAB61)),
        actions: [
          Row(
            children: [
              Icon(Icons.call_sharp, color: const Color(0xFF1DAB61)),
              IconButton(
                icon: const Icon(
                  Icons.account_circle,
                  color: Color(0xFF1DAB61),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProfileScreen(userName: widget.currentUserId),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Chats",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          // 🔍 Qidiruv maydoni
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Foydalanuvchi qidirish...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Foydalanuvchi topilmadi"));
                }

                final allUsers = snapshot.data!.docs;
                final filteredUsers = allUsers
                    .where(
                      (user) =>
                          user['name'] != widget.currentUserId &&
                          user['name'].toString().toLowerCase().contains(
                            searchQuery,
                          ),
                    )
                    .toList();

                if (filteredUsers.isEmpty) {
                  return const Center(
                    child: Text("Hech qanday foydalanuvchi topilmadi"),
                  );
                }

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (ctx, index) {
                    final user = filteredUsers[index];
                    final userData = user.data() as Map<String, dynamic>;
                    final userName = userData['name'];
                    final hasPhoto = userData.containsKey('photoUrl');
                    final photoUrl = hasPhoto
                        ? userData['photoUrl']
                        : _getDefaultAvatar(index);

                    return FutureBuilder<String>(
                      future: _getLastMessage(userName),
                      builder: (context, messageSnapshot) {
                        final lastMessage = messageSnapshot.data ?? '';

                        return ListTile(
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(photoUrl),
                          ),
                          title: Text(userName),
                          subtitle: Text(
                            lastMessage.isNotEmpty ? lastMessage : "Xabar yo'q",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Text(
                            currentTime,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MultiUserChatScreen(
                                  currentUserId: widget.currentUserId,
                                  otherUserId: userName,
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
            ),
          ),
        ],
      ),
    );
  }
}
