import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FeedbackService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'feedback';

  /// Submit feedback to Firestore
  static Future<void> submitFeedback({
    required String userId,
    required String userEmail,
    required String category,
    required int priority,
    required String subject,
    required String message,
  }) async {
    try {
      // Create feedback document
      final feedbackData = {
        'userId': userId,
        'userEmail': userEmail,
        'category': category,
        'priority': priority,
        'priorityText': _getPriorityText(priority),
        'subject': subject,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'open', // open, in_progress, resolved, closed
        'deviceInfo': await _getDeviceInfo(),
        'appVersion': '1.0.0', // Update this based on your app version
      };

      // Add to Firestore
      await _firestore.collection(_collection).add(feedbackData);
      
      if (kDebugMode) {
        print('Feedback submitted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting feedback: $e');
      }
      rethrow;
    }
  }

  /// Get user's feedback history
  static Future<List<Map<String, dynamic>>> getUserFeedback(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user feedback: $e');
      }
      return [];
    }
  }

  /// Get all feedback (for admin/developer use)
  static Stream<QuerySnapshot> getAllFeedbackStream() {
    return _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Update feedback status (for admin/developer use)
  static Future<void> updateFeedbackStatus(String feedbackId, String status) async {
    try {
      await _firestore.collection(_collection).doc(feedbackId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating feedback status: $e');
      }
      rethrow;
    }
  }

  /// Add developer response to feedback
  static Future<void> addDeveloperResponse(
    String feedbackId,
    String response,
    String developerId,
  ) async {
    try {
      await _firestore.collection(_collection).doc(feedbackId).update({
        'developerResponse': response,
        'developerId': developerId,
        'responseTimestamp': FieldValue.serverTimestamp(),
        'status': 'responded',
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding developer response: $e');
      }
      rethrow;
    }
  }

  /// Get feedback statistics (for admin dashboard)
  static Future<Map<String, int>> getFeedbackStats() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      
      final Map<String, int> stats = {
        'total': querySnapshot.docs.length,
        'open': 0,
        'in_progress': 0,
        'resolved': 0,
        'closed': 0,
        'bug_reports': 0,
        'feature_requests': 0,
        'other': 0,
      };

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final status = data['status'] as String? ?? 'open';
        final category = data['category'] as String? ?? 'other';
        
        stats[status] = (stats[status] ?? 0) + 1;
        
        if (category.toLowerCase().contains('bug')) {
          stats['bug_reports'] = stats['bug_reports']! + 1;
        } else if (category.toLowerCase().contains('feature')) {
          stats['feature_requests'] = stats['feature_requests']! + 1;
        } else {
          stats['other'] = stats['other']! + 1;
        }
      }

      return stats;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting feedback stats: $e');
      }
      return {};
    }
  }

  /// Helper method to convert priority number to text
  static String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'Medium';
    }
  }

  /// Get device information for debugging
  static Future<Map<String, String>> _getDeviceInfo() async {
    // You can expand this with more device info using packages like device_info_plus
    return {
      'platform': defaultTargetPlatform.name,
      'isWeb': kIsWeb.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  static Future<void> updateFeedback(String feedbackId, String updatedText) async {
  try {
    await FirebaseFirestore.instance
        .collection('feedback')
        .doc(feedbackId)
        .update({
      'text': updatedText,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('Error updating feedback: $e');
    rethrow;
  }
}

  /// Search feedback by keyword
  static Future<List<Map<String, dynamic>>> searchFeedback(String keyword) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('timestamp', descending: true)
          .get();

      final results = querySnapshot.docs.where((doc) {
        final data = doc.data();
        final subject = (data['subject'] as String? ?? '').toLowerCase();
        final message = (data['message'] as String? ?? '').toLowerCase();
        final category = (data['category'] as String? ?? '').toLowerCase();
        final searchTerm = keyword.toLowerCase();

        return subject.contains(searchTerm) ||
               message.contains(searchTerm) ||
               category.contains(searchTerm);
      }).map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      return results;
    } catch (e) {
      if (kDebugMode) {
        print('Error searching feedback: $e');
      }
      return [];
    }
  }
}