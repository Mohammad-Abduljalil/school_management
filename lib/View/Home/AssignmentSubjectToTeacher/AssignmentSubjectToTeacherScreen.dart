import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Controller/HomeController/AssignmentSubjectToTeacherController/AssignmentSubjectToTeacherController.dart';
import 'package:school_management/Custom/MyColors.dart';

import '../../../Model/HomeModel/AcademicManagementModel/StageModel.dart';
import '../../../Model/HomeModel/SectionModel.dart';
import '../../../Model/HomeModel/SubjectModel.dart';
import '../../../Model/HomeModel/TacherModel/TeacherModel.dart';

class AssignmentSubjectToTeacherScreen extends StatelessWidget {
  final controller = Get.put(AssignmentSubjectToTeacherController());

  AssignmentSubjectToTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Teacher Assignments".tr,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: MyColors.backgroundColor,
        elevation: 0,
      ),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator(color: MyColors.backgroundColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildModeSelector(),
                      const SizedBox(height: 30),
                      Obx(() => _buildStepHeader("1", controller.isSubjectMode.value ? "Select Subject" : "Select Class/Grade")),
                      const SizedBox(height: 15),
                      Obx(() => controller.isSubjectMode.value ? _buildSubjectDropdown(context) : _buildClassSectionGroup(context)),
                      const SizedBox(height: 30),
                      _buildStepHeader("2", "Select Teacher"),
                      const SizedBox(height: 15),
                      _buildTeacherDropdown(context),
                      const SizedBox(height: 40),
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ),
            )),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.white10 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildModeButton("Subject to Teacher", true),
          _buildModeButton("Teacher to Class", false),
        ],
      ),
    );
  }

  Widget _buildModeButton(String title, bool isSubject) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.isSubjectMode.value = isSubject,
        child: Obx(() {
          bool selected = controller.isSubjectMode.value == isSubject;
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? MyColors.backgroundColor : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              title.tr,
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepHeader(String step, String title) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: MyColors.backgroundColor,
          child: Text(step, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
        const SizedBox(width: 10),
        Text(title.tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MyColors.primaryText)),
      ],
    );
  }

  Widget _buildSubjectDropdown(BuildContext context) {
    return _buildDropdownContainer(
      context: context,
      child: DropdownButton<SubjectModel>(
        isExpanded: true,
        dropdownColor: Theme.of(context).cardColor,
        value: controller.selectedSubject.value,
        hint: const Text("Choose a subject...", style: TextStyle(color: Colors.grey)),
        items: controller.subjects
            .map((sub) => DropdownMenuItem<SubjectModel>(
                  value: sub,
                  child: Text(sub.name, style: TextStyle(color: MyColors.primaryText)),
                ))
            .toList(),
        onChanged: (val) => controller.selectedSubject.value = val,
      ),
    );
  }

  Widget _buildClassSectionGroup(BuildContext context) {
    return Column(
      children: [
        _buildClassDropdown(context),
        Obx(() {
          if (controller.selectedClass.value != null && controller.selectedClass.value!.sections.isNotEmpty) {
            return Column(
              children: [
                const SizedBox(height: 15),
                _buildSectionDropdown(context),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildClassDropdown(BuildContext context) {
    return _buildDropdownContainer(
      context: context,
      child: DropdownButton<StageModel>(
        isExpanded: true,
        dropdownColor: Theme.of(context).cardColor,
        value: controller.selectedClass.value,
        hint: const Text("Choose a class/grade...", style: TextStyle(color: Colors.grey)),
        items: controller.classes
            .map((cls) => DropdownMenuItem<StageModel>(
                  value: cls,
                  child: Text("Stage ${cls.stage_number}", style: TextStyle(color: MyColors.primaryText)),
                ))
            .toList(),
        onChanged: (val) => controller.onClassSelected(val),
      ),
    );
  }

  Widget _buildSectionDropdown(BuildContext context) {
    return _buildDropdownContainer(
      context: context,
      child: DropdownButton<SectionModel>(
        isExpanded: true,
        dropdownColor: Theme.of(context).cardColor,
        value: controller.selectedSection.value,
        hint: const Text("Choose a section...", style: TextStyle(color: Colors.grey)),
        items: controller.selectedClass.value?.sections
            .map((sec) => DropdownMenuItem<SectionModel>(
                  value: sec,
                  child: Text(sec.name, style: TextStyle(color: MyColors.primaryText)),
                ))
            .toList() ?? [],
        onChanged: (val) => controller.selectedSection.value = val,
      ),
    );
  }

  Widget _buildTeacherDropdown(BuildContext context) {
    return _buildDropdownContainer(
      context: context,
      child: DropdownButton<TeacherModel>(
        isExpanded: true,
        dropdownColor: Theme.of(context).cardColor,
        value: controller.selectedTeacher.value,
        hint: const Text("Choose a teacher...", style: TextStyle(color: Colors.grey)),
        items: controller.teachers
            .map((teacher) => DropdownMenuItem<TeacherModel>(
                  value: teacher,
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline, size: 20, color: Color(0xFF00A79D)),
                      const SizedBox(width: 10),
                      Text(teacher.full_name ?? "Unknown", style: TextStyle(color: MyColors.primaryText)),
                    ],
                  ),
                ))
            .toList(),
        onChanged: (val) => controller.selectedTeacher.value = val,
      ),
    );
  }

  Widget _buildDropdownContainer({required BuildContext context, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: DropdownButtonHideUnderline(child: child),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (controller.isSubjectMode.value) {
            controller.assignTeacherToSubject();
          } else {
            controller.assignTeacherToClass();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A99D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text("Save Assignment".tr, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
