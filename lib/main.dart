import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings/drink_water/view/drink.dart';
import 'package:settings/noti/noti_controller.dart';
import 'package:settings/tracking-drinkwater/models/app_prefs.dart';
import 'package:settings/utils/Color.dart';
import 'package:settings/utils/Debug.dart';
import 'package:settings/utils/Preference.dart';
import 'localization/locale_constant.dart';
import 'localization/localizations_delegate.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//     BehaviorSubject<ReceivedNotification>();

// final BehaviorSubject<String?> selectNotificationSubject =
//     BehaviorSubject<String?>();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preference().instance();
  await NotificationController.initializeLocalNotifications();

  await AppPrefs.instance.initListener();
  tz.initializeTimeZones();
  var detroit = tz.getLocation('Asia/Bangkok');
  tz.setLocalLocation(detroit);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final navigatorKey = new GlobalKey<NavigatorState>();
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  bool isFirstTimeUser = true;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    _locale = getLocale();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // _initGoogleMobileAds();
    isFirstTime();
    super.initState();
  }

  isFirstTime() async {
    isFirstTimeUser =
        Preference.shared.getBool(Preference.IS_USER_FIRSTTIME) ?? true;
    Debug.printLog(isFirstTimeUser.toString());
  }

// Routes:
  static const String routeHome = '/', routeNotification = '/notification-page';
  List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName) {
    List<Route<dynamic>> pageStack = [];
    pageStack.add(MaterialPageRoute(builder: (_) => DrinkWater()));
    if (initialRouteName == routeNotification &&
        NotificationController.initialAction != null) {
      pageStack.add(MaterialPageRoute(
          builder: (_) => NotificationPage(
              receivedAction: NotificationController.initialAction!)));
    }
    return pageStack;
  }

  // Generate Routes:
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeHome:
        return MaterialPageRoute(builder: (_) => DrinkWater());

      case routeNotification:
        ReceivedAction receivedAction = settings.arguments as ReceivedAction;
        return MaterialPageRoute(
            builder: (_) => NotificationPage(receivedAction: receivedAction));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onGenerateRoute: onGenerateRoute,
      navigatorKey: MyApp.navigatorKey,
      // builder: (context, child) {
      //   return MediaQuery(
      //     child: child!,
      //     data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      //   );
      // },
      // onGenerateInitialRoutes: (initialRoute) {
      //   return [
      //     MaterialPageRoute(
      //       builder: (context) => DrinkWater(),
      //     ),
      //   ];
      // },
      theme: ThemeData(
        splashColor: Colur.transparent,
        highlightColor: Colur.transparent,
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('zh', ''),
        Locale('es', ''),
        Locale('de', ''),
        Locale('pt', ''),
        Locale('ar', ''),
        Locale('fr', ''),
        Locale('ja', ''),
        Locale('ru', ''),
        Locale('ur', ''),
        Locale('hi', ''),
        Locale('vi', ''),
        Locale('id', ''),
        Locale('bn', ''),
        Locale('ta', ''),
        Locale('te', ''),
        Locale('tr', ''),
        Locale('ko', ''),
        Locale('pa', ''),
        Locale('it', ''),
      ],
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        // GlobalMaterialLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
        // GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colur.white, brightness: Brightness.light),
        appBarTheme: AppBarTheme(
          backgroundColor: Colur.transparent,
        ),
      ),
      // initialRoute: AppPages.INITIAL,
      // getPages: AppPages.routes,

      // home: DrinkWater(),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key, required this.receivedAction})
      : super(key: key);

  final ReceivedAction receivedAction;

  @override
  Widget build(BuildContext context) {
    bool hasLargeIcon = receivedAction.largeIconImage != null;
    bool hasBigPicture = receivedAction.bigPictureImage != null;
    double bigPictureSize = MediaQuery.of(context).size.height * .4;
    double largeIconSize =
        MediaQuery.of(context).size.height * (hasBigPicture ? .12 : .2);

    return Scaffold(
      appBar: AppBar(
        title: Text(receivedAction.title ?? receivedAction.body ?? ''),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height:
                    hasBigPicture ? bigPictureSize + 40 : largeIconSize + 60,
                child: hasBigPicture
                    ? Stack(
                        children: [
                          if (hasBigPicture)
                            FadeInImage(
                              placeholder: const NetworkImage(
                                  'https://cdn.syncfusion.com/content/images/common/placeholder.gif'),
                              //AssetImage('assets/images/placeholder.gif'),
                              height: bigPictureSize,
                              width: MediaQuery.of(context).size.width,
                              image: receivedAction.bigPictureImage!,
                              fit: BoxFit.cover,
                            ),
                          if (hasLargeIcon)
                            Positioned(
                              bottom: 15,
                              left: 20,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(largeIconSize)),
                                child: FadeInImage(
                                  placeholder: const NetworkImage(
                                      'https://cdn.syncfusion.com/content/images/common/placeholder.gif'),
                                  //AssetImage('assets/images/placeholder.gif'),
                                  height: largeIconSize,
                                  width: largeIconSize,
                                  image: receivedAction.largeIconImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                        ],
                      )
                    : Center(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(largeIconSize)),
                          child: FadeInImage(
                            placeholder: const NetworkImage(
                                'https://cdn.syncfusion.com/content/images/common/placeholder.gif'),
                            //AssetImage('assets/images/placeholder.gif'),
                            height: largeIconSize,
                            width: largeIconSize,
                            image: receivedAction.largeIconImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    if (receivedAction.title?.isNotEmpty ?? false)
                      TextSpan(
                        text: receivedAction.title!,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    if ((receivedAction.title?.isNotEmpty ?? false) &&
                        (receivedAction.body?.isNotEmpty ?? false))
                      TextSpan(
                        text: '\n\n',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    if (receivedAction.body?.isNotEmpty ?? false)
                      TextSpan(
                        text: receivedAction.body!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ]))
                ],
              ),
            ),
            Container(
              color: Colors.black12,
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Text(receivedAction.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
