import 'dart:async';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:bibit_alarm/helper/database_helper.dart';
import 'package:bibit_alarm/main.dart';
import 'package:bibit_alarm/pages/chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClockController extends GetxController {
  final timeNow = DateTime.now().obs;
  final addDay = [].obs;
  final repeated = false.obs;
  final time = DateTime.now().obs;
  final alarmList = [].obs;

  @override
  onInit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool redirect = preferences.getBool('redirectChart') ?? false;
    if (redirect) {
      Get.to(() => Chart());
    }
    DateTime date = DateTime.now();
    addDay.add(date.weekday);
    getAlarm();
    AndroidAlarmManager.initialize();
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      timeNow.value = DateTime.now();
      update();
    });
    super.onInit();
  }

  chooseDay(int day) {
    bool remove = addDay.remove(day);
    if (remove == false) {
      addDay.add(day);
    }
    update();
  }

  Future<void> getAlarm() async {
    DatabaseHelper db = DatabaseHelper();
    var alarm = await db.queryAllRows('alarm_table');
    alarmList.assignAll(alarm);
    print(alarm);
    update();
  }

  Future<void> setAlarm() async {
    if (addDay.length == 0) {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pemberitahuan"),
            content:
                Text("Anda tidak bisa menambahkan alarm tanpa memilih hari"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      DatabaseHelper db = DatabaseHelper();
      // Get.back();
      int indexNow = addDay.indexOf(timeNow.value.weekday);
      int nextDay;
      if (addDay.length == 1 && addDay[0] == timeNow.value.weekday) {
        nextDay = 0;
      } else {
        nextDay = addDay[indexNow + 1] - timeNow.value.weekday;
      }
      print(
        time.value.add(
          Duration(days: nextDay),
        ),
      );
      var id = await db.insert({
        "time": "${time.value}",
        "days": "$addDay",
        "repeated": repeated.value,
        "active": true,
        "ringing": false
      }, 'alarm_table');
      getAlarm();
      await AndroidAlarmManager.oneShotAt(
        time.value.add(
          Duration(days: nextDay),
        ),
        id,
        callback,
        alarmClock: true,
        allowWhileIdle: true,
        rescheduleOnReboot: true,
        exact: true,
        wakeup: true,
      );
    }
  }
}
