import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Custom/MyCustomConfirmDialog.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import '../../../Controller/HomeController/AcademicManagementController/AcademicManagementController.dart';
import '../../../Model/HomeModel/AcademicManagementModel/StageModel.dart';

class AcademicManagementScreen extends StatefulWidget {
  @override
  _AcademicManagementScreenState createState() => _AcademicManagementScreenState();
}

class _AcademicManagementScreenState extends State<AcademicManagementScreen> {
  final controller = Get.put(AcademicManagementController());

  int currentStep = 0;
  String title = "Academic Management";
  final TextEditingController inputController = TextEditingController();

  void navigateTo(int step, String newTitle) {
    setState(() {
      currentStep = step;
      title = newTitle;
      inputController.clear();
      // Reset selected variables to match new names in the Controller
      controller.selectedStageForSection.value = null;
      controller.selectedStageForSubject.value = null;
      controller.selectedStageForDisplay.value = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title.tr, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: MyColors.backgroundColor,
        leading: currentStep != 0
            ? IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => navigateTo(0, "Academic Management"))
            : null,
        elevation: 0,
      ),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator(color: MyColors.backgroundColor))
          : _buildBody()),
    );
  }

  Widget _buildBody() {
    switch (currentStep) {
      case 1: return _buildAddGradeView();
      case 2: return _buildShowGradesView();
      case 3: return _buildAddSectionView();
      case 4: return _buildShowSectionsView();
      case 5: return _buildAddSubjectView();
      case 6: return _buildShowSubjectsView();
      default: return _buildMainDashboard();
    }
  }

  Widget _buildMainDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryHeader("MANAGEMENT".tr),
                const SizedBox(height: 20),
                _buildMenuCard("Add Grade".tr, Icons.add_box_outlined, () => navigateTo(1, "Add New Grade".tr)),
                _buildMenuCard("Add Section".tr, Icons.person_add_alt_1_outlined, () => navigateTo(3, "Add Section".tr)),
                _buildMenuCard("Add Subject".tr, Icons.menu_book_outlined, () => navigateTo(5, "Add Subject".tr)),
              ],
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryHeader("REPORTING".tr),
                const SizedBox(height: 20),
                _buildMenuCard("Display Grades".tr, Icons.format_list_bulleted_rounded, () => navigateTo(2, "Current Grades".tr)),
                _buildMenuCard("Display Sections".tr, Icons.group_outlined, () => navigateTo(4, "Current Section".tr)),
                _buildMenuCard("Display Subjects".tr, Icons.inventory_2_outlined, () => navigateTo(6, "Current Subjects".tr)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Row(
      children: [
        Container(width: 25, height: 3, color: const Color(0xFF00A79D)),
        const SizedBox(width: 10),
        Text(title.tr, style: TextStyle(color: MyColors.primaryText, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.2)),
      ],
    );
  }

  Widget _buildMenuCard(String label, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: const Color(0xFF00A79D)),
              const SizedBox(height: 12),
              Text(label.tr, style: TextStyle(fontWeight: FontWeight.w600, color: MyColors.primaryText, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddGradeView() {
    return _buildActionTemplate(
      hint: "Enter number of the grade(Ex:9)",
      onBtnPressed: () {
        int? val = int.tryParse(inputController.text);
        if (val != null) {
          controller.createStudyStage(val);
        } else {
          SnackbarHelper.showError(title: "Error".tr, message: "Please enter a valid number".tr);
        }
      },
      child: _buildDisplayList("Current Grade".tr, controller.stages, Icons.school),
    );
  }

  Widget _buildShowGradesView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildDisplayList("List of All Grades".tr, controller.stages, Icons.school),
    );
  }

  Widget _buildAddSectionView() {
    return _buildActionTemplate(
      hint: "Name of Section(A,B,C,...)",
      showGradePicker: true,
      selectedStage: controller.selectedStageForSection,
      onStageChanged: (val) => controller.selectedStageForSection.value = val,
      onBtnPressed: () {
        int? val=int.tryParse(inputController.text);
        if (val != null) {
          controller.createSection(val);
        } else {
          SnackbarHelper.showError(title: "Error".tr, message: "Please enter a valid number".tr);
        }
      } ,
      child: Obx(() => _buildDisplayList(
          "Sections for selected stage".tr,
          controller.getSectionsForSelectedStage(controller.selectedStageForSection.value),
          Icons.layers)),
    );
  }

  Widget _buildShowSectionsView() {
    return _buildActionTemplate(
      showBtn: false,
      showGradePicker: true,
      selectedStage: controller.selectedStageForDisplay,
      onStageChanged: (val) => controller.selectedStageForDisplay.value = val,
      child: Obx(() {
        final stage = controller.selectedStageForDisplay.value;
        if (stage == null) return Center(child: Text("Please select a stage".tr));
        return _buildDisplayList(
            "${"Sections for Stage".tr} ${stage.stage_number}",
            controller.getSectionsForSelectedStage(stage),
            Icons.groups);
      }),
    );
  }

  Widget _buildAddSubjectView() {
    return _buildActionTemplate(
      hint: "Name of the Subject(Ex:Math,Arabic,...)",
      showGradePicker: true,
      selectedStage: controller.selectedStageForSubject,
      onStageChanged: (val) => controller.selectedStageForSubject.value = val,
      onBtnPressed: () => controller.addNewSubject(inputController.text),
      child: _buildDisplayList("Subjects of selected grade".tr, controller.subjects, Icons.book),
    );
  }

  Widget _buildShowSubjectsView() {
    return _buildActionTemplate(
      showBtn: false,
      showGradePicker: true,
      selectedStage: controller.selectedStageForDisplay,
      onStageChanged: (val) {
        controller.selectedStageForDisplay.value = val;
        controller.fetchSubjectsByGrade(val!.id);
      },
      child: _buildDisplayList("Subjects for this grade".tr, controller.subjects, Icons.menu_book),
    );
  }

  //Helpers

  Widget _buildActionTemplate({
    String? hint,
    required Widget child,
    VoidCallback? onBtnPressed,
    bool showGradePicker = false,
    bool showBtn = true,
    Rxn<StageModel>? selectedStage,
    Function(StageModel?)? onStageChanged,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (showGradePicker && selectedStage != null) ...[
            _buildGradeDropdown(selectedStage, onStageChanged!),
            const SizedBox(height: 15),
          ],
          if (showBtn) _buildInputArea(inputController, hint!, onBtnPressed!),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildGradeDropdown(Rxn<StageModel> selected, Function(StageModel?) onChanged) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<StageModel>(
          isExpanded: true,
          hint: Text("Select Stage".tr),
          value: selected.value,
          items: controller.stages.map((g) => DropdownMenuItem(
              value: g,
              child: Text("${"Stage".tr} ${g.stage_number}")
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    ));
  }

  Widget _buildInputArea(TextEditingController textController, String hint, VoidCallback onAdd) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: hint.tr, filled: true, fillColor: Theme.of(context).cardColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: onAdd,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A79D), padding: const EdgeInsets.all(15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: const Icon(Icons.send, color: Colors.white),
        )
      ],
    );
  }

  Widget _buildDisplayList(String title, List items, IconData icon) {
    return Obx((){
      if(controller.isLoading.value){
        return Center(child: CircularProgressIndicator(color: MyColors.backgroundColor));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.tr, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items.map((item) {
              String label = "";
              int? stageId;

              if (item is StageModel) {
                label = "${"Stage".tr} ${item.stage_number}";
                stageId = item.id;
              } else if (item is int) {
                label = "${"Section".tr} $item";
              } else {
                label = item.name.toString();
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: MyColors.backgroundColor.withOpacity(0.3))
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 14, color: const Color(0xFF00A79D)),
                    const SizedBox(width: 8),
                    Text(label, style: TextStyle(color: MyColors.primaryText, fontWeight: FontWeight.w600)),

                    // Show delete button only if the item is StageModel
                    if (item is StageModel) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          if(await MyCustomConfirmDialog().isConfermedDialog(context, "Are you sure?".tr)){
                            controller.deleteStudyStage(stageId!);
                          }
                        },
                        child: const Icon(Icons.cancel, size: 18, color: Colors.redAccent),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  }