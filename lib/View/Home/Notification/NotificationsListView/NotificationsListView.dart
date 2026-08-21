import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controller/HomeController/NotificationController/NotificationController.dart';
import '../../../../Model/HomeModel/NotificationModel.dart';


class NotificationsListView extends StatefulWidget {
  const NotificationsListView({super.key});

  @override
  State<NotificationsListView> createState() => _NotificationsListViewState();
}

class _NotificationsListViewState extends State<NotificationsListView> {
  final _notificationController = Get.find<NotificationController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications'.tr,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
                // Refresh Notifications Button
                Obx(() => IconButton(
                      icon: _notificationController.isLoadingList.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh_rounded, size: 20),
                      onPressed: _notificationController.isLoadingList.value
                          ? null
                          : _notificationController.fetchNotifications,
                    )),
              ],
            ),
          ),
          const Divider(height: 1),
          // Body
          Expanded(child: Obx(() => _buildBody())),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_notificationController.isLoadingList.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_notificationController.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            Text(
              _notificationController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _notificationController.fetchNotifications,
              child: Text('Retry'.tr),
            ),
          ],
        ),
      );
    }

    if (_notificationController.notificationsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('No notifications yet'.tr,
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    final grouped = _notificationController.groupedNotifications;

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        children: grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Label
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              //  Cards
              ...entry.value.map((n) => _NotificationCard(notificationModel: n)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// Card Widget
class _NotificationCard extends StatelessWidget {
  final NotificationModel notificationModel;

  _NotificationCard({required this.notificationModel});

  final _notificationController = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // the notification
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon for the notification
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFCC80), width: 1.5),
            ),
            child: const Icon(Icons.campaign_rounded,
                color: Color(0xFFE65100), size: 22),
          ),
          const SizedBox(width: 12),
          // Content of the notification
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //head of the notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //title of the notification
                    Text(
                      notificationModel.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    //to view details of the notification
                    GestureDetector(
                      onTap: ()  {
                        _showDetailsDialog(context, notificationModel);
                      },
                      child: Text(
                        'View Details'.tr,
                        style: const TextStyle(
                          color: Color(0xFF1A3A6B),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                //body of the notification
                Text(
                  notificationModel.body,
                  style: const TextStyle(
                      color: Color(0xFF6B7280), fontSize: 12.5),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                //more details of the notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _timeAgo(notificationModel.createdAt),
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF9CA3AF)),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: notificationModel.isRead
                            ? Colors.grey.shade300
                            : const Color(0xFF00897B),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} ${"mins ago".tr}';
    if (diff.inHours < 24) return '${diff.inHours} ${"hours ago".tr}';
    return '${diff.inDays} ${"days ago".tr}';
  }


  void _showDetailsDialog(BuildContext context, NotificationModel n) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A3A6B).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.campaign_rounded, color: Color(0xFF1A3A6B)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Notification Details".tr,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
              const Divider(height: 30),

              // Content Title
              Text(
                n.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)),
              ),
              const SizedBox(height: 10),

              // Badges (Type and Grade)
              Row(
                children: [
                  _buildMiniTag("${"Target:".tr} ${n.type.toUpperCase()}", Colors.indigo.shade50, Colors.indigo),
                  const SizedBox(width: 8),
                  _buildMiniTag("${"Grade:".tr} ${n.grade}", Colors.teal.shade50, Colors.teal),
                ],
              ),
              const SizedBox(height: 20),
              // Message Body
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  n.body,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563), height: 1.5),
                ),
              ),
              const SizedBox(height: 20),
              // Date of the notification
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    "${"Sent on:".tr} ${_formatFullDate(n.createdAt)}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Actions
              Row(
                children: [
                  //to close the notification
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Close".tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  //show "Mark as Read" button just if was the notification not read
                  if (!n.isRead)
                    //Mark as Read Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _notificationController.markNotificationsAsRead(n.id);
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A3A6B),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("Mark as Read".tr, style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniTag(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        text,
        style: TextStyle(color: textCol, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}";
  }
}
