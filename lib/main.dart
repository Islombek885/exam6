import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/screens/nameInputScreen.dart';
import '/screens/userListScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const RootApp());
}

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  String? savedUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedUser = prefs.getString('userName');
    });
  }

  void _onNameEntered(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    setState(() {
      savedUser = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: savedUser == null
          ? NameInputScreen(onNameEntered: _onNameEntered)
          : UserListScreen(currentUserId: savedUser!),
    );
  }
}
//? Assalomu Aleykum 12866
//? Assalomu Aleykum 12867
//? Assalomu Aleykum 12868
//? Assalomu Aleykum 12869
//? Assalomu Aleykum 12870
//? Assalomu Aleykum 12871
//? Assalomu Aleykum 12872
//? Assalomu Aleykum 12873
//? Assalomu Aleykum 12874
//? Assalomu Aleykum 12875