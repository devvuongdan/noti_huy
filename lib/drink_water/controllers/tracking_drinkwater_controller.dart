import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings/tracking-drinkwater/models/app_prefs.dart';
import 'package:settings/tracking-drinkwater/models/daily_drink_record.dart';
import 'package:settings/utils/Constant.dart';
import 'package:settings/utils/Preference.dart';
import 'package:uuid/uuid.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import '../../base/base_controller.dart';

class DrinkwaterController extends BaseController {
  final count = 0.obs;
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  // bool isNotification = false;
  RxBool isNotification = false.obs;
  RxInt dropdownIntervalValue = 0.obs;
  // int dropdownIntervalValue = 30;
  RxString? _hour, _minute, _time = ''.obs;
  // String? _hour, _minute, _time;
  TextEditingController _timeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _notificationMSgController = TextEditingController();
  RxString? prefStartTimeValue = ''.obs;
  // String? prefStartTimeValue;
  RxString? prefEndTimeValue = ''.obs;
  // String? prefEndTimeValue;
  RxString? prefNotiMsg = ''.obs;
  // String? prefNotiMsg;

  // late BannerAd _bannerAd;
  RxBool _isBannerAdReady = false.obs;
  // bool _isBannerAdReady = false;

  @override
  void onInit() async {
    _getPreference();

    super.onInit();
  }

  void onTopBarClick(String name, BuildContext context, {bool value = true}) {
    if (name == Constant.STR_BACK) {
      showSaveChangeDialog(context);
    }
  }

  _getPreference() {
    prefStartTimeValue = Preference.shared
        .getString(Preference.START_TIME_REMINDER) as RxString?;
    prefEndTimeValue =
        Preference.shared.getString(Preference.END_TIME_REMINDER) as RxString?;
    prefNotiMsg = Preference.shared
        .getString(Preference.DRINK_WATER_NOTIFICATION_MESSAGE) as RxString?;
    isNotification = (Preference.shared.getBool(Preference.IS_REMINDER_ON) ??
        false) as RxBool;

    dropdownIntervalValue =
        (Preference.shared.getInt(Preference.DRINK_WATER_INTERVAL) ?? 30)
            as RxInt;

    if (prefStartTimeValue == null) {
      _startTimeController.text = "08:00 AM";
      prefStartTimeValue = "08:00" as RxString?;
    } else {
      var hr = int.parse(prefStartTimeValue!.split(":")[0]);
      var min = int.parse(prefStartTimeValue!.split(":")[1]);
      _startTimeController.text =
          DateFormat.jm().format(DateTime(2022, 08, 1, hr, min));
    }
    if (prefEndTimeValue == null) {
      _endTimeController.text = "11:00 PM";
      prefEndTimeValue = "23:00" as RxString?;
    } else {
      var hr = int.parse(prefEndTimeValue!.split(":")[0]);
      var min = int.parse(prefEndTimeValue!.split(":")[1]);
      _endTimeController.text =
          DateFormat.jm().format(DateTime(2022, 08, 1, hr, min));
    }
  }

  void showSaveChangeDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("hêlo"),
            actions: [
              TextButton(
                child: Text("hêlo"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Save'),
                onPressed: () async {
                  Preference.shared.setString(
                      Preference.END_TIME_REMINDER, prefEndTimeValue!.value);
                  Preference.shared.setString(Preference.START_TIME_REMINDER,
                      prefStartTimeValue!.value);
                  Preference.shared.setString(
                      Preference.DRINK_WATER_NOTIFICATION_MESSAGE,
                      _notificationMSgController.text);
                  Preference.shared
                      .setBool(Preference.IS_REMINDER_ON, isNotification.value);
                  Preference.shared.setInt(Preference.DRINK_WATER_INTERVAL,
                      dropdownIntervalValue.value);
                  // if (isNotification)
                  //   setWaterReminder();
                  // else {
                  //   List<PendingNotificationRequest> pendingNoti =
                  //       await flutterLocalNotificationsPlugin
                  //           .pendingNotificationRequests();

                  //   pendingNoti.forEach((element) {
                  //     if (element.payload != Constant.STR_RUNNING_REMINDER) {
                  //       Debug.printLog(
                  //           "Cancele Notification ::::::==> ${element.id}");
                  //       flutterLocalNotificationsPlugin.cancel(element.id);
                  //     }
                  //   });
                  // }
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
