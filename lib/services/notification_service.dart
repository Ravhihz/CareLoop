import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/medicine.dart';
import '../screens/morning_checkin_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  static final NotificationService instance = NotificationService._init();
  static final _plugin = FlutterLocalNotificationsPlugin();

  NotificationService._init();

  bool get _isMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  Future<void> init() async {
    if (!_isMobile) return;
    tz.initializeTimeZones();
    final String timezoneName = await _getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneName));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final canSchedule = await androidImpl?.canScheduleExactNotifications();
      if (canSchedule == false) {
        await androidImpl?.requestExactAlarmsPermission();
      }
    }
  }

  Future<String> _getLocalTimezone() async {
    try {
      final offset = DateTime.now().timeZoneOffset;
      final hours = offset.inHours;
      final minutes = (offset.inMinutes % 60).abs();
      final locations = tz.timeZoneDatabase.locations;
      for (final entry in locations.entries) {
        final loc = entry.value;
        final tzOffset = loc.currentTimeZone.offset;
        final tzHours = tzOffset ~/ 3600000;
        final tzMinutes = (tzOffset % 3600000) ~/ 60000;
        if (tzHours == hours && tzMinutes == minutes) {
          return entry.key;
        }
      }
    } catch (_) {}
    return 'UTC';
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.id == 0) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const MorningCheckinScreen()),
      );
    }
  }

  Future<AndroidNotificationDetails> _buildAndroidDetails(String title) async {
    final prefs = await SharedPreferences.getInstance();
    final style = prefs.getString('notif_style') ?? 'heads_up';
    final sound = prefs.getString('notif_sound') ?? 'gentle';
    final vibrate = prefs.getBool('vibrate') ?? true;

    Importance importance;
    Priority priority;

    switch (style) {
      case 'full_screen':
        priority = Priority.max;
        importance = Importance.max;
        break;
      case 'heads_up':
        priority = Priority.high;
        importance = Importance.high;
        break;
      default:
        priority = Priority.defaultPriority;
        importance = Importance.defaultImportance;
    }

    return AndroidNotificationDetails(
      'careloop_reminder',
      'Medicine Reminder',
      channelDescription: 'Reminder to take your medicine',
      importance: importance,
      priority: priority,
      fullScreenIntent: style == 'full_screen',
      enableVibration: vibrate,
      playSound: sound != 'silent',
      styleInformation: BigTextStyleInformation(title),
    );
  }

  Future<void> scheduleMedicineReminders(Medicine medicine) async {
    if (!_isMobile) return;
    await cancelMedicineReminders(medicine.id!);

    for (int i = 0; i < medicine.times.length; i++) {
      final time = medicine.times[i];
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final now = tz.TZDateTime.now(tz.local);
      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      final androidDetails = await _buildAndroidDetails(
        'Time to take ${medicine.name}',
      );

      await _plugin.zonedSchedule(
        _notifId(medicine.id!, i),
        'CareLoop 💊',
        'Time to take ${medicine.name}',
        scheduled,
        NotificationDetails(android: androidDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> scheduleMorningCheckin() async {
    if (!_isMobile) return;
    final androidDetails = await _buildAndroidDetails(
      'Good morning! How are you feeling today?',
    );

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 7, 0);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      0,
      'CareLoop 🌤️',
      'Good morning! How are you feeling today?',
      scheduled,
      NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelMedicineReminders(int medicineId) async {
    if (!_isMobile) return;
    for (int i = 0; i < 4; i++) {
      await _plugin.cancel(_notifId(medicineId, i));
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  int _notifId(int medicineId, int timeIndex) {
    return int.parse('$medicineId$timeIndex');
  }
}
