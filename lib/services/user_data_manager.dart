import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataManager {
  static const String _keyPrefix = 'user_data_';
  
  // Save user profile data
  static Future<void> saveUserProfile({
    required String userId,
    String? name,
    String? birthday,
    String? phoneNumber,
    String? instagram,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (name != null) {
      await prefs.setString('${_keyPrefix}${userId}_name', name);
    }
    if (birthday != null) {
      await prefs.setString('${_keyPrefix}${userId}_birthday', birthday);
    }
    if (phoneNumber != null) {
      await prefs.setString('${_keyPrefix}${userId}_phone', phoneNumber);
    }
    if (instagram != null) {
      await prefs.setString('${_keyPrefix}${userId}_instagram', instagram);
    }
  }
  
  // Load user profile data
  static Future<Map<String, String>> loadUserProfile(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    
    return {
      'name': prefs.getString('${_keyPrefix}${userId}_name') ?? '',
      'birthday': prefs.getString('${_keyPrefix}${userId}_birthday') ?? '',
      'phone': prefs.getString('${_keyPrefix}${userId}_phone') ?? '',
      'instagram': prefs.getString('${_keyPrefix}${userId}_instagram') ?? '',
    };
  }
  
  // Clear user profile data (useful for logout)
  static Future<void> clearUserProfile(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.remove('${_keyPrefix}${userId}_name');
    await prefs.remove('${_keyPrefix}${userId}_birthday');
    await prefs.remove('${_keyPrefix}${userId}_phone');
    await prefs.remove('${_keyPrefix}${userId}_instagram');
  }
  
  // Get display name with fallback
  static String getDisplayName(User? user) {
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    
    // Extract name from email (before @)
    if (user?.email != null) {
      return user!.email!.split('@')[0];
    }
    
    return 'User';
  }
  
  // Update Firebase display name
  static Future<bool> updateDisplayName(User user, String newName) async {
    try {
      await user.updateDisplayName(newName);
      await user.reload(); // Refresh user data
      return true;
    } catch (e) {
      print('Error updating display name: $e');
      return false;
    }
  }
}

