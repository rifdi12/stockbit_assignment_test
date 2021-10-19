import 'package:bibit_alarm/controller/chart_controller.dart';
import 'package:bibit_alarm/helper/database_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chart extends StatelessWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChartController chartController = Get.put(ChartController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.green),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Chart',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Obx(
                  () => AspectRatio(
                    aspectRatio: 0.8,
                    child: BarChart(
                      BarChartData(
                        // maxY: 1000,
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: SideTitles(showTitles: false),
                          topTitles: SideTitles(showTitles: false),
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (context, value) => const TextStyle(
                                color: Color(0xff7589a2),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            margin: 20,
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (context, value) => const TextStyle(
                                color: Color(0xff7589a2),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            margin: 8,
                            reservedSize: 28,
                            interval: 1,
                            getTitles: (value) {
                              int modular = 1;
                              if (num.parse(
                                      chartController.maxY.value.toString()) >
                                  900) {
                                print('a');
                                modular = 250;
                              } else if (num.parse(chartController.maxY.value
                                          .toString()) <
                                      500 &&
                                  num.parse(chartController.maxY.value
                                          .toString()) >
                                      100) {
                                print('b');
                                modular = 100;
                              } else if (num.parse(chartController.maxY.value
                                          .toString()) <
                                      100 &&
                                  num.parse(chartController.maxY.value
                                          .toString()) >
                                      50) {
                                print('c');
                                modular = 25;
                              } else if (num.parse(chartController.maxY.value
                                          .toString()) <
                                      50 &&
                                  num.parse(chartController.maxY.value
                                          .toString()) >
                                      10) {
                                modular = 10;
                              } else if (num.parse(
                                      chartController.maxY.value.toString()) <
                                  10) {
                                print('d');
                                modular = 1;
                              }
                              if (num.parse(value.toString()) % modular == 0) {
                                return value.toString().replaceAll('.0', '');
                              } else {
                                return '';
                              }
                            },
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: chartController.data,
                        gridData: FlGridData(show: false),
                      ),

                      swapAnimationDuration:
                          Duration(milliseconds: 150), // Optional
                      swapAnimationCurve: Curves.linear, // Optional
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
