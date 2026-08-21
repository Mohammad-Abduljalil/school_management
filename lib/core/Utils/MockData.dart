import '../../Model/HomeModel/UserModel.dart';
import '../../Model/HomeModel/StudentModel/StudentModel.dart';
import '../../Model/HomeModel/TacherModel/TeacherModel.dart';
import '../../Model/HomeModel/SupervisorModel/SupervisorModel.dart';
import '../../Model/HomeModel/Marks/MarkModel.dart';
import '../../Model/HomeModel/InvoiceModel.dart';
import '../../Model/HomeModel/InvoiceItemModel.dart';
import '../../Model/HomeModel/AcademicManagementModel/StageModel.dart';
import '../../Model/HomeModel/SectionModel.dart' as GlobalSection;
import '../../Model/HomeModel/SubjectModel.dart';
import '../../Model/HomeModel/NotificationModel.dart';
import '../../Model/HomeModel/ReportModel.dart';
import '../../Model/HomeModel/SalaryModel.dart';
import '../../Model/HomeModel/StudentScheduleModel/ScheduleModel.dart';
import '../../Model/HomeModel/StudentScheduleModel/ScheduleSlotModel.dart';
import '../../Model/HomeModel/StudentScheduleModel/PeriodTemplateModel.dart';
import '../../Model/Profile/ProfileModel.dart';

class MockData {
  static Profilemodel get mockProfile => Profilemodel(
        id: 1,
        full_name: "Demo Admin",
        email: "demo@school.com",
        phone: "1234567890",
        location: "Demo City",
        profile_image: "",
      );

  static List<UserModel> get mockUsers => [
        UserModel(id: 1, full_name: "John Doe", email: "john@example.com", status: 1),
        UserModel(id: 2, full_name: "Jane Smith", email: "jane@example.com", status: 0),
        UserModel(id: 3, full_name: "Robert Brown", email: "robert@example.com", status: 1),
      ];

  static List<StudentModel> get mockStudents => [
        StudentModel(id: 1, full_name: "Alice Johnson", email: "alice@student.com", status: 1, student_id: 101, phone: "111222333", location: "East Side", profile_image: "", salary: 0),
        StudentModel(id: 2, full_name: "Bob Wilson", email: "bob@student.com", status: 1, student_id: 102, phone: "444555666", location: "West Side", profile_image: "", salary: 0),
      ];

  static List<TeacherModel> get mockTeachers => [
        TeacherModel(id: 10, full_name: "Dr. Sarah Miller", email: "sarah@teacher.com", status: 1, teacher_id: 201, phone: "777888999", location: "North Side", profile_image: "", salary: 1500),
        TeacherModel(id: 11, full_name: "Mr. James Bond", email: "james@teacher.com", status: 1, teacher_id: 202, phone: "000111222", location: "South Side", profile_image: "", salary: 1200),
      ];

  static List<SupervisorModel> get mockSupervisors => [
        SupervisorModel(id: 20, full_name: "Emma Davis", email: "emma@super.com", status: 1, supervisor_id: 301, phone: "333444555", location: "Central", profile_image: "", salary: 2000),
      ];

  static List<StageModel> get mockStages => [
        StageModel(id: 1, stage_number: 1, section_number: [1, 2], sections: [
          GlobalSection.SectionModel(id: 1, name: "Section 1", gradeId: 1),
          GlobalSection.SectionModel(id: 2, name: "Section 2", gradeId: 1),
        ]),
        StageModel(id: 2, stage_number: 2, section_number: [1], sections: [
          GlobalSection.SectionModel(id: 3, name: "Section 1", gradeId: 2),
        ]),
      ];

  static List<SubjectModel> get mockSubjects => [
        SubjectModel(id: 1, name: "Mathematics", gradeId: 1),
        SubjectModel(id: 2, name: "Science", gradeId: 1),
        SubjectModel(id: 3, name: "History", gradeId: 2),
      ];

  static List<MarkModel> get mockMarks => [
        MarkModel(id: 1, studentName: "Alice Johnson", subjectName: "Mathematics", mark: 95, date: "2024-01-15"),
        MarkModel(id: 2, studentName: "Alice Johnson", subjectName: "Science", mark: 88, date: "2024-01-16"),
        MarkModel(id: 3, studentName: "Bob Wilson", subjectName: "Mathematics", mark: 75, date: "2024-01-15"),
      ];

  static List<InvoiceModel> get mockInvoices => [
        InvoiceModel(id: 1, student_name: "Alice Johnson", total_amount: 500, paid_amount: 500, status: "Paid", date: "2024-01-01"),
        InvoiceModel(id: 2, student_name: "Bob Wilson", total_amount: 500, paid_amount: 200, status: "Partial", date: "2024-01-05"),
      ];

  static List<InvoiceItemModel> get mockInvoiceItems => [
        InvoiceItemModel(id: 1, fee_type: "Tuition", amount: 400, status: "Paid"),
        InvoiceItemModel(id: 2, fee_type: "Books", amount: 100, status: "Paid"),
      ];

  static List<SalaryModel> get mockSalaries => [
        SalaryModel(id: 1, name: "Dr. Sarah Miller", role: "Teacher", amount: 1500, status: "Paid", date: "2024-01-30"),
        SalaryModel(id: 2, name: "Mr. James Bond", role: "Teacher", amount: 1200, status: "Pending", date: "2024-01-30"),
      ];

  static List<NotificationModel> get mockNotifications => [
        NotificationModel(id: 1, title: "Exam Schedule", body: "Final exams start next week.", createdAt: "2024-02-01", isRead: false),
        NotificationModel(id: 2, title: "Holiday Notice", body: "School will be closed on Friday.", createdAt: "2024-01-25", isRead: true),
      ];

  static List<ReportModel> get mockReports => [
        ReportModel(id: 1, title: "Monthly Attendance", description: "January attendance summary", createdAt: "2024-02-01"),
        ReportModel(id: 2, title: "Financial Report", description: "Q1 financial overview", createdAt: "2024-01-31"),
      ];

  static List<PeriodTemplateModel> get mockPeriods => [
        PeriodTemplateModel(id: 1, name: "Period 1", startTime: "08:00", endTime: "09:00"),
        PeriodTemplateModel(id: 2, name: "Period 2", startTime: "09:00", endTime: "10:00"),
      ];

  static ScheduleModel get mockSchedule => ScheduleModel(
        scheduleId: 1,
        days: {
          "sunday": {
            "Period 1": ScheduleSlotModel(id: 1, periodName: "Period 1", startTime: "08:00", endTime: "09:00", materialName: "Mathematics", teacherName: "Dr. Sarah Miller", materialId: 1, teacherId: 201, periodId: 1),
          },
          "monday": {
            "Period 1": ScheduleSlotModel(id: 2, periodName: "Period 1", startTime: "08:00", endTime: "09:00", materialName: "Science", teacherName: "Mr. James Bond", materialId: 2, teacherId: 202, periodId: 1),
          }
        },
      );
}
