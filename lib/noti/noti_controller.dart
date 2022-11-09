import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class NotificationController {
  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  ///

  //TODO: Hàm này dùng để khởi tạo các thông báo, setup môi trường và các thứ liên quan đến thông báo
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  ///
  // TODO: Hàm này chạy ở initstate của màn hình chính, để lắng nghe các sự kiện của thông báo
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      print(
          'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      await executeLongTaskInBackground();
    } else {
      MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/notification-page',
          (route) =>
              (route.settings.name != '/notification-page') || route.isFirst,
          arguments: receivedAction);
    }
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  ///
  // TODO: Hàm này dùng để yêu cầu cấp quyền cho ứng dụng
  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
    print("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    final re = await http.get(url);
    print(re.body);
    print("long task done");
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  ///
  // TODO: Hàm này dùng để tạo thông báo, thông báo này xổ xuống tức thì, trong đó check quyền dược cấp hay chưa bằng hàm AwesomeNotifications().isNotificationAllowed();
  // TODO: Check condition và tạo thông báo nếu đã đc cấp quyền, nếu chưa thì yêu cầu cấp quyền
  static Future<void> createNewNotification() async {
    // TODO: Đoạn này để check condition thôi, không có gì cả, cứ dùng y nguyên là đc
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            // TODO: đây là desgin của một cái thẻ toast thông báo, em có thể modified những cái này để tùy chỉnh
            id: -1, // -1 is replaced by a random number
            channelKey: 'alerts',
            title: 'Hế lô, đây là tiêu đề thông báo',
            body:
                "Còn đây là nội dung thông báo, em truyền bằng title ở ngoài vào cũng đc",
            bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
              requireInputText: true,
              actionType: ActionType.SilentAction),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ]);
  }

  // TODO: hàm này dùng để tạo thông báo định kì, xổ xuống theo thời gian, anh sẽ mô tả các trường bên dưới, trong đó check quyền dược cấp hay chưa bằng hàm AwesomeNotifications().isNotificationAllowed();

  static Future<void> scheduleNewNotification(
      {DateTime? displayTime = null}) async {
    // TODO: Đoạn này để check condition thôi, không có gì cả, cứ dùng y nguyên là đc
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: -1, // -1 is replaced by a random number
          channelKey: 'alerts',
          title: "Huston! The eagle has landed!",
          body:
              "A small step for a man, but a giant leap to Flutter's community!",
          bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
          largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
          //'asset://assets/images/balloons-in-sky.jpg',
          notificationLayout: NotificationLayout.BigPicture,
          payload: {'notificationId': '1234567890'}),
      actionButtons: [
        NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
        NotificationActionButton(
            key: 'DISMISS',
            label: 'Dismiss',
            actionType: ActionType.DismissAction,
            isDangerousOption: true)
      ],
      schedule: NotificationCalendar.fromDate(

          // date: displayTime ?? DateTime.now().add(const Duration(seconds: 10)),
          date:
              // TODO: bọn này đang hard code thời gian, em chọc vào thư viện của nó để xem nhé.
              // TODO: Đại khái là nó sẽ khởi tạo thông báo và xổ xuóng hàng ngày, ở thời điểm sau khi ấn nút này 10s.
              // TODO: Em có thể thay DateTime.now().add(Duration(seconds: 10)) bằng biến DateTime anh để trong ngoặc kia và truyền vào
              // TODO: từ hàm "Dan12345" (tìm string này để biết add vào từ đâu), em có thể comment dòng hard code của nó
              // TODO: và thay bằng hàm anh comment kia

              // Đây là hard code của nó
              DateTime.now().add(const Duration(seconds: 10))),
      //TODO: Giải thích thêm, fromdate là hàng ngày, và mặc định thằng này chỉ cho scedules hằng ngày.
      //TODO: Trong task set interval của em thì sẽ phải fork thư viện về và chỉnh sửa cái scedule này theo ý mình, (gợi ý là set
      //TODO: cho schedules không phải hằng ngày nữa mà là quãng thời gian em muốn, em có thể liên hệ thêm anh hướng dẫn cho)
    );
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}
