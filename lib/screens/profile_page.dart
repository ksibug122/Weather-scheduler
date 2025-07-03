import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;

  final nameController = TextEditingController(text: 'Keyro Sibug');
  final birthdayController = TextEditingController(text: 'January 1, 2000');
  final numberController = TextEditingController(text: '09217121469');
  final instagramController = TextEditingController(text: '@keyro_ig');
  final emailController = TextEditingController(text: 'info@aplusdesign.co');
  final passwordController = TextEditingController(text: '••••••••');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: const [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 60, color: Colors.blue),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Keyro Sibug',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Editable Info Fields
            ProfileItemField(
              icon: Icons.person_outline,
              controller: nameController,
              enabled: isEditing,
            ),
            ProfileItemField(
              icon: Icons.cake_outlined,
              controller: birthdayController,
              enabled: isEditing,
            ),
            ProfileItemField(
              icon: Icons.phone_outlined,
              controller: numberController,
              enabled: isEditing,
            ),
            ProfileItemField(
              icon: Icons.camera_alt_outlined,
              controller: instagramController,
              enabled: isEditing,
            ),
            ProfileItemField(
              icon: Icons.mail_outline,
              controller: emailController,
              enabled: isEditing,
            ),
            ProfileItemField(
              icon: Icons.visibility_outlined,
              controller: passwordController,
              enabled: isEditing,
              obscureText: true,
              trailing: const Icon(Icons.sync, size: 18, color: Colors.grey),
            ),

            const SizedBox(height: 32),

            // Bigger Edit/Save Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => isEditing = !isEditing);
                    if (!isEditing) {
                      // Save logic
                      print('Saved: ${nameController.text}');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color(0xFF1976D2),
                  ),
                  child: Text(
                    isEditing ? 'Save Profile' : 'Edit Profile',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class ProfileItemField extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;
  final bool enabled;
  final bool obscureText;
  final Widget? trailing;

  const ProfileItemField({
    super.key,
    required this.icon,
    required this.controller,
    required this.enabled,
    this.obscureText = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32),
      leading: Icon(icon, color: Colors.blue),
      title: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        decoration: const InputDecoration(border: InputBorder.none),
        style: const TextStyle(fontSize: 16),
      ),
      trailing: trailing,
    );
  }
}
