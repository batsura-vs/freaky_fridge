import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Page2 extends StatefulWidget {
  static const String gifUrl = 'https://i.pinimg.com/originals/61/89/c0/6189c0c16151f2f368a2e1b9da8bb405.gif';

  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
  Timer? notificationTimer;
  Timer? autoCloseTimer;
  int secondsLeft = 5;
  String? currentChannelId;
  final List<String> funnyMessages = [
    "👨‍🔬 I am the one who knocks!",
    "🧪 Yeah, Science!",
    "⚗️ Let's cook... some ice cream!",
    "🔬 Applying chemistry to your leftovers",
    "🧫 99.1% pure refrigeration",
    "⚡ This is not meth, it's blue ice cubes",
    "🎩 Say my name: Heisenberg's Fridge",
    "💎 Your fridge is now in the empire business",
    "🚗 Your food is in danger... of being delicious!",
    "🔔 *ding* *ding* *ding* Fridge alert!"
  ];

  @override
  void initState() {
    super.initState();
    _initializeNotifications().then((_) {
      _cleanupOldNotifications();
      startNotificationSpam();
      startAutoCloseTimer();
    });
  }

  Future<void> _cleanupOldNotifications() async {
    await notifications.cancelAll();
    currentChannelId = 'heisenberg_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidSettings);
    await notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification taps if needed
      },
    );
  }

  void startAutoCloseTimer() {
    autoCloseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft <= 0) {
        stopEverything();
        Navigator.of(context).pop();
      } else {
        setState(() {
          secondsLeft--;
        });
      }
    });
  }

  void stopEverything() {
    notificationTimer?.cancel();
    notificationTimer = null;
    autoCloseTimer?.cancel();
    autoCloseTimer = null;
    _cleanupOldNotifications();
  }

  void startNotificationSpam() {
    notificationTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _showRandomNotification();
    });
  }

  Future<void> _showRandomNotification() async {
    if (currentChannelId == null) return;
    
    final random = Random();
    final message = funnyMessages[random.nextInt(funnyMessages.length)];

    final androidDetails = AndroidNotificationDetails(
      currentChannelId!,
      'Heisenberg Channel ${random.nextInt(1000)}',
      channelDescription: 'Yeah, Science!',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      ticker: message,
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
    );

    await notifications.show(
      random.nextInt(1000000),
      '🎩 Heisenberg Alert!',
      message,
      NotificationDetails(android: androidDetails),
    );
  }

  @override
  void dispose() {
    stopEverything();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            Page2.gifUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 48,
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$secondsLeft',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
