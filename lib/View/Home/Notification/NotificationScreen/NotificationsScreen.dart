import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controller/HomeController/NotificationController/NotificationController.dart';
import '../../../../Custom/MyColors.dart';
import '../NotificationsListView/NotificationsListView.dart';
import '../SendNotificationView/SendNotificationView.dart';


class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Manage your Notifications'.tr,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: MyColors.primaryText,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            //bottom of the header
            Text(
              'See all your notifications and send it for anyone.'.tr,
              style: const TextStyle(fontSize: 13.5, color: Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 24),
            // Layout
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 768) {
                    return Column(
                      children: [
                        //List of Notifications
                        Expanded(child: NotificationsListView()),
                        const SizedBox(height: 16),
                        // Send Notification Section
                        SendNotificationView(),
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: NotificationsListView()),
                      const SizedBox(width: 20),
                      Expanded(flex: 6, child: SendNotificationView()),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
