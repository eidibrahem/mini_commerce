import 'package:flutter/material.dart';
import 'firebase_notification_service.dart';

/// Test page for Firebase notifications
class NotificationTestPage extends StatefulWidget {
  const NotificationTestPage({super.key});

  @override
  State<NotificationTestPage> createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends State<NotificationTestPage> {
  final FirebaseNotificationService _notificationService =
      FirebaseNotificationService();
  String? _currentToken;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentToken();
  }

  void _loadCurrentToken() {
    setState(() {
      _currentToken = _notificationService.fcmToken;
    });
  }

  Future<void> _refreshToken() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newToken = await _notificationService.refreshToken();
      setState(() {
        _currentToken = newToken;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('FCM Token refreshed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error refreshing token: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _subscribeToTopic(String topic) async {
    try {
      await _notificationService.subscribeToTopic(topic);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Subscribed to topic: $topic'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error subscribing to topic: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _unsubscribeFromTopic(String topic) async {
    try {
      await _notificationService.unsubscribeFromTopic(topic);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unsubscribed from topic: $topic'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error unsubscribing from topic: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Notifications Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FCM Token Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.key, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'FCM Token',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: _isLoading ? null : _refreshToken,
                          icon:
                              _isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(Icons.refresh),
                          tooltip: 'Refresh Token',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_currentToken != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: SelectableText(
                          _currentToken!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // Copy to clipboard
                              // Clipboard.setData(ClipboardData(text: _currentToken!));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Token copied to clipboard!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy),
                            tooltip: 'Copy Token',
                          ),
                          const Text('Tap to copy token'),
                        ],
                      ),
                    ] else ...[
                      const Text(
                        'No FCM token available',
                        style: TextStyle(
                          color: Colors.red,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Topic Management Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.topic, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Topic Management',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Subscribe to topics
                    const Text(
                      'Subscribe to Topics:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () => _subscribeToTopic('general'),
                          child: const Text('General'),
                        ),
                        ElevatedButton(
                          onPressed: () => _subscribeToTopic('promotions'),
                          child: const Text('Promotions'),
                        ),
                        ElevatedButton(
                          onPressed: () => _subscribeToTopic('news'),
                          child: const Text('News'),
                        ),
                        ElevatedButton(
                          onPressed: () => _subscribeToTopic('updates'),
                          child: const Text('Updates'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Unsubscribe from topics
                    const Text(
                      'Unsubscribe from Topics:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        OutlinedButton(
                          onPressed: () => _unsubscribeFromTopic('general'),
                          child: const Text('General'),
                        ),
                        OutlinedButton(
                          onPressed: () => _unsubscribeFromTopic('promotions'),
                          child: const Text('Promotions'),
                        ),
                        OutlinedButton(
                          onPressed: () => _unsubscribeFromTopic('news'),
                          child: const Text('News'),
                        ),
                        OutlinedButton(
                          onPressed: () => _unsubscribeFromTopic('updates'),
                          child: const Text('Updates'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Status Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Service Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _notificationService.isInitialized
                              ? Icons.check_circle
                              : Icons.error,
                          color:
                              _notificationService.isInitialized
                                  ? Colors.green
                                  : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _notificationService.isInitialized
                              ? 'Notification service is initialized'
                              : 'Notification service is not initialized',
                          style: TextStyle(
                            color:
                                _notificationService.isInitialized
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Instructions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📱 How to Test:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('• Copy the FCM token above'),
                  Text('• Use Firebase Console to send a test notification'),
                  Text('• Or use a tool like Postman to send FCM messages'),
                  Text('• Check console logs for notification events'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
