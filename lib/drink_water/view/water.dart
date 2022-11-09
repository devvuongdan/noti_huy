import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:settings/base/base_view.dart';
import 'package:settings/drink_water/controllers/tracking_drinkwater_controller.dart';
import 'package:settings/localization/language/languages.dart';
import 'package:settings/tracking-drinkwater/views/water_reminder/water_reminder_view.dart';
import 'package:settings/utils/Color.dart';
import 'package:settings/utils/Constant.dart';
import 'package:settings/utils/Debug.dart';
import 'package:settings/utils/Utils.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../main.dart';

class DrinkWaterReminderScreen extends BaseView<DrinkwaterController> {
  bool isNotification = false;
  int dropdownIntervalValue = 30;

  String? _hour, _minute, _time;
  TextEditingController _timeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _notificationMSgController = TextEditingController();

  String? prefStartTimeValue;
  String? prefEndTimeValue;
  String? prefNotiMsg;

  // late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  @override
  Widget buildView(BuildContext context) {
    var fullHeight = Get.height;
    var fullWidth = Get.width;
    if (_notificationMSgController.text.isEmpty) {
      _notificationMSgController.text =
          prefNotiMsg ?? Languages.of(context)!.txtDrinkWaterNotiMsg;
    }
    return WillPopScope(
      onWillPop: () async {
        controller.showSaveChangeDialog(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colur.common_bg_dark,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.back_hand),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TrackingDrinkwaterView()));
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                controller.showSaveChangeDialog(context);
              },
            )
          ],
        ),
        body: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: _notificationRadioButton(
                        context, fullWidth, fullHeight),
                  ),
                ],
              ),
            ),
          ),
          // if (_isBannerAdReady)
          //   Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Container(
          //       width: _bannerAd.size.width.toDouble(),
          //       height: _bannerAd.size.height.toDouble(),
          //       child: AdWidget(ad: _bannerAd),
          //     ),
          //   ),
        ]),
      ),
    );
  }

  _notificationRadioButton(
      BuildContext context, double fullWidth, double fullHeight) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                Languages.of(context)!.txtNotifications,
                style: const TextStyle(
                    color: Colur.txt_white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              Expanded(child: Container()),
              buildSwitch(),
            ],
          ),
          buildDivider(),
          buildTitleText(fullWidth, fullHeight, context,
              Languages.of(context)!.txtSchedule),
          InkWell(
            onTap: () {
              var hr = int.parse(prefStartTimeValue!.split(":")[0]);
              var min = int.parse(prefStartTimeValue!.split(":")[1]);

              TimeOfDay _startTime = TimeOfDay(hour: hr, minute: min);
              _selectTime(context, "START", _startTime);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: [
                  Text(
                    Languages.of(context)!.txtStart,
                    style: const TextStyle(
                        color: Colur.txt_white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Expanded(child: Container()),
                  Text(
                    _startTimeController.text,
                    style: const TextStyle(
                        color: Colur.txt_white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colur.white,
                    size: 20,
                  )
                ],
              ),
            ),
          ),
          buildDivider(),
          InkWell(
            onTap: () {
             var hr = int.parse(prefEndTimeValue!.split(":")[0]);
              var min = int.parse(prefEndTimeValue!.split(":")[1]);

              TimeOfDay _endTime = TimeOfDay(hour: hr, minute: min);
              _selectTime(context, "END", _endTime);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: [
                  Text(
                    Languages.of(context)!.txtEnd,
                    style: const TextStyle(
                        color: Colur.txt_white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Expanded(child: Container()),
                  Text(
                    _endTimeController.text,
                    style: const TextStyle(
                        color: Colur.txt_white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colur.white,
                    size: 20,
                  )
                ],
              ),
            ),
          ),
          buildDivider(),
          Row(
            children: [
              Expanded(
                child: Text(
                  Languages.of(context)!.txtInterval,
                  style: const TextStyle(
                      color: Colur.txt_white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              _intervalDropdown(context),
            ],
          ),
          buildDivider(),
          buildTitleText(fullWidth, fullHeight, context,
              Languages.of(context)!.txtMessage),
          _buildTextField(context, fullWidth, fullHeight),
        ],
      ),
    );
  }

  _buildTextField(BuildContext context, double fullWidth, double fullHeight) {
    return Container(
      child: TextFormField(
        maxLines: 1,
        textInputAction: TextInputAction.done,
        controller: _notificationMSgController,
        keyboardType: TextInputType.text,
        style: const TextStyle(
            color: Colur.txt_white, fontSize: 18, fontWeight: FontWeight.w500),
        cursorColor: Colur.txt_grey,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Future<void> _selectTime(
      BuildContext context, String s, TimeOfDay selectedTime) async {
    final TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: selectedTime,
    ))!;

    selectedTime = picked;
    _hour = selectedTime.hour.toString();
    _minute = selectedTime.minute.toString();
    _time = '${_hour!} : ${_minute!}';
    _timeController.text = _time!;
    if (s == "START") {
      _startTimeController.text = DateFormat.jm().format(
          DateTime(2021, 08, 1, selectedTime.hour, selectedTime.minute));

      if (selectedTime.hour > int.parse(prefEndTimeValue!.split(":")[0])) {
        _endTimeController.text = DateFormat.jm().format(
            DateTime(2021, 08, 1, selectedTime.hour + 1, selectedTime.minute));
        var newtime = '${selectedTime.hour + 1} : ${selectedTime.minute}';
        prefEndTimeValue = newtime;
      }

      prefStartTimeValue = _time!;
    } else {
      _endTimeController.text = DateFormat.jm().format(
          DateTime(2021, 08, 1, selectedTime.hour, selectedTime.minute));
      if (int.parse(prefStartTimeValue!.split(":")[0]) > selectedTime.hour) {
        _startTimeController.text = DateFormat.jm().format(
            DateTime(2021, 08, 1, selectedTime.hour - 1, selectedTime.minute));
        print(
            "${int.parse(prefStartTimeValue!.split(":")[0])}::::::${selectedTime.hour}");
        var newtime = '${selectedTime.hour + 1} : ${selectedTime.minute}';
        prefStartTimeValue = newtime;
      }
      prefEndTimeValue = _time!;
    }
  }

  buildTitleText(
      double fullWidth, double fullHeight, BuildContext context, String title) {
    return Container(
      alignment: Alignment.centerLeft,
      margin:
          EdgeInsets.only(top: fullHeight * 0.02, bottom: fullHeight * 0.02),
      child: Text(
        title,
        style: const TextStyle(
            color: Colur.txt_grey, fontWeight: FontWeight.w400, fontSize: 14),
      ),
    );
  }

  buildDivider() {
    return const Divider(
      color: Colur.txt_grey,
    );
  }

  buildSwitch() {
    return Switch(
      onChanged: (bool value) async {
        var status = await Permission.notification.status;
        if (status.isDenied) {
          await Permission.notification.request();
        }

        if (status.isPermanentlyDenied) {
          openAppSettings();
        }

        if (isNotification == false) {
          isNotification = true;
        } else {
          isNotification = false;
        }
      },
      value: isNotification,
      activeColor: Colur.purple_gradient_color2,
      inactiveTrackColor: Colur.txt_grey,
    );
  }

  @override
  void onTopBarClick(String name, BuildContext context, {bool value = true}) {
    if (name == Constant.STR_BACK) {
      controller.showSaveChangeDialog(context);
    }
  }

  _intervalDropdown(BuildContext context) {
    return DropdownButton(
        value: dropdownIntervalValue,
        iconDisabledColor: Colur.white,
        iconEnabledColor: Colur.white,
        underline: Container(
          color: Colur.transparent,
        ),
        dropdownColor: Colur.common_bg_dark,
        items: [
          DropdownMenuItem(
            value: 30,
            child: Text(Utils.getIntervalString(context, 30),
                style: _commonTextStyle()),
          ),
          DropdownMenuItem(
            value: 60,
            child: Text(Utils.getIntervalString(context, 60),
                style: _commonTextStyle()),
          ),
          DropdownMenuItem(
            value: 90,
            child: Text(Utils.getIntervalString(context, 90),
                style: _commonTextStyle()),
          ),
          DropdownMenuItem(
            value: 120,
            child: Text(Utils.getIntervalString(context, 120),
                style: _commonTextStyle()),
          ),
          DropdownMenuItem(
            value: 150,
            child: Text(Utils.getIntervalString(context, 150),
                style: _commonTextStyle()),
          ),
          DropdownMenuItem(
              value: 180,
              child: Text(Utils.getIntervalString(context, 180),
                  style: _commonTextStyle())),
          DropdownMenuItem(
              value: 210,
              child: Text(Utils.getIntervalString(context, 210),
                  style: _commonTextStyle())),
          DropdownMenuItem(
              value: 240,
              child: Text(Utils.getIntervalString(context, 240),
                  style: _commonTextStyle())),
        ],
        onChanged: (val) {
          dropdownIntervalValue = val as int;
        });
  }

  _commonTextStyle() {
    return const TextStyle(
        color: Colur.txt_white, fontSize: 17, fontWeight: FontWeight.w400);
  }

// set hẹn lịch show thông báo
 Future setWaterReminder(BuildContext context) async {
    var titleText = Languages.of(context)!.txtTimeToHydrate;
    var msg = _notificationMSgController.text;
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    //  List<PendingNotificationRequest> pendingNoti =
    //       await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    //   pendingNoti.forEach((element) {
    //     if (element.payload != Constant.STR_RUNNING_REMINDER) {
    //       Debug.printLog("Cancele Notification ::::::==> ${element.id}");
    //       flutterLocalNotificationsPlugin.cancel(element.id);
    //     }
    //   });
  
    

    tz.TZDateTime startTime = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
            int.parse(prefStartTimeValue!.split(":")[0]),
            int.parse(prefStartTimeValue!.split(":")[1]))
        .toLocal();
    tz.TZDateTime endTime = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
            int.parse(prefEndTimeValue!.split(":")[0]),
            int.parse(prefEndTimeValue!.split(":")[1]))
        .toLocal();

    scheduledNotification(
        tz.TZDateTime scheduledDate, int notificationId) async {
      Debug.printLog(
          "Schedule Notification at ::::::==> id= $notificationId ${scheduledDate}");
      // await flutterLocalNotificationsPlugin.zonedSchedule(
      //     notificationId,
      //     titleText,
      //     msg,
      //     scheduledDate,
      //     const NotificationDetails(
      //       android: AndroidNotificationDetails(
      //           'drink_water_reminder', 'Drink Water',
      //           channelDescription:
      //               'This is reminder for drinking water on time',
      //           icon: 'ic_launcher'),
      //       // iOS: IOSNotificationDetails(),
      //     ),
      //     androidAllowWhileIdle: true,

      //     matchDateTimeComponents: DateTimeComponents.time,
      //     payload: scheduledDate.millisecondsSinceEpoch.toString());
      await AwesomeNotifications().createNotification(
    
          content: NotificationContent(
              id: -1,
              channelKey: 'scheduled',
              title: 'Notification at every single minute',
              body:
                  'This notification was schedule to repeat at every single minute.',
              notificationLayout: NotificationLayout.BigPicture,
              bigPicture: 'asset://assets/images/melted-clock.png'),
          schedule: NotificationInterval(
              interval: 5,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              repeats: true));
    }

    var interVal = dropdownIntervalValue;
    var notificationId = 1;
    while (startTime.isBefore(endTime)) {
      tz.TZDateTime newScheduledDate = startTime;
      if (newScheduledDate.isBefore(now)) {
        newScheduledDate = newScheduledDate.add(const Duration(days: 1));
      }
      await scheduledNotification(newScheduledDate, notificationId);
      notificationId += 1;
      startTime = startTime.add(Duration(minutes: interVal));
    }
  }
}
