// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../main.dart';

// class NotificationController {
//   static ReceivedAction? initialAction;
//   static Future<void> initializeLocalNotifications() async {
//     await AwesomeNotifications().initialize(
//         null, //'resource://drawable/res_app_icon',//
//         [
//           NotificationChannel(
//               channelKey: 'alerts',
//               channelName: 'Alerts',
//               channelDescription: 'Notification tests as alerts',
//               playSound: true,
//               onlyAlertOnce: true,
//               groupAlertBehavior: GroupAlertBehavior.Children,
//               importance: NotificationImportance.High,
//               defaultPrivacy: NotificationPrivacy.Private,
//               defaultColor: Colors.deepPurple,
//               ledColor: Colors.deepPurple)
//         ],
//         debug: true);

//     // Nhận thông báo ban đầu là tùy chọn
//     initialAction = await AwesomeNotifications()
//         .getInitialNotificationAction(removeFromActionEvents: false);
//   }

//   ///  *********************************************
//   ///     NOTIFICATION EVENTS LISTENER
//   ///  *********************************************
//   /// Các sự kiện thông báo chỉ được gửi sau khi gọi phương thức này
//   static Future<void> startListeningNotificationEvents() async {
//     AwesomeNotifications()
//         .setListeners(onActionReceivedMethod: onActionReceivedMethod);
//   }

//   ///  *********************************************
//   ///     NOTIFICATION EVENTS
//   ///  *********************************************
//   ///
//   @pragma('vm:entry-point')
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     if (receivedAction.actionType == ActionType.SilentAction ||
//         receivedAction.actionType == ActionType.SilentBackgroundAction) {
//       // Đối với các hành động nền, bạn phải giữ quá trình thực thi cho đến khi kết thúc
//       print(
//           'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
//       await executeLongTaskInBackground();
//     } else {
//       MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
//           '/notification-page',
//           (route) =>
//               (route.settings.name != '/notification-page') || route.isFirst,
//           arguments: receivedAction);
//     }
//   }

//   static Future<bool> displayNotificationRationale() async {
//     bool userAuthorized = false;
//     BuildContext context = MyApp.navigatorKey.currentContext!;
//     await showDialog(
//         context: context,
//         builder: (BuildContext ctx) {
//           return AlertDialog(
//             title: Text('Get Notified!',
//                 style: Theme.of(context).textTheme.titleLarge),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Image.asset(
//                         'assets/animated-bell.gif',
//                         height: MediaQuery.of(context).size.height * 0.3,
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                     'Allow Awesome Notifications to send you beautiful notifications!'),
//               ],
//             ),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(ctx).pop();
//                   },
//                   child: Text(
//                     'Deny',
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.red),
//                   )),
//               TextButton(
//                   onPressed: () async {
//                     userAuthorized = true;
//                     Navigator.of(ctx).pop();
//                   },
//                   child: Text(
//                     'Allow',
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.deepPurple),
//                   )),
//             ],
//           );
//         });
//     return userAuthorized &&
//         await AwesomeNotifications().requestPermissionToSendNotifications();
//   }

//   static Future<void> executeLongTaskInBackground() async {
//     print("starting long task");
//     await Future.delayed(const Duration(seconds: 4));
//     final url = Uri.parse("http://google.com");
//     final re = await http.get(url);
//     print(re.body);
//     print("long task done");
//   }
// // lên lịch

//   static Future<void> createlich() async {
//     String localTimeZone =
//         await AwesomeNotifications().getLocalTimeZoneIdentifier();
//     String utcTimeZone =
//         await AwesomeNotifications().getLocalTimeZoneIdentifier();

//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: -1,
//             channelKey: 'scheduled',
//             title: 'Notification at every single minute',
//             body:
//                 'This notification was schedule to repeat at every single minute.',
//             notificationLayout: NotificationLayout.BigPicture,
//             bigPicture: 'asset://assets/images/melted-clock.png'),
//         schedule: NotificationInterval(
//             interval: 5, timeZone: localTimeZone, repeats: true));
//   }

//   //thêm thông báo
//   static Future<void> createNewNotification() async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) isAllowed = await displayNotificationRationale();
//     if (!isAllowed) return;

//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: -1, // -1 is replaced by a random number
//             channelKey: 'alerts',
//             title: 'Huston! The eagle has landed!',
//             body:
//                 "A small step for a man, but a giant leap to Flutter's community!",
//             bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
//             largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
//             //'asset://assets/images/balloons-in-sky.jpg',
//             notificationLayout: NotificationLayout.BigPicture,
//             payload: {'notificationId': '1234567890'}),
//         actionButtons: [
//           NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
//           NotificationActionButton(
//               key: 'REPLY',
//               label: 'Reply Message',
//               requireInputText: true,
//               actionType: ActionType.SilentAction),
//           NotificationActionButton(
//               key: 'DISMISS',
//               label: 'Dismiss',
//               actionType: ActionType.DismissAction,
//               isDangerousOption: true)
//         ]);
//   }

