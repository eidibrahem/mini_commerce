import 'firebase_notification_service.dart';

/// Example usage of FirebaseNotificationService
class NotificationExample {
  static final FirebaseNotificationService _notificationService =
      FirebaseNotificationService();

  /// Initialize notifications when app starts
  static Future<void> initializeNotifications() async {
    try {
      print('🚀 Starting notification initialization...');

      await _notificationService.initialize();

      // Get the FCM token
      String? token = _notificationService.fcmToken;
      if (token != null) {
        print('🔑 FCM Token obtained: $token');

        // TODO: Send this token to your server for push notifications
        // await _sendTokenToServer(token);
      }

      // Subscribe to topics (optional)
      await _notificationService.subscribeToTopic('general');
      await _notificationService.subscribeToTopic('promotions');
    } catch (e) {
      print('❌ Error initializing notifications: $e');
    }
  }

  /// Example: Subscribe to specific topic
  static Future<void> subscribeToTopic(String topic) async {
    await _notificationService.subscribeToTopic(topic);
  }

  /// Example: Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _notificationService.unsubscribeFromTopic(topic);
  }

  /// Example: Refresh FCM token
  static Future<String?> refreshToken() async {
    return await _notificationService.refreshToken();
  }

  /// Example: Get current FCM token
  static String? getCurrentToken() {
    return _notificationService.fcmToken;
  }

  /// Example: Show current token in console
  static void printCurrentToken() {
    String? token = _notificationService.fcmToken;
    if (token != null) {
      print('🔑 Current FCM Token: $token');
    } else {
      print('❌ No FCM token available');
    }
  }
}
