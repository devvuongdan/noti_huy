import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings/tracking-drinkwater/models/app_prefs.dart';
import 'package:settings/tracking-drinkwater/models/daily_drink_record.dart';
import 'package:settings/utils/Preference.dart';
import 'package:uuid/uuid.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import '../../base/base_controller.dart';
import '../models/app_database_manager.dart';
import '../models/chart_data.dart';
import '../models/drink_record.dart';
import '../utils/datetime_utils.dart';

class TrackingDrinkwaterController extends BaseController {
  final count = 0.obs;
  Rx<int> current = 0.obs;
  Rx<int> totalCapacity = 0.obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  RxInt selectedIndex = 0.obs;
  RxInt target = 0.obs;

  ValueNotifier<List<DailyDrinkRecord>> dailyRecords = ValueNotifier([]);


  @override
  void onInit() async {
    selectedIndex.value = AppPrefs.instance.capacityChooserIndex;
    int savedTarget = AppPrefs.instance.target;
    changeTarget(savedTarget);
    await _fetchRecords();
    getTodayRecord();
    super.onInit();
  }

  _fetchRecords() async {
    List<DailyDrinkRecord> records = AppPrefs.instance.logs;
    dailyRecords.value = records;
    dailyRecords.notifyListeners();
    print('dailyRecords.value:${dailyRecords.value.length} ');
  }

  void changeSelectedCapacityChooserIndex(int index) {
    selectedIndex.value = index;
    AppPrefs.instance.capacityChooserIndex = index;
  }

  void changeTarget(int target) {
    this.target.value = target;
    AppPrefs.instance.target = target;
  }

  getTodayRecord() {
    return dailyRecords.value.firstWhere(
      (dailyRecord) {
        totalCapacity.value = dailyRecord.totalCapacity;
        return DateTimeUtils.isToday(dailyRecord.date);
      },
      orElse: () {
        DailyDrinkRecord today = DailyDrinkRecord(
          id: Random().nextInt(899999) + 100000,
          target: target.value,
          records: [],
          date: DateTime.now(),
        );

        dailyRecords.value.add(today);
        totalCapacity.value = today.totalCapacity;
        print("today cap ${totalCapacity}");
        return today;
      },
    );
  }

  // void addDrinkRecord(int capacity) async {
  //   await AppDatabaseManager.instance.insertLog({
  //     'id': Uuid().v1(),
  //     "capacity": capacity,
  //     'datetime': DateTime.now().millisecondsSinceEpoch,
  //   });
  //   totalCapacity.value += capacity;
  //   _fetchRecords();
  // }

  void addDrinkRecord(int capacity) async {
    await AppPrefs.instance.insertLog({
      'id': Uuid().v1(),
      "capacity": capacity,
      'datetime': DateTime.now().millisecondsSinceEpoch,
    });
    totalCapacity.value += capacity;
    _fetchRecords();
  }

  List<ChartData?> generateChartDatas() {
    List<ChartData?> chartDatas = List.filled(7, null);
    DateTime firstDayOfWeek =
        DateTimeUtils.dateOnly(DateTimeUtils.getSartAndEndDayOfWeek()[0]);

    for (int i = 0; i < 7; i++) {
      DailyDrinkRecord record = dailyRecords.value.firstWhere(
        (record) => DateTimeUtils.compareYMD(
            firstDayOfWeek, DateTimeUtils.dateOnly(record.date)),
        orElse: () =>
            DailyDrinkRecord(target: 2000, records: [], date: firstDayOfWeek),
      );
      chartDatas[i] = ChartData(
        DateTimeUtils.isToday(record.date)
            ? 'Today'
            : DateTimeUtils.nameOfDay(record.date),
        record,
      );
      firstDayOfWeek = firstDayOfWeek.add(const Duration(days: 1));
    }

    return chartDatas;
  }

  

  int getWeekAverage() {
    return generateChartDatas().fold(
        0,
        (previousValue, chartData) =>
            previousValue + (chartData?.record?.totalCapacity as int));
  }

  void deleteDrinkRecord(DrinkRecord record) async {
    // getTodayRecord().records.removeWhere((r) => r.id == record.id);
    await AppPrefs.instance.deleteLog(record.id);
    _fetchRecords();
  }
}
