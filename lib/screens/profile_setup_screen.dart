import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void _onContinue() {
    String name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a name")),
      );
      return;
    }

    // You can now use name + _image to send to backend or next screen
    print("Name: $name");
    print("Image path: ${_image?.path}");

    // Navigate or save data here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: const Text("Profile info")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            const SizedBox(height: 20),
            const Text(
                "Please provide your name and an optional profile photo",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey[300],
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? const Icon(Icons.add_a_photo, size: 30, color: Colors.grey)
                    : null,
                ),
            ),
            const SizedBox(height: 30),
            TextField(
                controller: _nameController,
                maxLength: 25,
                decoration: const InputDecoration(
                labelText: "Your name",
                border: UnderlineInputBorder(),
                suffixIcon: Icon(Icons.emoji_emotions_outlined),
                ),
            ),
            const Spacer(),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _onContinue,
                child: const Text("Next"),
                ),
            ),
            ],
        ),
        ),

    );
  }
}
