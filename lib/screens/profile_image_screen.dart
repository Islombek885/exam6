import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  const ProfileScreen({super.key, required this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _photoUrl;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserPhoto();
    _loadUserInfo();
  }

  Future<void> _loadUserPhoto() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userName)
        .get();
    if (doc.exists && doc.data()!.containsKey('photoUrl')) {
      setState(() {
        _photoUrl = doc['photoUrl'];
      });
    }
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstNameController.text = prefs.getString('firstName') ?? '';
      lastNameController.text = prefs.getString('lastName') ?? '';
      ageController.text = prefs.getString('age') ?? '';
      locationController.text = prefs.getString('location') ?? '';
    });
  }

  Future<void> _saveUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstNameController.text);
    await prefs.setString('lastName', lastNameController.text);
    await prefs.setString('age', ageController.text);
    await prefs.setString('location', locationController.text);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Ma'lumotlar saqlandi ✅")));
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final file = File(picked.path);
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('${widget.userName}.jpg');

    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userName)
        .update({'photoUrl': url});

    setState(() {
      _photoUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Salom, ${widget.userName} 👋',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: _photoUrl != null
                  ? NetworkImage(_photoUrl!)
                  : null,
              child: _photoUrl == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _pickAndUploadImage,
              icon: const Icon(Icons.image),
              label: const Text("Rasm tanlash"),
            ),
            const SizedBox(height: 30),

            // Inputlar
            _buildTextField(firstNameController, 'Ismingiz'),
            const SizedBox(height: 10),
            _buildTextField(lastNameController, 'Familiyangiz'),
            const SizedBox(height: 10),
            _buildTextField(ageController, 'Yoshingiz'),
            const SizedBox(height: 10),
            _buildTextField(locationController, 'Yashash joyingiz'),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveUserInfo,
              icon: const Icon(Icons.save),
              label: const Text("Ma'lumotlarni saqlash"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
