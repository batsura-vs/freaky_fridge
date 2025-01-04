import 'package:flutter/material.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class ExpirationService extends GetxService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final database = ProductDatabase.instance;

  final AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails(
    'PRODUCTS',
    'EXPIRATION',
    channelDescription: 'Notifications about product expiration',
    playSound: true,
    importance: Importance.max,
    priority: Priority.high,
  );
  Future<void> init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  Future<void> checkExpirations() async {
    final records = await database.getAllProductRecordWithProduct();
    final now = DateTime.now();

    for (final el in records) {
      final difference = el.record.expiration.difference(now);
      if (difference.inDays <= 2 && difference.inDays >= 0) {
        NotificationDetails notificationDetails =
            NotificationDetails(android: androidNotificationDetails);
        await flutterLocalNotificationsPlugin.show(
          el.product.id,
          'Срок годности истекает!',
          'Срок годности "${el.product.name}" истекает через ${difference.inDays}д!',
          notificationDetails,
        );
      }
    }
  }
}