// // thông báo kick hẹn
//   static Future<void> scheduleNewNotification() async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) isAllowed = await displayNotificationRationale();
//     if (!isAllowed) return;

//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: -1, // -1 is replaced by a random number
//             channelKey: 'alerts',
//             title: "Huston! The eagle has landed!",
//             body:
//                 "A small step for a man, but a giant leap to Flutter's community!",
//             bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
//             largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
//             //'asset://assets/images/balloons-in-sky.jpg',
//             notificationLayout: NotificationLayout.BigPicture,
//             payload: {
//               'notificationId': '1234567890'
//             }),
//         actionButtons: [
//           NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
//           NotificationActionButton(
//               key: 'DISMISS',
//               label: 'Dismiss',
//               actionType: ActionType.DismissAction,
//               isDangerousOption: true)
//         ],
//         schedule: NotificationCalendar.fromDate(
//             date: DateTime.now().add(const Duration(seconds: 10))));
//   }

//   static Future<void> resetBadgeCounter() async {
//     await AwesomeNotifications().resetGlobalBadge();
//   }

//   static Future<void> cancelNotifications() async {
//     await AwesomeNotifications().cancelAll();
//   }

//   static Future<List<NotificationPermission>> requestUserPermissions(
//       BuildContext context,
//       {
//       // if you only intends to request the permissions until app level, set the channelKey value to null
//       required String? channelKey,
//       required List<NotificationPermission> permissionList}) async {
//     // Check if the basic permission was conceived by the user
//     // if(!await requestBasicPermissionToSendNotifications(context))
//     //   return [];

//     // Kiểm tra những quyền nào bạn cần được cho phép vào lúc này
//     List<NotificationPermission> permissionsAllowed =
//         await AwesomeNotifications().checkPermissionList(
//             channelKey: channelKey, permissions: permissionList);

//     // If all permissions are allowed, there is nothing to do
//     if (permissionsAllowed.length == permissionList.length)
//       return permissionsAllowed;

//     // Refresh the permission list with only the disallowed permissions
//     List<NotificationPermission> permissionsNeeded =
//         permissionList.toSet().difference(permissionsAllowed.toSet()).toList();

//     // Kiểm tra xem một số quyền cần thiết có yêu cầu sự can thiệp của người dùng được bật hay không
//     List<NotificationPermission> lockedPermissions =
//         await AwesomeNotifications().shouldShowRationaleToRequest(
//             channelKey: channelKey, permissions: permissionsNeeded);

//     //Nếu không có quyền tùy thuộc vào sự can thiệp của người dùng, vì vậy hãy yêu cầu trực tiếp
//     if (lockedPermissions.isEmpty) {
//       // Yêu cầu sự cho phép thông qua các tài nguyên bản địa.
//       await AwesomeNotifications().requestPermissionToSendNotifications(
//           channelKey: channelKey, permissions: permissionsNeeded);

//       // Sau khi người dùng quay lại, hãy kiểm tra xem các quyền đã được kích hoạt thành công chưa
//       permissionsAllowed = await AwesomeNotifications().checkPermissionList(
//           channelKey: channelKey, permissions: permissionsNeeded);
//     } else {
//       // If you need to show a rationale to educate the user to conceived the permission, show it
//       await showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//                 backgroundColor: Color(0xfffbfbfb),
//                 title: Text(
//                   'Awesome Notifications needs your permission',
//                   textAlign: TextAlign.center,
//                   maxLines: 2,
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
//                 ),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Image.asset(
//                       'assets/images/animated-clock.gif',
//                       height: MediaQuery.of(context).size.height * 0.3,
//                       fit: BoxFit.fitWidth,
//                     ),
//                     Text(
//                       'To proceed, you need to enable the permissions above' +
//                           (channelKey?.isEmpty ?? true
//                               ? ''
//                               : ' on channel $channelKey') +
//                           ':',
//                       maxLines: 2,
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       lockedPermissions
//                           .join(', ')
//                           .replaceAll('NotificationPermission.', ''),
//                       maxLines: 2,
//                       textAlign: TextAlign.center,
//                       style:
//                           TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//                 actions: [
//                   TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         'Deny',
//                         style: TextStyle(color: Colors.red, fontSize: 18),
//                       )),
//                   TextButton(
//                     onPressed: () async {
//                       // Request the permission through native resources. Only one page redirection is done at this point.
//                       await AwesomeNotifications()
//                           .requestPermissionToSendNotifications(
//                               channelKey: channelKey,
//                               permissions: lockedPermissions);

//                       // After the user come back, check if the permissions has successfully enabled
//                       permissionsAllowed = await AwesomeNotifications()
//                           .checkPermissionList(
//                               channelKey: channelKey,
//                               permissions: lockedPermissions);

//                       Navigator.pop(context);
//                     },
//                     child: Text(
//                       'Allow',
//                       style: TextStyle(
//                           color: Colors.deepPurple,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ));
//     }

//     // Return the updated list of allowed permissions
//     return permissionsAllowed;
//   }
// }
