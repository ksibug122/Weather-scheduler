import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final User? user;
  
  const ProfilePage({super.key, this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  
  late TextEditingController nameController;
  late TextEditingController birthdayController;
  late TextEditingController numberController;
  late TextEditingController instagramController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserData();
  }

  void _initializeControllers() {
    // Initialize controllers with the current user's data or empty values
    nameController = TextEditingController(
      text: widget.user?.displayName ?? ''
    );
    birthdayController = TextEditingController(text: '');
    numberController = TextEditingController(text: '');
    instagramController = TextEditingController(text: '');
    emailController = TextEditingController(
      text: widget.user?.email ?? ''
    );
    passwordController = TextEditingController(text: '••••••••');
  }

  void _loadUserData() async {
    // Load saved profile data from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = widget.user?.uid ?? '';
    
    if (userId.isNotEmpty) {
      setState(() {
        nameController.text = prefs.getString('${userId}_name') ?? 
            widget.user?.displayName ?? '';
        birthdayController.text = prefs.getString('${userId}_birthday') ?? '';
        numberController.text = prefs.getString('${userId}_number') ?? '';
        instagramController.text = prefs.getString('${userId}_instagram') ?? '';
        // Email is readonly from Firebase
        emailController.text = widget.user?.email ?? '';
      });
    }
  }

  void _saveUserData() async {
    // Save profile data to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = widget.user?.uid ?? '';
    
    if (userId.isNotEmpty) {
      await prefs.setString('${userId}_name', nameController.text);
      await prefs.setString('${userId}_birthday', birthdayController.text);
      await prefs.setString('${userId}_number', numberController.text);
      await prefs.setString('${userId}_instagram', instagramController.text);
      
      // Update display name in Firebase if it changed
      if (nameController.text != widget.user?.displayName) {
        try {
          await widget.user?.updateDisplayName(nameController.text);
        } catch (e) {
          print('Error updating display name: $e');
        }
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    birthdayController.dispose();
    numberController.dispose();
    instagramController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: widget.user?.photoURL != null 
                            ? NetworkImage(widget.user!.photoURL!) 
                            : null,
                        child: widget.user?.photoURL == null 
                            ? const Icon(Icons.person, size: 60, color: Colors.blue)
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        nameController.text.isEmpty 
                            ? 'New User' 
                            : nameController.text,
                        style: const TextStyle(
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
              hintText: 'Enter your name',
            ),
            ProfileItemField(
              icon: Icons.cake_outlined,
              controller: birthdayController,
              enabled: isEditing,
              hintText: 'Enter your birthday',
            ),
            ProfileItemField(
              icon: Icons.phone_outlined,
              controller: numberController,
              enabled: isEditing,
              hintText: 'Enter your phone number',
            ),
            ProfileItemField(
              icon: Icons.camera_alt_outlined,
              controller: instagramController,
              enabled: isEditing,
              hintText: 'Enter your Instagram handle',
            ),
            ProfileItemField(
              icon: Icons.mail_outline,
              controller: emailController,
              enabled: false, // Email should not be editable
              hintText: 'Email from account',
            ),
            ProfileItemField(
              icon: Icons.visibility_outlined,
              controller: passwordController,
              enabled: false, // Password should not be editable here
              obscureText: true,
              trailing: GestureDetector(
                onTap: () {
                  // Navigate to change password screen or show dialog
                  _showChangePasswordDialog();
                },
                child: const Icon(Icons.sync, size: 18, color: Colors.grey),
              ),
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
                      _saveUserData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile saved successfully!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
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

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: const Text('To change your password, please use the "Forgot Password" option on the login screen.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class ProfileItemField extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;
  final bool enabled;
  final bool obscureText;
  final Widget? trailing;
  final String? hintText;

  const ProfileItemField({
    super.key,
    required this.icon,
    required this.controller,
    required this.enabled,
    this.obscureText = false,
    this.trailing,
    this.hintText,
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
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: enabled ? hintText : null,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
        ),
        style: TextStyle(
          fontSize: 16,
          color: enabled ? Colors.black : Colors.grey[600],
        ),
      ),
      trailing: trailing,
    );
  }
}