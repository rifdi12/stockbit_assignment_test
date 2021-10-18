import 'dart:convert';
import 'dart:ui';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:bibit_alarm/controller/clock_controller.dart';
import 'package:bibit_alarm/helper/clock_slider.dart';
import 'package:bibit_alarm/helper/database_helper.dart';
import 'package:bibit_alarm/pages/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class AlarmHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ClockController ctrl = Get.put(ClockController());

    String getDaysName(List data) {
      String day = '';
      for (var days in data) {
        if (days == 7) {
          day += 'Minggu, ';
        } else if (days == 1) {
          day += 'Senin, ';
        } else if (days == 2) {
          day += 'Selasa, ';
        } else if (days == 3) {
          day += 'Rabu, ';
        } else if (days == 4) {
          day += 'Kamis, ';
        } else if (days == 5) {
          day += 'Jumat, ';
        } else if (days == 5) {
          day += 'Sabtu, ';
        }
      }
      day = day.substring(0, day.length - 2);
      return day;
    }

    addAlarmUi() {
      showModalBottomSheet(
        context: Get.context!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) => Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: Color(0xffA6A6A6),
                          ),
                        ),
                      ),
                      Text(
                        'Atur Alarm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // FlutterRingtonePlayer.stop();
                          ctrl.setAlarm();
                        },
                        child: Text(
                          'Simpan',
                          style: TextStyle(color: Colors.green),
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  TimePickerSpinner(
                    onTimeChange: (value) {
                      ctrl.time.value = value;
                      ctrl.update();
                    },
                    isForce2Digits: true,
                    highlightedTextStyle: TextStyle(
                      color: Colors.green,
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                    ),
                    normalTextStyle: TextStyle(
                      color: Colors.grey.withOpacity(.5),
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            ctrl.repeated.value = false;
                            ctrl.update();
                          },
                          child: Text(
                            'Satu Kali',
                            style: TextStyle(
                              color: !ctrl.repeated.value
                                  ? Colors.green
                                  : Color(0xffA6A6A6),
                              fontSize: 16,
                              fontWeight: !ctrl.repeated.value
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ctrl.repeated.value = true;
                            ctrl.update();
                          },
                          child: Text(
                            'Berulang',
                            style: TextStyle(
                              color: ctrl.repeated.value
                                  ? Colors.green
                                  : Color(0xffA6A6A6),
                              fontSize: 16,
                              fontWeight: ctrl.repeated.value
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Obx(
                    () => Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            ctrl.chooseDay(7);
                          },
                          child: Text(
                            'Min',
                            style: TextStyle(
                              color: ctrl.addDay.contains(7)
                                  ? Colors.green
                                  : Color(0xffA6A6A6),
                              fontSize: 16,
                              fontWeight: ctrl.addDay.contains(7)
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ctrl.chooseDay(1);
                          },
                          child: Text(
                            'Sen',
                            style: TextStyle(
                              color: ctrl.addDay.contains(1)
                                  ? Colors.green
                                  : Color(0xffA6A6A6),
                              fontSize: 16,
                              fontWeight: ctrl.addDay.contains(1)
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ctrl.chooseDay(2);
                          },
                          child: Text(
                            'Sel',
                            style: TextStyle(
                              color: ctrl.addDay.contains(2)
                                  ? Colors.green
                                  : Color(0xffA6A6A6),
                              fontSize: 16,
                              fontWeight: ctrl.addDay.contains(2)
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ctrl.chooseDay(3);
                          },
                          child: Text(
                            'Rab',
                            style: TextStyle(
                              color: ctrl.addDay.contains(3)
                                  ? Colors.green
                                  : Color(0xffA6A6A6),
                              fontSize: 16,
                              fontWeight: ctrl.addDay.contains(3)
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ctrl.chooseDay(4);
                          },
                          child: Text(
                            'Kam',
                            style: TextStyle(
                              color: ctrl.addDay.contains(4)
                                  ? Colors.green
                                  : Color(0xffA6A6A6),
                              fontSize: 16,
                              fontWeight: ctrl.addDay.contains(4)
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ctrl.chooseDay(5);
                          },
                          child: Text(
                            'Jum',
                            style: TextStyle(
                              color: ctrl.addDay.contains(5)
                                  ? Colors.green
                                  : Color(0xffA6A6A6),
                              fontSize: 16,
                              fontWeight: ctrl.addDay.contains(5)
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ctrl.chooseDay(6);
                          },
                          child: Text(
                            'Sab',
                            style: TextStyle(
                              color: ctrl.addDay.contains(6)
                                  ? Colors.green
                                  : Color(0xffA6A6A6),
                              fontSize: 16,
                              fontWeight: ctrl.addDay.contains(6)
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.bar_chart, color: Colors.green),
          onPressed: () => Get.to(() => Chart()),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.green),
            onPressed: () {
              addAlarmUi();
            },
          ),
        ],
        title: Text(
          'Alarm',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          ctrl.getAlarm();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Obx(
                  () => Text(
                    '${DateFormat('HH:mm').format(ctrl.timeNow.value)}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 70,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Obx(
                  () => ctrl.alarmList.length < 1
                      ? Column(
                          children: [
                            Image.asset(
                              'assets/images/no_data.png',
                              height: 220,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Anda Belum menambahkan alarm',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding:
                                        EdgeInsets.fromLTRB(36, 12, 36, 12),
                                    primary: Colors.green),
                                onPressed: () {
                                  addAlarmUi();
                                },
                                child: Text(
                                  'Tambahkan alarm',
                                ),
                              ),
                            )
                          ],
                        )
                      : Container(
                          padding: EdgeInsets.all(50),
                          child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 50,
                                );
                              },
                              shrinkWrap: true,
                              itemCount: ctrl.alarmList.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  secondaryActions: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: IconSlideAction(
                                        caption: 'Hapus',
                                        color: Colors.redAccent.withOpacity(.8),
                                        icon: Icons.delete,
                                        onTap: () async {
                                          DatabaseHelper db = DatabaseHelper();
                                          await db.delete(
                                              ctrl.alarmList[index]['id'],
                                              'alarm_table',
                                              'id');
                                          ctrl.getAlarm();
                                        },
                                      ),
                                    ),
                                  ],
                                  actionExtentRatio: 0.25,
                                  child: Container(
                                    width: Get.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: Get.width / 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${DateFormat('HH:mm').format(DateTime.parse(ctrl.alarmList[index]['time']))}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${getDaysName(json.decode(ctrl.alarmList[index]['days']))} ',
                                                style: TextStyle(
                                                    color: Color(0xffA6A6A6),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                '${ctrl.alarmList[index]['repeated'] == 0 ? 'Sekali' : 'Berulang'}',
                                                style: TextStyle(
                                                    color: Color(0xffA6A6A6),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Transform.scale(
                                          scale: 1.3,
                                          child: Switch(
                                            value: ctrl.alarmList[index]
                                                        ['active'] ==
                                                    1
                                                ? true
                                                : false,
                                            onChanged: (value) async {
                                              DatabaseHelper db =
                                                  DatabaseHelper();
                                              await db.update({
                                                'active': ctrl.alarmList[index]
                                                            ['active'] ==
                                                        0
                                                    ? true
                                                    : false,
                                                'id': ctrl.alarmList[index]
                                                    ['id']
                                              }, 'alarm_table', 'id');
                                              if (ctrl.alarmList[index]
                                                      ['active'] ==
                                                  1) {
                                                await AndroidAlarmManager
                                                    .cancel(
                                                  ctrl.alarmList[index]['id'],
                                                );
                                              } else {
                                                DateTime alarmTime =
                                                    DateTime.parse(
                                                        ctrl.alarmList[index]
                                                            ['time']);
                                                DateTime now = DateTime.now();
                                                if (now.isAfter(alarmTime)) {
                                                  List listDays = jsonDecode(
                                                      ctrl.alarmList[index]
                                                          ['days']);
                                                  listDays.sort(
                                                      (a, b) => a.compareTo(b));
                                                  int indexNow = listDays
                                                      .indexOf(now.weekday);
                                                  int nextDay;
                                                  if (listDays.length == 1) {
                                                    nextDay = 7;
                                                  } else {
                                                    nextDay =
                                                        listDays[indexNow + 1] -
                                                            now.weekday;
                                                  }
                                                  await AndroidAlarmManager
                                                      .oneShotAt(
                                                    DateTime.parse(
                                                            ctrl.alarmList[
                                                                index]['time'])
                                                        .add(
                                                      Duration(days: nextDay),
                                                    ),
                                                    ctrl.alarmList[index]['id'],
                                                    callback,
                                                    alarmClock: true,
                                                    allowWhileIdle: true,
                                                    rescheduleOnReboot: true,
                                                    exact: true,
                                                    wakeup: true,
                                                  );
                                                } else {
                                                  await AndroidAlarmManager
                                                      .oneShotAt(
                                                    DateTime.parse(
                                                      ctrl.alarmList[index]
                                                          ['time'],
                                                    ),
                                                    ctrl.alarmList[index]['id'],
                                                    callback,
                                                    alarmClock: true,
                                                    allowWhileIdle: true,
                                                    rescheduleOnReboot: true,
                                                    exact: true,
                                                    wakeup: true,
                                                  );
                                                }
                                              }
                                              ctrl.getAlarm();
                                            },
                                            activeTrackColor:
                                                Colors.grey.withOpacity(.1),
                                            inactiveTrackColor:
                                                Colors.grey.withOpacity(.1),
                                            activeColor: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Text(
                //       'Total alarms fired: ',
                //     ),
                //     Text(
                //       prefs.getInt(countKey).toString(),
                //       key: ValueKey('BackgroundCountText'),
                //     ),
                //   ],
                // ),
                // ElevatedButton(
                //   child: Text(
                //     'Schedule OneShot Alarm',
                //   ),
                //   key: ValueKey('RegisterOneShotAlarm'),
                //   onPressed: () async {
                //     await AndroidAlarmManager.oneShot(
                //       const Duration(seconds: 5),
                //       // Ensure we have a unique alarm ID.
                //       Random().nextInt(pow(2, 31).toInt()),
                //       callback,
                //       exact: true,
                //       wakeup: true,
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
