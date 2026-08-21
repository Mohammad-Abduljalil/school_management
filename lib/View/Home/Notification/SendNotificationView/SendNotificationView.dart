import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Custom/MyCustomTextFieldWithLines.dart';

import '../../../../Controller/HomeController/NotificationController/NotificationController.dart';

class SendNotificationView extends StatelessWidget {
  SendNotificationView({super.key});

  final _notificationController = Get.find<NotificationController>();

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
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _notificationController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Head
            Text(
              'Send Notification'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 20),

            // Recipient Tabs
            _RecipientTabsWidget(),
            const SizedBox(height: 20),

            // Grade Dropdown
            _fieldLabel('GRADE / CLASS'.tr),
            const SizedBox(height: 8),
            _GradeDropdownWidget(),
            const SizedBox(height: 20),

            // Subject
            _fieldLabel('SUBJECT'.tr),
            const SizedBox(height: 8),
            //TextField for subject
            MyCustomTextFieldWithLines(
              textController: _notificationController.subjectController,
              hintText: 'Write the main subject'.tr,
            ),
            const SizedBox(height: 20),

            // Message Body
            _fieldLabel('MESSAGE BODY'.tr),
            const SizedBox(height: 8),
            //TextField for Message Body
            MyCustomTextFieldWithLines(
              textController: _notificationController.bodyController,
              hintText: 'What is the content about this message...'.tr,
              maxLines: 4,
            ),

            const Spacer(),

            // Action Buttons
            Row(
              children: [
                //Cancel Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _notificationController.subjectController.clear();
                      _notificationController.bodyController.clear();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Cancel'.tr,
                        style: const TextStyle(color: Color(0xFF374151))),
                  ),
                ),
                const SizedBox(width: 12),
                //Send Notification Button
                Expanded(
                  child: Obx(() =>
                      ElevatedButton(
                        onPressed: _notificationController.isSending.value
                            ? null
                            : _notificationController.sendNotification,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A3A6B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: _notificationController.isSending.value
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                            : Text('Send Notification'.tr,
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) =>
      Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6B7280),
          letterSpacing: 0.8,
        ),
      );


}
// Recipient Tabs
class _RecipientTabsWidget extends StatelessWidget {
  _RecipientTabsWidget();

  final _notificationController = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF00897B),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.campaign_rounded,
              color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
        // recipients
        Obx(() => Row(
              children: _notificationController.recipients.map((tab) {
                final isSelected = _notificationController.selectedRecipient.value == tab;
                return GestureDetector(
                  onTap: () => _notificationController.setRecipient(tab),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE8F0FE)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tab,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF1A3A6B)
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }
}

// Grade Dropdown
class _GradeDropdownWidget extends StatelessWidget {
  _GradeDropdownWidget();

  final _notificationController = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _notificationController.selectedGrade.value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              style: const TextStyle(
                  color: Color(0xFF1A1A2E), fontSize: 13.5),
              items: _notificationController.grades
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (value) {
                if (value != null) _notificationController.setGrade(value);
              },
            ),
          ),
        ));
  }
}
