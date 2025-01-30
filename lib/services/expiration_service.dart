import 'package:flutter/material.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ExpirationService extends GetxService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final database = AppDatabase.instance;

  final AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails(
    'PRODUCTS',
    'EXPIRATION',
    channelDescription: 'Уведомления об истечении срока годности продукта',
    playSound: true,
    importance: Importance.max,
    priority: Priority.high,
  );

  Future<void> init() async {
    // Initialize timezone database
    tz.initializeTimeZones();
    
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Schedule notifications for existing products
    await scheduleAllProductNotifications();
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('полезная нагрузка уведомления: $payload');
    }
  }

  Future<void> scheduleAllProductNotifications() async {
    final products = await database.allProducts;
    
    // Cancel all existing notifications first
    await flutterLocalNotificationsPlugin.cancelAll();
    
    // Schedule new notifications for each product
    for (final product in products) {
      await scheduleProductNotification(product);
    }
  }

  Future<void> scheduleProductNotification(ProductData product) async {
    // Calculate notification time (1 day before expiration)
    final notificationTime = product.expirationDate.subtract(const Duration(days: 1));
    final now = DateTime.now();

    // Only schedule if the notification time is in the future
    if (notificationTime.isAfter(now)) {
      NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        product.id,
        'Срок годности истекает!',
        'Срок годности "${product.name}" истекает завтра!',
        tz.TZDateTime.from(notificationTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> cancelProductNotification(int productId) async {
    await flutterLocalNotificationsPlugin.cancel(productId);
  }
}
