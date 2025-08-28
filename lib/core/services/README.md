# Firebase Notification Service

This service handles Firebase Cloud Messaging (FCM) for push notifications in your Flutter app.

## 🚀 Features

- **FCM Token Management**: Get, refresh, and manage FCM tokens
- **Permission Handling**: Request notification permissions (iOS)
- **Topic Management**: Subscribe/unsubscribe to notification topics
- **Message Handling**: Handle foreground, background, and notification taps
- **Local Notifications**: Show local notifications when app is in foreground
- **Background Processing**: Handle messages when app is in background

## 📱 Setup

### 1. Dependencies
Make sure you have these in your `pubspec.yaml`:
```yaml
dependencies:
  firebase_messaging: ^14.7.10
  flutter_local_notifications: ^19.4.1
```

### 2. Android Configuration
Your `android/app/src/main/AndroidManifest.xml` should have:
```xml
<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="high_importance_channel"/>
```

### 3. iOS Configuration
Add to `ios/Runner/Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

## 🔧 Usage

### Basic Initialization
```dart
import 'package:mini_commerce/core/services/firebase_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize notification service
  final notificationService = FirebaseNotificationService();
  await notificationService.initialize();
  
  runApp(MyApp());
}
```

### Get FCM Token
```dart
final notificationService = FirebaseNotificationService();
String? token = notificationService.fcmToken;

if (token != null) {
  print('FCM Token: $token');
  // Send this token to your server
}
```

### Subscribe to Topics
```dart
await notificationService.subscribeToTopic('general');
await notificationService.subscribeToTopic('promotions');
```

### Unsubscribe from Topics
```dart
await notificationService.unsubscribeFromTopic('general');
```

### Refresh Token
```dart
String? newToken = await notificationService.refreshToken();
```

## 📨 Testing Notifications

### 1. Get FCM Token
Run the app and check console logs for the FCM token.

### 2. Send Test Notification
Use Firebase Console:
1. Go to Firebase Console > Cloud Messaging
2. Click "Send your first message"
3. Enter title and body
4. Under "Target", select "Single device" and paste your FCM token
5. Send the message

### 3. Check Console Logs
The service will print detailed logs for:
- Token retrieval
- Permission status
- Message reception
- Topic subscriptions

## 🔍 Console Output Examples

```
🚀 FirebaseNotificationService: Initializing...
📱 FirebaseNotificationService: Permission status: AuthorizationStatus.authorized
✅ FirebaseNotificationService: Notification permission granted
🔑 FirebaseNotificationService: FCM Token: fMEP0JqHqXk:APA91bHqXk...
✅ FirebaseNotificationService: Local notifications initialized
✅ FirebaseNotificationService: Initialized successfully
```

## 🎯 Common Use Cases

### E-commerce Notifications
```dart
// Subscribe to order updates
await notificationService.subscribeToTopic('orders_${userId}');

// Subscribe to promotions
await notificationService.subscribeToTopic('promotions');
```

### User-specific Notifications
```dart
// Subscribe to user-specific topic
await notificationService.subscribeToTopic('user_${userId}');
```

## ⚠️ Important Notes

1. **Background Messages**: The background handler must be a top-level function
2. **Token Refresh**: FCM tokens can change, always listen for refresh events
3. **iOS Permissions**: Users must grant permission for notifications to work
4. **Testing**: Use real devices for testing, emulators may not work properly

## 🐛 Troubleshooting

### No FCM Token
- Check Firebase configuration
- Verify internet connection
- Check console for error messages

### Notifications Not Showing
- Verify permission status
- Check notification channel configuration
- Ensure app is not in battery optimization mode

### Background Messages Not Working
- Verify background handler is top-level function
- Check Firebase configuration
- Test on real device

## 📚 Additional Resources

- [Firebase Messaging Documentation](https://firebase.flutter.dev/docs/messaging/overview/)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [FCM HTTP v1 API](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages)
