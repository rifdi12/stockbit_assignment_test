import 'dart:convert';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bibit_alarm/helper/database_helper.dart';
import 'package:bibit_alarm/pages/alarm.dart';
import 'package:bibit_alarm/pages/chart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

callback(int id) async {
  AudioCache audio = AudioCache();
  DatabaseHelper db = DatabaseHelper();
  await db.update({'ringing': true, 'id': id}, 'alarm_table', 'id');
  var idChart = await db.insert({
    "alarm_id": id,
    "times_register": "${DateTime.now()}",
  }, 'chart');
  showNotification();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('onTap', false);
  preferences.setBool('redirectChart', true);
  for (var i = 0; i < 150; i++) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    await db.update({'ringtone_count': i, 'id': idChart}, 'chart', 'id');
    audio.play('music/alarm.wav');
    await preferences.reload();
    if (preferences.get('onTap') == true) break;
  }
}

Future<void> showNotification() async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('Alarm', 'Alarm',
          channelDescription: 'Alarm Notification',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          channelShowBadge: true,
          category: 'alarm',
          ticker: 'ticker');
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      'Alarm',
      'Please Tap notification or reopen the Apps for turn off a Alarm',
      platformChannelSpecifics,
      payload: 'open');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('onTap', true);
  DatabaseHelper db = DatabaseHelper();
  List alarm = await db.queryAllRows('alarm_table');
  List chartAlarm = await db.queryAllRows('chart');
  for (var item in chartAlarm) {
    if (item['times_tap'] == null) {
      await db.update(
          {'times_tap': '${DateTime.now()}', 'id': item['id']}, 'chart', 'id');
    }
  }
  for (var item in alarm) {
    if (item['repeated'] == 0) {
      await db.update({'ringing': false, 'active': false, 'id': item['id']},
          'alarm_table', 'id');
    } else {
      await db
          .update({'ringing': false, 'id': item['id']}, 'alarm_table', 'id');

      DateTime date = DateTime.now();
      List listDays = jsonDecode(item['days']);
      listDays.sort((a, b) => a.compareTo(b));
      int indexNow = listDays.indexOf(date.weekday);
      int nextDay;
      if (listDays.length == 1) {
        nextDay = 7;
      } else {
        nextDay = listDays[indexNow + 1] - date.weekday;
      }
      await AndroidAlarmManager.oneShotAt(
        DateTime.parse("${item['time']}").add(Duration(days: nextDay)),
        item['id'],
        callback,
        alarmClock: true,
        allowWhileIdle: true,
        rescheduleOnReboot: true,
        exact: true,
        wakeup: true,
      );
    }
  }
  var initializationSettingsAndroid = AndroidInitializationSettings('logo');
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);

  DatabaseHelper().database;
  runApp(AlarmManagerExampleApp());
}

class AlarmManagerExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stockbit Alarm',
      home: AlarmHomePage(),
    );
  }
}

Future selectNotification(String? payload) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  DatabaseHelper db = DatabaseHelper();
  List alarm = await db.queryAllRows('alarm_table');
  List chartAlarm = await db.queryAllRows('chart');
  for (var item in chartAlarm) {
    if (item['times_tap'] == null) {
      await db.update(
          {'times_tap': '${DateTime.now()}', 'id': item['id']}, 'chart', 'id');
    }
  }
  for (var item in alarm) {
    if (item['repeated'] == 0) {
      await db.update({'ringing': false, 'active': false, 'id': item['id']},
          'alarm_table', 'id');
    } else {
      await db
          .update({'ringing': false, 'id': item['id']}, 'alarm_table', 'id');

      DateTime date = DateTime.now();
      List listDays = jsonDecode(item['days']);
      listDays.sort((a, b) => a.compareTo(b));
      int indexNow = listDays.indexOf(date.weekday);
      int nextDay;
      if (listDays.length == 1) {
        nextDay = 7;
      } else {
        nextDay = listDays[indexNow + 1] - date.weekday;
      }
      print(nextDay);
      await AndroidAlarmManager.oneShotAt(
        DateTime.parse("${item['time']}").add(Duration(days: nextDay)),
        item['id'],
        callback,
        alarmClock: true,
        allowWhileIdle: true,
        rescheduleOnReboot: true,
        exact: true,
        wakeup: true,
      );
    }
  }

  Get.to(() => Chart());
  preferences.setBool('onTap', true);
}
