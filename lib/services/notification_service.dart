import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:adhan/adhan.dart';
import 'package:islamibilgiler/providers/settings_provider.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    final String locationName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestPermissions() async {
    final androidImplementation =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> scheduleDailyPrayerNotifications(PrayerTimes prayerTimes, SettingsProvider settingsProvider) async {
    await cancelAllNotifications();

    final Map<Prayer, String> prayersToSchedule = {
      Prayer.fajr: 'İmsak',
      Prayer.dhuhr: 'Öğle',
      Prayer.asr: 'İkindi',
      Prayer.maghrib: 'Akşam',
      Prayer.isha: 'Yatsı',
    };

    int notificationId = 0;
    for (var entry in prayersToSchedule.entries) {
      final prayer = entry.key;
      final prayerName = entry.value;

      late DateTime prayerTime;
      switch(prayer) {
        case Prayer.fajr: prayerTime = prayerTimes.fajr; break;
        case Prayer.dhuhr: prayerTime = prayerTimes.dhuhr; break;
        case Prayer.asr: prayerTime = prayerTimes.asr; break;
        case Prayer.maghrib: prayerTime = prayerTimes.maghrib; break;
        case Prayer.isha: prayerTime = prayerTimes.isha; break;
        default: continue;
      }

      bool shouldNotify = false;
      switch(prayer) {
        case Prayer.fajr: shouldNotify = settingsProvider.fajrNotify; break;
        case Prayer.dhuhr: shouldNotify = settingsProvider.dhuhrNotify; break;
        case Prayer.asr: shouldNotify = settingsProvider.asrNotify; break;
        case Prayer.maghrib: shouldNotify = settingsProvider.maghribNotify; break;
        case Prayer.isha: shouldNotify = settingsProvider.ishaNotify; break;
        default: break;
      }

      if (shouldNotify && prayerTime.isAfter(DateTime.now())) {
        _scheduleNotification(
          id: notificationId,
          title: 'Vakit Geldi!',
          body: '$prayerName ezanı vakti.',
          scheduledTime: tz.TZDateTime.from(prayerTime, tz.local),
          soundName: settingsProvider.notificationSound,
        );
        notificationId++;
      }
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
    required String soundName,
  }) async {

    final AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'prayer_time_channel',
      'Namaz Vakti Bildirimleri',
      channelDescription: 'Namaz vakitleri girdiğinde bildirim gönderir.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: soundName != 'sessiz',
      sound: null, // Varsayılan ses için null kullanılır
    );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentSound: soundName != 'sessiz',
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}