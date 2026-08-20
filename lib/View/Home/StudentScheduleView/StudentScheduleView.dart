import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Model/HomeModel/StudentScheduleModel/ScheduleStageModel.dart';
import 'package:school_management/Model/HomeModel/StudentScheduleModel/ScheduleSectionModel.dart';
import 'package:school_management/Model/HomeModel/StudentScheduleModel/ScheduleSlotModel.dart';
import 'package:school_management/Model/HomeModel/SubjectModel.dart';
import 'package:school_management/Model/HomeModel/StudentScheduleModel/TeacherModel.dart';
import 'package:school_management/Model/HomeModel/StudentScheduleModel/PeriodTemplateModel.dart';
import 'package:school_management/Custom/MyColors.dart';
import '../../../Controller/HomeController/StudentScheduleController/StudentScheduleController.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScheduleController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoadingGrades.value) {
          return Center(
            child: CircularProgressIndicator(color: MyColors.backgroundColor),
          );
        }

        return Column(
          children: [
            _GradeSectionBar(controller: controller),

            Expanded(
              child: Obx(() {
                if (controller.hasError.value) {
                   return _ErrorView(controller: controller);
                }

                if (controller.selectedGrade.value == null) {
                  return const _PlaceholderView(
                    icon: Icons.school_outlined,
                    message: 'Select Stage First',
                  );
                }

                if (controller.selectedSection.value == null) {
                  return const _PlaceholderView(
                    icon: Icons.groups_outlined,
                    message: 'Select section to show the schedule',
                  );
                }

                if (controller.isLoadingSchedule.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1A3A5C)),
                  );
                }

                if (controller.schedule.value == null) {
                  return _CreateScheduleView(controller: controller);
                }

                return _ScheduleGridView(controller: controller);
              }),
            ),
          ],
        );
      }),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final ScheduleController controller;
  const _ErrorView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          const Text('Failed to load data. Please try again.'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
               if (controller.selectedSection.value != null) {
                 controller.fetchSchedule();
               } else {
                 controller.fetchGradesAndPeriods();
               }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.backgroundColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

class _GradeSectionBar extends StatelessWidget {
  final ScheduleController controller;
  const _GradeSectionBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => _StyledDropdown<ScheduleStageModel>(
              label: 'Grade/Stage',
              hint: 'Select Stage',
              value: controller.selectedGrade.value,
              items: controller.grades,
              itemLabel: (g) => 'Stage ${g.stageNumber}',
              onChanged: (grade) {
                if (grade != null) controller.onGradeSelected(grade);
              },
            )),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Obx(() => _StyledDropdown<ScheduleSectionModel>(
              label: 'Section',
              hint: controller.selectedGrade.value == null
                  ? 'Select Stage first'
                  : 'Select Section',
              value: controller.selectedSection.value,
              items: controller.sections,
              itemLabel: (s) => s.sectionName,
              enabled: controller.selectedGrade.value != null,
              onChanged: (section) {
                if (section != null) controller.onSectionSelected(section);
              },
            )),
          ),

          const SizedBox(width: 12),

          Obx(() => controller.schedule.value != null
              ? _FilterButton(controller: controller)
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}

class _StyledDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  const _StyledDropdown({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: enabled ? Theme.of(context).cardColor : (Get.isDarkMode ? Colors.white10 : const Color(0xFFF9FAFB)),
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              dropdownColor: Theme.of(context).cardColor,
              value: value,
              hint: Text(
                hint,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, size: 20),
              style: TextStyle(
                fontSize: 14,
                color: MyColors.primaryText,
                fontWeight: FontWeight.w500,
              ),
              items: enabled
                  ? items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item), style: TextStyle(color: MyColors.primaryText)),
                );
              }).toList()
                  : [],
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final ScheduleController controller;
  const _FilterButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subject',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        ElevatedButton.icon(
          onPressed: () => _showFilterSheet(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.backgroundColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.filter_list, size: 18),
          label: Obx(() => Text(
            controller.selectedSubjectFilter.value == 'All Subject'
                ? 'Filter'
                : controller.selectedSubjectFilter.value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          )),
        ),
      ],
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _FilterBottomSheet(controller: controller),
    );
  }
}

