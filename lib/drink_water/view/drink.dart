import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:settings/localization/language/languages.dart';
import 'package:settings/noti/noti_controller.dart';
import 'package:settings/utils/Color.dart';
import 'package:settings/utils/Constant.dart';
import 'package:settings/utils/Preference.dart';
import 'package:settings/utils/Utils.dart';
import 'package:timezone/timezone.dart' as tz;

class DrinkWater extends StatefulWidget {
  @override
  _DrinkWaterState createState() => _DrinkWaterState();
}

class _DrinkWaterState extends State<DrinkWater> {
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
  void initState() {
    NotificationController.startListeningNotificationEvents();
    _getPreference();
    // _loadBanner();
    super.initState();
  }

  _getPreference() {
    prefStartTimeValue =
        Preference.shared.getString(Preference.START_TIME_REMINDER);
    prefEndTimeValue =
        Preference.shared.getString(Preference.END_TIME_REMINDER);
    prefNotiMsg = Preference.shared
        .getString(Preference.DRINK_WATER_NOTIFICATION_MESSAGE);
    isNotification =
        Preference.shared.getBool(Preference.IS_REMINDER_ON) ?? false;

    dropdownIntervalValue =
        Preference.shared.getInt(Preference.DRINK_WATER_INTERVAL) ?? 30;
    setState(() {
      if (prefStartTimeValue == null) {
        _startTimeController.text = "08:00 AM";
        prefStartTimeValue = "08:00";
      } else {
        var hr = int.parse(prefStartTimeValue!.split(":")[0]);
        var min = int.parse(prefStartTimeValue!.split(":")[1]);
        _startTimeController.text =
            DateFormat.jm().format(DateTime(2021, 08, 1, hr, min));
      }
      if (prefEndTimeValue == null) {
        _endTimeController.text = "11:00 PM";
        prefEndTimeValue = "23:00";
      } else {
        var hr = int.parse(prefEndTimeValue!.split(":")[0]);
        var min = int.parse(prefEndTimeValue!.split(":")[1]);
        _endTimeController.text =
            DateFormat.jm().format(DateTime(2021, 08, 1, hr, min));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    if (_notificationMSgController.text.isEmpty)
      _notificationMSgController.text =
          prefNotiMsg ?? Languages.of(context)!.txtDrinkWaterNotiMsg;
    return WillPopScope(
      onWillPop: () async {
        showSaveChangeDialog();
        requestUserPermissions(context, channelKey: '', permissionList: []);
        return false;
      },
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              FloatingActionButton(
                heroTag: '1',
                onPressed: () => NotificationController.createNewNotification(),
                tooltip: 'Create New notification',
                child: const Icon(
                  Icons.outgoing_mail,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                heroTag: '2',
                onPressed: () =>
                    // TODO: "Dan12345" thay null bằng giá trị DateTime em tạo ra từ time picker nhé
                    NotificationController.scheduleNewNotification(
                        displayTime: null),
                tooltip: 'Schedule New notification',
                child: const Icon(
                  Icons.access_time_outlined,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                heroTag: '3',
                onPressed: () => NotificationController.resetBadgeCounter(),
                tooltip: 'Reset badge counter',
                child: const Icon(
                  Icons.exposure_zero,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                heroTag: '4',
                onPressed: () => NotificationController.cancelNotifications(),
                tooltip: 'Cancel all notifications',
                child: const Icon(
                  Icons.delete_forever,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colur.common_bg_dark,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.back_hand),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                showSaveChangeDialog();
              },
            )
          ],
        ),
        body: Container(
          child: Column(children: [
            Container(
              child: Expanded(
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
            ),
          ]),
        ),
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
              _selectTime(context, "Bắt Đầu", _startTime);
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
                  ),
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
              _selectTime(context, "Kết thúc", _endTime);
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
          Container(
            child: Row(
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
    setState(() {
      selectedTime = picked;
      _hour = selectedTime.hour.toString();
      _minute = selectedTime.minute.toString();
      _time = _hour! + ' : ' + _minute!;
      _timeController.text = _time!;
      if (s == "START") {
        _startTimeController.text = DateFormat.jm().format(
            DateTime(2021, 08, 1, selectedTime.hour, selectedTime.minute));

        if (selectedTime.hour > int.parse(prefEndTimeValue!.split(":")[0])) {
          _endTimeController.text = DateFormat.jm().format(DateTime(
              2021, 08, 1, selectedTime.hour + 1, selectedTime.minute));
          var newtime = (selectedTime.hour + 1).toString() +
              ' : ' +
              (selectedTime.minute).toString();
          prefEndTimeValue = newtime;
        }

        prefStartTimeValue = _time!;
      } else {
        _endTimeController.text = DateFormat.jm().format(
            DateTime(2021, 08, 1, selectedTime.hour, selectedTime.minute));
        if (int.parse(prefStartTimeValue!.split(":")[0]) > selectedTime.hour) {
          _startTimeController.text = DateFormat.jm().format(DateTime(
              2021, 08, 1, selectedTime.hour - 1, selectedTime.minute));
          print(
              "${int.parse(prefStartTimeValue!.split(":")[0])}::::::${selectedTime.hour}");
          var newtime = (selectedTime.hour + 1).toString() +
              ' : ' +
              (selectedTime.minute).toString();
          prefStartTimeValue = newtime;
        }
        prefEndTimeValue = _time!;
      }
    });
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
          setState(() {
            isNotification = true;
          });
        } else {
          setState(() {
            isNotification = false;
          });
        }
      },
      value: isNotification,
      activeColor: Colur.purple_gradient_color2,
      inactiveTrackColor: Colur.txt_grey,
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_BACK) {
      showSaveChangeDialog();
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
          setState(() {
            dropdownIntervalValue = val as int;
          });
        });
  }

  _commonTextStyle() {
    return const TextStyle(
        color: Colur.txt_white, fontSize: 17, fontWeight: FontWeight.w400);
  }

  setWaterReminder() async {
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
      // flutter local notifications
      // Debug.printLog(
      //     "Schedule Notification at ::::::==> id= $notificationId ${scheduledDate}");
      //   await flutterLocalNotificationsPlugin.zonedSchedule(
      //       notificationId,
      //       titleText,
      //       msg,
      //       scheduledDate,
      // const NotificationDetails(
      //   android: AndroidNotificationDetails(
      //       'drink_water_reminder', 'Drink Water',
      //       channelDescription:
      //           'This is reminder for drinking water on time',
      //       icon: 'ic_launcher'),
      //   // iOS: IOSNotificationDetails(),
      // ),
      // androidAllowWhileIdle: true,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      // matchDateTimeComponents: DateTimeComponents.time,
      // payload: scheduledDate.millisecondsSinceEpoch.toString());
      // }

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1,
            channelKey: 'scheduled',
            title: 'Notification at every single minute',
            body: 'Uống nước bn ơi',
            notificationLayout: NotificationLayout.BigPicture,
            bigPicture: 'asset://assets/images/melted-clock.png'),
        schedule: NotificationInterval(
          interval: 5,
          timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
          repeats: true,
        ),
      );
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

  static Future<List<NotificationPermission>> requestUserPermissions(
      BuildContext context,
      {
      // if you only intends to request the permissions until app level, set the channelKey value to null
      required String? channelKey,
      required List<NotificationPermission> permissionList}) async {
    // Check if the basic permission was conceived by the user
    // Check which of the permissions you need are allowed at this time
    List<NotificationPermission> permissionsAllowed =
        await AwesomeNotifications().checkPermissionList(
            channelKey: channelKey, permissions: permissionList);

    // If all permissions are allowed, there is nothing to do
    if (permissionsAllowed.length == permissionList.length)
      return permissionsAllowed;

    // Refresh the permission list with only the disallowed permissions
    List<NotificationPermission> permissionsNeeded =
        permissionList.toSet().difference(permissionsAllowed.toSet()).toList();

    // Check if some of the permissions needed request user's intervention to be enabled
    List<NotificationPermission> lockedPermissions =
        await AwesomeNotifications().shouldShowRationaleToRequest(
            channelKey: channelKey, permissions: permissionsNeeded);

    // If there is no permissions depending on user's intervention, so request it directly
    if (lockedPermissions.isEmpty) {
      // Request the permission through native resources.
      await AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: channelKey, permissions: permissionsNeeded);

      // After the user come back, check if the permissions has successfully enabled
      permissionsAllowed = await AwesomeNotifications().checkPermissionList(
          channelKey: channelKey, permissions: permissionsNeeded);
    } else {
      // If you need to show a rationale to educate the user to conceived the permission, show it
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Color(0xfffbfbfb),
                title: Text(
                  'Awesome Notifications needs your permission',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/animated-clock.gif',
                      height: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.fitWidth,
                    ),
                    Text(
                      'To proceed, you need to enable the permissions above' +
                          (channelKey?.isEmpty ?? true
                              ? ''
                              : ' on channel $channelKey') +
                          ':',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      lockedPermissions
                          .join(', ')
                          .replaceAll('NotificationPermission.', ''),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Deny',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      )),
                  TextButton(
                    onPressed: () async {
                      // Request the permission through native resources. Only one page redirection is done at this point.
                      await AwesomeNotifications()
                          .requestPermissionToSendNotifications(
                              channelKey: channelKey,
                              permissions: lockedPermissions);

                      // After the user come back, check if the permissions has successfully enabled
                      permissionsAllowed = await AwesomeNotifications()
                          .checkPermissionList(
                              channelKey: channelKey,
                              permissions: lockedPermissions);

                      Navigator.pop(context);
                    },
                    child: Text(
                      'Allow',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ));
    }

    // Return the updated list of allowed permissions
    return permissionsAllowed;
  }

  void showSaveChangeDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(Languages.of(context)!.txtSaveChanges),
            actions: [
              TextButton(
                child: Text(Languages.of(context)!.txtCancel),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(Languages.of(context)!.txtSave),
                onPressed: () async {
                  Preference.shared.setString(
                      Preference.END_TIME_REMINDER, prefEndTimeValue!);
                  Preference.shared.setString(
                      Preference.START_TIME_REMINDER, prefStartTimeValue!);
                  Preference.shared.setString(
                      Preference.DRINK_WATER_NOTIFICATION_MESSAGE,
                      _notificationMSgController.text);
                  Preference.shared
                      .setBool(Preference.IS_REMINDER_ON, isNotification);
                  Preference.shared.setInt(
                      Preference.DRINK_WATER_INTERVAL, dropdownIntervalValue);
                  if (isNotification) {
                    setWaterReminder();
                  } else {
                    //flutter local notifications

                    // List<PendingNotificationRequest> pendingNoti =
                    //     await flutterLocalNotificationsPlugin

                    //      .pendingNotificationRequests();
                    // pendingNoti.forEach((element) {
                    //   if (element.payload != Constant.STR_RUNNING_REMINDER) {
                    //     Debug.printLog(
                    //         "Cancele Notification ::::::==> ${element.id}");
                    //     flutterLocalNotificationsPlugin.cancel(element.id);
                    //   }
                    // });

                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
