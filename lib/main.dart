import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotificationsPage(),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  //объект уведомления
  late FlutterLocalNotificationsPlugin localNotifications;

  //инициализация
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();

    //объект для Android настроек
    const androidInitialize = AndroidInitializationSettings('ic_launcher');
    //объект для IOS настроек
    const iOSInitialize = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    // общая инициализация
    const initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    //мы создаем локальное уведомление
    localNotifications = FlutterLocalNotificationsPlugin();
    localNotifications.initialize(initializationSettings);
    localNotifications.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Нажми на кнопку, чтобы получить уведомление'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNotificationPeriodically,
        child: const Icon(Icons.notifications),
      ),
    );
  }

  Future _showNotificationPeriodically() async {
    const androidDetails = AndroidNotificationDetails(
      "ID",
      "Название уведомления",
      importance: Importance.high,
      channelDescription: "Контент уведомления",
    );
    const iosDetails = DarwinNotificationDetails();
    const generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotifications.zonedSchedule(
      0,
      'Напоминание',
      'Выделить полчаса на занятия программированием',
      TZDateTime.now(local).add(const Duration(seconds: 3)),
      generalNotificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