class _FilterBottomSheet extends StatelessWidget {
  final ScheduleController controller;
  const _FilterBottomSheet({required this.controller});

  @override
  @override
  Widget build(BuildContext context) {
    final subjects = controller.getSubjectsList();

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Subject',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: MyColors.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: subjects.map((subject) {
              return Obx(() {
                final isSelected = controller.selectedSubjectFilter.value == subject;
                return GestureDetector(
                  onTap: () {
                    controller.setFilter(subject);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MyColors.backgroundColor
                          : (Get.isDarkMode ? Colors.white10 : const Color(0xFFF3F4F6)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      subject,
                      style: TextStyle(
                        color: isSelected ? Colors.white : MyColors.primaryText.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              });
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _PlaceholderView extends StatelessWidget {
  final IconData icon;
  final String message;
  const _PlaceholderView({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: const Color(0xFFD1D5DB)),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateScheduleView extends StatelessWidget {
  final ScheduleController controller;
  const _CreateScheduleView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final grade = controller.selectedGrade.value!;
    final section = controller.selectedSection.value!;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: MyColors.backgroundColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 30,
                color: MyColors.backgroundColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Schedule Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Stage ${grade.stageNumber}  •  ${section.sectionName}',
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 24),
            
            // Academic Year Input
            TextField(
              controller: controller.academicYearController,
              decoration: InputDecoration(
                labelText: 'Academic Year',
                hintText: 'e.g. 2024-2025',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.event),
              ),
            ),
            const SizedBox(height: 16),
            
            // Semester Input
            Obx(() => Row(
              children: [
                const Text('Semester: ', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                Radio<String>(
                  value: "1",
                  groupValue: controller.semester.value,
                  onChanged: (v) => controller.semester.value = v!,
                ),
                const Text('1st'),
                const SizedBox(width: 12),
                Radio<String>(
                  value: "2",
                  groupValue: controller.semester.value,
                  onChanged: (v) => controller.semester.value = v!,
                ),
                const Text('2nd'),
              ],
            )),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.createSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.backgroundColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Create Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleGridView extends StatelessWidget {
  final ScheduleController controller;
  const _ScheduleGridView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final grade = controller.selectedGrade.value!;
    final section = controller.selectedSection.value!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              const Icon(Icons.school, size: 16, color: Color(0xFF6B7280)),
              const SizedBox(width: 6),
              Text(
                'Stage ${grade.stageNumber}  •  ${section.sectionName}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const Spacer(),

              OutlinedButton.icon(
                onPressed: controller.discardChanges,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626),
                  side: const BorderSide(color: Color(0xFFDC2626)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Reload', style: TextStyle(fontSize: 13)),
              ),

              const SizedBox(width: 10),

              Obx(() => ElevatedButton.icon(
                onPressed: controller.isSaving.value ? null : controller.saveSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: controller.isSaving.value
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save_outlined, size: 16),
                label: Text(controller.isSaving.value ? 'Saving...' : 'Sync with Server', style: const TextStyle(fontSize: 13)),
              )),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3)),
                  ],
                ),
                child: Column(
                  children: [
                    _DayHeadersRow(days: controller.uiDays),
                    const SizedBox(height: 16),

                    ...controller.periodTemplates.map((pTemplate) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: controller.uiDays.map((day) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Obx(() {
                                final slot = controller.getSlot(day, pTemplate.name);

                                final filter = controller.selectedSubjectFilter.value;
                                final isFiltered = filter != 'All Subject' &&
                                    slot != null &&
                                    slot.materialName != filter;

                                if (slot != null && slot.materialName.isNotEmpty) {
                                  return Opacity(
                                    opacity: isFiltered ? 0.25 : 1.0,
                                    child: _PeriodCard(
                                      periodTemplate: pTemplate,
                                      slot: slot,
                                      onEdit: () => _showEditDialog(context, controller, day, pTemplate),
                                    ),
                                  );
                                } else {
                                  return _EmptyPeriodCard(
                                    onAdd: () => _showEditDialog(context, controller, day, pTemplate),
                                  );
                                }
                              }),
                            );
                          }).toList(),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEditDialog(
      BuildContext context,
      ScheduleController controller,
      String day,
      PeriodTemplateModel template,
      ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AddPeriodDialog(
        day: day,
        template: template,
        controller: controller,
      ),
    );
  }
}

class _DayHeadersRow extends StatelessWidget {
  final List<String> days;
  const _DayHeadersRow({required this.days});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: days.map((day) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: SizedBox(
          width: 190,
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: MyColors.primaryText,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      )).toList(),
    );
  }
}

class _PeriodCard extends StatelessWidget {
  final PeriodTemplateModel periodTemplate;
  final ScheduleSlotModel slot;
  final VoidCallback onEdit;

  const _PeriodCard({
    required this.periodTemplate,
    required this.slot,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(color: Color(0xFF00B09B), shape: BoxShape.circle),
                  child: Center(child: Text(periodTemplate.name.split(' ').last, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(slot.materialName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text("${slot.startTime} - ${slot.endTime}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
            child: Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text(slot.teacherName, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),

          const SizedBox(height: 10),

          GestureDetector(
            onTap: onEdit,
            child: Container(
              margin: const EdgeInsets.fromLTRB(8, 0, 8, 10),
              height: 36,
              decoration: BoxDecoration(color: MyColors.backgroundColor, borderRadius: BorderRadius.circular(8)),
              child: const Center(child: Icon(Icons.edit_outlined, color: Colors.white, size: 18)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPeriodCard extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyPeriodCard({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        width: 190,
        height: 116,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.white.withOpacity(0.05) : const Color(0xFF3D3D3D),
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: Get.isDarkMode ? Colors.grey : Colors.white54, size: 28),
            const SizedBox(height: 8),
            Text('Add Subject', style: TextStyle(color: Get.isDarkMode ? Colors.grey : Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _AddPeriodDialog extends StatefulWidget {
  final String day;
  final PeriodTemplateModel template;
  final ScheduleController controller;

  const _AddPeriodDialog({
    required this.day,
    required this.template,
    required this.controller,
  });

  @override
  State<_AddPeriodDialog> createState() => _AddPeriodDialogState();
}

class _AddPeriodDialogState extends State<_AddPeriodDialog> {
  int _step = 0;
  SubjectModel? _selectedSubject;
  TeacherModel? _selectedTeacher;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    widget.controller.fetchSubjects();
  }

  Future<void> _onNextStep() async {
    if (_selectedSubject == null) return;
    setState(() => _step = 1);
    await widget.controller.fetchTeachersBySubject(_selectedSubject!);
  }

  Future<void> _onConfirm() async {
    if (_selectedTeacher == null || _selectedSubject == null) return;
    setState(() => _saving = true);
    await widget.controller.updatePeriod(
      day: widget.day,
      periodName: widget.template.name,
      materialId: _selectedSubject!.id,
      materialName: _selectedSubject!.name,
      teacherId: _selectedTeacher!.teacher_id,
      teacherName: _selectedTeacher!.full_name,
      periodId: widget.template.id,
      startTime: widget.template.startTime,
      endTime: widget.template.endTime,
    );
    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: MyColors.backgroundColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.add, color: MyColors.backgroundColor, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Assign Subject', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                    Text('${widget.day}  •  ${widget.template.name}', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                _StepIndicator(number: 1, label: 'Subject', isActive: _step == 0, isDone: _step > 0),
                Expanded(child: Container(height: 2, color: _step > 0 ? MyColors.backgroundColor : const Color(0xFFE5E7EB))),
                _StepIndicator(number: 2, label: 'Teacher', isActive: _step == 1, isDone: false),
              ],
            ),

            const SizedBox(height: 20),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _step == 0
                  ? _SubjectStep(
                key: const ValueKey('subject'),
                controller: widget.controller,
                selected: _selectedSubject,
                onSelect: (s) => setState(() => _selectedSubject = s),
              )
                  : _TeacherStep(
                key: const ValueKey('teacher'),
                controller: widget.controller,
                subjectName: _selectedSubject!.name,
                selected: _selectedTeacher,
                onSelect: (t) => setState(() => _selectedTeacher = t),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving ? null : () {
                      if (_step == 0) Navigator.of(context).pop();
                      else setState(() { _step = 0; _selectedTeacher = null; });
                    },
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Text(_step == 0 ? 'Cancel' : 'Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saving ? null : (_step == 0 ? (_selectedSubject != null ? _onNextStep : null) : (_selectedTeacher != null ? _onConfirm : null)),
                    style: ElevatedButton.styleFrom(backgroundColor: MyColors.backgroundColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(_step == 0 ? 'Next' : 'Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isDone;

  const _StepIndicator({required this.number, required this.label, required this.isActive, required this.isDone});

  @override
  Widget build(BuildContext context) {
    final color = (isActive || isDone) ? MyColors.backgroundColor : const Color(0xFFD1D5DB);
    return Column(
      children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(color: (isActive || isDone) ? MyColors.backgroundColor : Colors.white, shape: BoxShape.circle, border: Border.all(color: color, width: 2)),
          child: Center(child: isDone ? const Icon(Icons.check, color: Colors.white, size: 14) : Text('$number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isActive ? Colors.white : const Color(0xFF9CA3AF)))),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
      ],
    );
  }
}

class _SubjectStep extends StatelessWidget {
  final ScheduleController controller;
  final SubjectModel? selected;
  final ValueChanged<SubjectModel> onSelect;
  const _SubjectStep({super.key, required this.controller, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingSubjects.value) return SizedBox(height: 120, child: Center(child: CircularProgressIndicator(color: MyColors.backgroundColor)));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Subject', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: controller.availableSubjects.map((subject) {
              final isSelected = selected?.id == subject.id;
              return GestureDetector(
                onTap: () => onSelect(subject),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(color: isSelected ? MyColors.backgroundColor : const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(10), border: Border.all(color: isSelected ? MyColors.backgroundColor : const Color(0xFFE5E7EB))),
                  child: Text(subject.name, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF374151), fontSize: 14)),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}

class _TeacherStep extends StatelessWidget {
  final ScheduleController controller;
  final String subjectName;
  final TeacherModel? selected;
  final ValueChanged<TeacherModel> onSelect;
  const _TeacherStep({super.key, required this.controller, required this.subjectName, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingTeachers.value) return SizedBox(height: 120, child: Center(child: CircularProgressIndicator(color: MyColors.backgroundColor)));
      if (controller.availableTeachers.isEmpty) return const SizedBox(height: 80, child: Center(child: Text('No teachers available for this subject')));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Select Teacher', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFF00B09B).withOpacity(0.12), borderRadius: BorderRadius.circular(6)), child: Text(subjectName, style: const TextStyle(fontSize: 11, color: Color(0xFF00B09B), fontWeight: FontWeight.w600))),
            ],
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: controller.availableTeachers.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final teacher = controller.availableTeachers[index];
                final isSelected = selected?.teacher_id == teacher.teacher_id;
                return ListTile(
                  leading: CircleAvatar(radius: 18, backgroundColor: const Color(0xFFE5E7EB), child: const Icon(Icons.person, size: 18, color: Colors.grey)),
                  title: Text(teacher.full_name, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
                  trailing: isSelected ? Icon(Icons.check_circle, color: MyColors.backgroundColor, size: 20) : null,
                  onTap: () => onSelect(teacher),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
