import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Custom/MyCustomTextFields.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/Controller/HomeController/MarksController/MarksController.dart';
import 'package:school_management/Model/HomeModel/AcademicManagementModel/StageModel.dart';
import 'package:school_management/Model/HomeModel/SubjectModel.dart';
import 'package:school_management/View/Home/Marks/MarksDataSource.dart';

class MarksScreen extends StatelessWidget {
  final MarksController _marksController = Get.put(MarksController());

  MarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.pageContentColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: true,
            physics: const BouncingScrollPhysics(),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopFilters(context),
                const SizedBox(height: 20),
                _buildSubjectsGrid(context),
                const SizedBox(height: 20),
                _buildSearchBar(context),
                const SizedBox(height: 20),
                _buildMarksTable(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMarksTable(BuildContext context) {
    return Obx(() {
      if (_marksController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_marksController.displayedMarks.isEmpty) {
        return Container(
          height: 200,
          alignment: Alignment.center,
          child: const Text("No Marks Available"),
        );
      }

      final MarksDataSource marksDataSource = MarksDataSource(
        marks: _marksController.displayedMarks,
      );

      return Container(
        height: 600,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: SfDataGrid(
          source: marksDataSource,
          shrinkWrapRows: false,
          columnWidthMode: ColumnWidthMode.fill,
          gridLinesVisibility: GridLinesVisibility.none,
          headerGridLinesVisibility: GridLinesVisibility.none,
          headerRowHeight: 50,
          isScrollbarAlwaysShown: true,
          columns: [
            _buildGridColumn("student", "Student Name", context),
            _buildGridColumn("subject", "Subject", context),
            _buildGridColumn("type", "Test Type", context),
            _buildGridColumn("teacher", "Teacher", context),
            _buildGridColumn("score", "Score", context),
          ],
        ),
      );
    });
  }

  GridColumn _buildGridColumn(String name, String title, BuildContext context) {
    return GridColumn(
      columnName: name,
      label: Container(
        color: MyColors.backgroundColor,
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTopFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
      child: Obx(() => Row(
            children: [
              // Grade Filter
              _buildDropdown<StageModel>(
                context,
                "Grade/Stage",
                _marksController.selectedGrade.value,
                _marksController.grades,
                (g) => "Stage ${g.stage_number}",
                (val) => _marksController.onGradeSelected(val),
                hint: "All Grades",
              ),
              const SizedBox(width: 20),

              // Subject Filter
              _buildDropdown<SubjectModel>(
                context,
                "Subject",
                _marksController.selectedSubject.value,
                _marksController.subjectsList,
                (s) => s.name,
                (val) => _marksController.onSubjectSelected(val),
                hint: _marksController.selectedGrade.value == null ? "Select Grade first" : "All Subjects",
                enabled: _marksController.selectedGrade.value != null,
              ),
              const Spacer(),
              _buildFilterButton(),
            ],
          )),
    );
  }

  Widget _buildSubjectsGrid(BuildContext context) {
    return Obx(() {
      if (_marksController.isLoadingFilters.value) {
        return Center(child: LinearProgressIndicator(color: MyColors.backgroundColor));
      }

      if (_marksController.subjectsList.isEmpty) {
        return const SizedBox.shrink();
      }

      return Wrap(
        spacing: 15,
        runSpacing: 15,
        children: _marksController.subjectsList.asMap().entries.map((entry) {
          int idx = entry.key;
          var item = entry.value;
          bool isSelected = _marksController.selectedSubject.value?.id == item.id;

          return GestureDetector(
            onTap: () => _marksController.onSubjectSelected(item),
            child: Container(
              width: 220,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFC4C4C4) : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? const Color(0xFF00A79D) : Colors.transparent, width: 2),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: const Color(0xFF00A79D),
                    child: Text("${idx + 1}", style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: MyColors.primaryText),
                            overflow: TextOverflow.ellipsis),
                        Row(
                          children: [
                            Icon(Icons.circle, size: 8, color: MyColors.backgroundColor),
                            const SizedBox(width: 5),
                            const Text("Active", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
            child: MyCustomTextField(
              controller: _marksController.searchController,
              hintText: "Search by student name...",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              onChanged: (value) {
                _marksController.searchSubjectMarks(value);
              },
            ),
          ),
        ),
        const SizedBox(width: 15),
        _buildFilterButton(),
      ],
    );
  }

  Widget _buildDropdown<T>(BuildContext context, String label, T? value, List<T> items, String Function(T) itemLabel,
      ValueChanged<T?> onChanged,
      {String hint = "Select", bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Container(
          width: 180,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: enabled
                  ? (Get.isDarkMode ? Colors.white10 : const Color(0xFFF0F2F5))
                  : (Get.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade100),
              borderRadius: BorderRadius.circular(5)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              dropdownColor: Theme.of(context).cardColor,
              value: value,
              hint: Text(hint, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              items: items
                  .map((item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(itemLabel(item), style: TextStyle(fontSize: 13, color: MyColors.primaryText))))
                  .toList(),
              onChanged: enabled ? onChanged : null,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFilterButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: MyColors.backgroundColor, borderRadius: BorderRadius.circular(8)),
      child: const Row(
        children: [
          Icon(Icons.filter_alt_outlined, color: Colors.white, size: 18),
          SizedBox(width: 5),
          Text("Filter", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
