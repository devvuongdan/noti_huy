import 'package:get/get.dart';
import 'package:settings/drink_water/bindings/tracking_drinkwater_binding.dart';
import 'package:settings/drink_water/view/water.dart';

import '../tracking-drinkwater/bindings/tracking_drinkwater_binding.dart';
import '../tracking-drinkwater/views/water_reminder/water_reminder_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.TRACKING_DRINKWATER;

  static final routes = [
    GetPage(
      name: _Paths.TRACKING_DRINKWATER,
      page: () => TrackingDrinkwaterView(),
      binding: TrackingDrinkwaterBinding(),
    ),
    GetPage(
      name: _Paths.Drinkwater,
      page: () => DrinkWaterReminderScreen(),
      binding: DrinkwaterBinding(),
    ),
  ];
}
