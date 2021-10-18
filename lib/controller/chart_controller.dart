import 'package:bibit_alarm/helper/database_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChartController extends GetxController {
  List<BarChartGroupData> data = <BarChartGroupData>[].obs;
  @override
  void onInit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('redirectChart', false);
    DatabaseHelper db = DatabaseHelper();
    var alarm = await db.queryAllRows('chart');
    for (var item in alarm) {
      DateTime start = DateTime.parse(item['times_register']);
      DateTime end = DateTime.parse(item['times_tap']);
      var seccondCount = end.difference(start).inSeconds;
      BarChartGroupData chart = BarChartGroupData(
        barsSpace: 4,
        x: item['ringtone_count'] ?? 0,
        barRods: [
          BarChartRodData(
            y: seccondCount.toDouble(),
            colors: [Colors.green],
            width: 7,
          ),
        ],
      );
      data.add(chart);
    }
    update();
    super.onInit();
  }
}
