import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('ic_launcher'),
    );

    await _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static Future<void> display({
    required String title,
    required String message,
    required String channelId,
    required String channelName,
    required String channelDesc,
    required Importance importance,
    required Priority priority,
  }) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channelId, channelName,
            channelDescription: channelDesc,
            importance: importance,
            priority: priority,
            styleInformation: BigTextStyleInformation(message));

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _notificationsPlugin.show(0, title, message, notificationDetails);
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse details) async {
    final String? payload = details.payload;

    if (details.payload != null) {}
  }
}
