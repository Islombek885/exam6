import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NameInputScreen extends StatefulWidget {
  final void Function(String) onNameEntered;

  const NameInputScreen({super.key, required this.onNameEntered});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitName() async {
    final userName = _nameController.text.trim();
    FocusScope.of(context).unfocus();

    if (userName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Ismingizni kiriting!")));
      return;
    }

    if (!RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(userName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Ism 3-20 ta harf/raqam yoki '_' belgidan iborat bo‘lishi kerak!",
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userName);
      final userDoc = await docRef.get();

      final prefs = await SharedPreferences.getInstance();

      if (userDoc.exists) {
        // Foydalanuvchi mavjud => faqat kirish
        await prefs.setString('userName', userName);
        widget.onNameEntered(userName);
      } else {
        // Yangi foydalanuvchini yaratish (rasm yo‘q, lekin keyin qo‘shiladi)
        await docRef.set({'name': userName, 'photoUrl': ''});
        await prefs.setString('userName', userName);
        widget.onNameEntered(userName);
      }
    } catch (e) {
      debugPrint("Xatolik: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Xatolik yuz berdi: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueAccent.shade700;
    final Color backgroundColor = Colors.grey.shade50;
    final Color cardColor = Colors.white;
    final Color fillColor = Colors.blueAccent.shade100.withOpacity(0.1);
    final Color textColor = Colors.grey.shade900;
    final Color buttonTextColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('My Chat App'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: buttonTextColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            shadowColor: primaryColor.withOpacity(0.3),
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 30.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ismingizni kiriting!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Ismingiz',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: fillColor,
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submitName(),
                    maxLength: 20,
                    cursorColor: primaryColor,
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: _submitName,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: primaryColor,
                              foregroundColor: buttonTextColor,
                            ),
                            child: const Text(
                              'Kirish',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
