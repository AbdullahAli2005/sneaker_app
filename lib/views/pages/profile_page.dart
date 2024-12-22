import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final String userEmail;

  const ProfilePage({super.key, required this.userEmail});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? address;
  String? phone;
  String? birthday;
  File? profileImage;

  final ImagePicker _picker = ImagePicker();

  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void navigateToFavorites() {
    Navigator.pushNamed(context, '/favorites');
  }

  void navigateToCart() {
    Navigator.pushNamed(context, '/cart');
  }

  void editField(String field, String title, void Function(String) onSave) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFE2E2E2),
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter your $title"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void showImageOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFE2E2E2),
        title: const Text("Profile Picture"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Pick from Gallery"),
              onTap: pickImage,
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Remove Image"),
              onTap: profileImage != null ? removeImage : null,
              enabled: profileImage != null,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }

  Future<void> pickImage() async {
    Navigator.pop(context); // Close the dialog
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  void removeImage() {
    Navigator.pop(context); // Close the dialog
    setState(() {
      profileImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFE2E2E2),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.userEmail,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: showImageOptions,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                    child: profileImage == null
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              buildEditableField(
                icon: Icons.person,
                label: "Name",
                value: name,
                onTap: () => editField(
                    "Name", "name", (value) => setState(() => name = value)),
              ),
              buildEditableField(
                icon: Icons.location_on,
                label: "Address",
                value: address,
                onTap: () => editField("Address", "address",
                    (value) => setState(() => address = value)),
              ),
              buildEditableField(
                icon: Icons.phone,
                label: "Phone",
                value: phone,
                onTap: () => editField(
                    "Phone", "phone", (value) => setState(() => phone = value)),
              ),
              buildEditableField(
                icon: Icons.cake,
                label: "Birthday",
                value: birthday,
                onTap: () => editField("Birthday", "birthday",
                    (value) => setState(() => birthday = value)),
              ),
              const SizedBox(height: 24),
              const Divider(),
              TextButton(
                onPressed: navigateToFavorites,
                style: TextButton.styleFrom(padding: const EdgeInsets.all(16)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Favorites',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.favorite, color: Colors.red),
                  ],
                ),
              ),
              TextButton(
                onPressed: navigateToCart,
                style: TextButton.styleFrom(padding: const EdgeInsets.all(16)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Cart',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.shopping_cart, color: Colors.green),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => signOut(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditableField({
    required IconData icon,
    required String label,
    String? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 16),
            Text(
              value ?? label,
              style: TextStyle(
                fontSize: 16,
                color: value == null ? Colors.grey : Colors.black,
                fontWeight: value == null ? FontWeight.normal : FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
