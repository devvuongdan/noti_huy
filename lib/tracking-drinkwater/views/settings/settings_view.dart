import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings/drink_water/view/water.dart';
import 'package:settings/resources/app_constants.dart';

import '../../../base/base_view.dart';
import '../../controllers/tracking_drinkwater_controller.dart';

class SettingsView extends BaseView<TrackingDrinkwaterController> {
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: Palette.scaffold,
        foregroundColor: Palette.foregroundColor,
        elevation: 0.0,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: GetX<TrackingDrinkwaterController>(builder: (controller) {
            return ListView(
              children: [
                ListTile(
                  title: const Text(
                    'Mục tiêu',
                    style: TextStyle(color: Palette.foregroundColor),
                  ),
                  subtitle: Text(
                    'Hầu hết mọi người cần 2000 ml mỗi ngày.',
                    style: TextStyle(
                        color: Palette.foregroundColor.withOpacity(0.5)),
                  ),
                  trailing: DropdownButton<int>(
                    value: controller.target.value,
                    style: const TextStyle(color: Palette.foregroundColor),
                    dropdownColor: Palette.scaffold,
                    onChanged: (target) =>
                        controller.changeTarget(target ?? 500),
                    items: [
                      for (int i = 500; i < 5001; i += 500)
                        DropdownMenuItem(
                          value: i,
                          child: Text('$i ml'),
                        ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Thông báo',
                    style: TextStyle(color: Palette.foregroundColor),
                  ),
                  subtitle: Text(
                    'Cài đặt thông báo',
                    style: TextStyle(
                        color: Palette.foregroundColor.withOpacity(0.5)),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.next_plan,
                    ),
                    onPressed: () {
                      Get.to(DrinkWaterReminderScreen());
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      backgroundColor: Palette.scaffold,
    );
  }
}
