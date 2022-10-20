import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationApi {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future init({bool initScheduled = false}) async {
    final androidSetting =
        AndroidInitializationSettings('@drawable/ic_notification');
    // final iOSSetting = IOSInitializationSettings();
    final settings = InitializationSettings(
      android: androidSetting, /*iOS: iOSSetting*/
    );
    await flutterLocalNotificationsPlugin.initialize(
      settings,
      // onSelectNotification: (payload) async {
      //   // ACTION TO TAKE ON NOTIFICATION SELECTED
      //   debugPrint(
      //       '***** Notification Was Selected (notification api): $payload *****');
      //   onNotifications.add(payload!);
      // },
    );
  }

  static final onNotifications = BehaviorSubject<String>();
// DEMONSTRATION BELOW FROM https://medium.com/flutterdevs/local-push-notification-in-flutter-763605b84985

  static showBigTextNotification(
      int id,
      String channelId,
      String channelName,
      String channelDescription,
      String bigTextSummaryTitle,
      String bigTextTitle,
      String bigTextBody,
      String additionalData) async {
    var android = AndroidNotificationDetails(channelId, channelName,
        channelDescription: channelDescription,
        priority: Priority.high,
        importance: Importance.max,
        enableLights: true,
        icon: '@drawable/ic_notification',
        largeIcon: DrawableResourceAndroidBitmap('ic_notification_round'),
        styleInformation: BigTextStyleInformation(bigTextBody,
            contentTitle: bigTextTitle, summaryText: bigTextSummaryTitle),
        enableVibration: true,
        groupKey: channelId);
    // var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(
      android: android, /* iOS: iOS*/
    );
    await flutterLocalNotificationsPlugin
        .show(id, bigTextTitle, bigTextBody, platform, payload: additionalData);
  }

  static Future<void> scheduleNotification() async {
    tz.initializeTimeZones();
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 5));
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      icon: 'flutter_devs',
      largeIcon: DrawableResourceAndroidBitmap('@drawable/ic_notification'),
    );
    // IOSNotificationDetails iOSPlatformChannelSpecifics =
    //     IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android:
          androidPlatformChannelSpecifics, /*  iOS: iOSPlatformChannelSpecifics*/
    );
    // UILocalNotificationDateInterpretation uiLocalNotificationDateInterpretation = ;
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Sechedule Title',
      'Schedule Body',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name',
              channelDescription: 'your channel description')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> showBigPictureNotification() async {
    var bigPictureStyleInformation = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("flutter_devs"),
      largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
      contentTitle: 'flutter devs',
      summaryText: 'summaryText',
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id', 'big text channel name',
        channelDescription: 'big text channel description',
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics,
        payload: "big image notifications");
  }

  static Future<void> showNotificationMediaStyle() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      channelDescription: 'media channel description',
      color: Colors.red,
      enableLights: true,
      largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
      styleInformation: MediaStyleInformation(),
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'notification title', 'notification body', platformChannelSpecifics);
  }

  static Future<void> cancelNotification(int id, String tag) async {
    await flutterLocalNotificationsPlugin.cancel(id, tag: tag);
  }
}
