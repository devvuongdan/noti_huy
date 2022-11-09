import 'package:get/get.dart';
import 'package:settings/base/base_bindings.dart';



import '../controllers/tracking_drinkwater_controller.dart';

class TrackingDrinkwaterBinding extends BaseBindings {  
  @override
  void injectService() {
      Get.lazyPut<TrackingDrinkwaterController>(
      () => TrackingDrinkwaterController(),
    );
  }
}
