class AppConstants {

  // 1. Local Storage Keys
  static const String tokenKey = "user_token";
  static const String userKey = "user_data";
  static const String isFirstRun = "is_first_run";

  // 2. UI Strings
  static const String appName = "EduFlow";
  static const String defaultErrorMessage = "Something went wrong, please try again.";
  static const String noInternetMessage = "Check your internet connection.";

  // 4. Validation Settings
  static const int minPasswordLength = 8;
  static const int phoneLength = 10;

  // 5. Asset Paths
  static const String logoPath = "images/SchoolManagementIcon.png";
  static const String placeholderImage = "assets/images/placeholder.png";

  //Height
  static const double minHeightForWindowsApplications = 600;
  static const double minHeightForChromeApplications = 700;



  //API

    //Server API
      static const String linkServer = "https://darkseagreen-salamander-685564.hostingersite.com";
      static const String linkServerName = "$linkServer/api/v1";

      static Map<String,String> headers(String token)=> {
                    'Authorization': 'Bearer $token',
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    };
        // Auth
          static const String linkSignUp = "$linkServerName/register";
          static const String linkLogIn = "$linkServerName/login";
          static const String linkEmailForForgetPassword = "$linkServerName/forget_password";
          static const String linkResetPassword = "$linkServerName/reset_password";
          static const String linkLogOut = "$linkServerName/logout";
          static const String linkProfile = "$linkServerName/me";
          static const String linkStorage = "$linkServer/storage/";
          // static const String linkUpdateProfile = "$linkServerName/update-profile";
          static const String linkRefreshToken = "$linkServerName/refresh";

      // Salary
          static  String linkGetSalaryByRole(type) => "$linkServerName/get_salary/$type";
          static  String linkChangeSalaryById(id) => "$linkServerName/change_salary/$id";
          static  String linkPaidSalaryById(id) => "$linkServerName/pay_salary/$id";
          static  String linkAssignSalary(int id) => "$linkServerName/assign_salary/$id";

      //Invoice
          static const String linkGetInvoices = "$linkServerName/get_invoice";
          static const String linkCreateInvoice = "$linkServerName/create_invoice";
          static  String linkDeleteInvoice(id) => "$linkServerName/delete_invoice/$id";
          static  String linkGetInvoicesById(id) => "$linkServerName/get_invoice/$id";
          static  String linkUpdateInvoice = "$linkServerName/update_invoice";
          static  String linkGetInvoiceItems(int invoiceId) => "$linkServerName/get_invoice_items/$invoiceId";
          static  String linkPayInvoice(int invoiceId, int itemId) => "$linkServerName/pay_invoice/$invoiceId/$itemId";
          static const String linkAddInvoiceItem = "$linkServerName/add_invoice_item";
          static  String linkUpdateInvoiceItem(int id) => "$linkServerName/update_invoice_item/$id";
          static  String linkDeleteInvoiceItem(int id) => "$linkServerName/delete_invoice_item/$id";
          static const String linkGetFeeTypes = "$linkServerName/get_fee";
          static const String linkCreateFeeType = "$linkServerName/create_fee";
          static  String linkUpdateFeeType(int id) => "$linkServerName/update_fee/$id";
          static  String linkDeleteFeeType(int id) => "$linkServerName/delete_fee/$id";


      //Academic Management
          static const String linkGetStudyStage="$linkServerName/get_study_stage";
          static const String linkCreateStudyStage="$linkServerName/create_study_stage";
          static  String linkUpdateStudyStage(id) => "$linkServerName/update_study_stage/$id";
          static  String linkDeleteStudyStage(id) => "$linkServerName/delete_study_stage/$id";
          static const String linkCreateSection="$linkServerName/create_section";
          static  String linkGetSubjectsByGrade(int gradeId) => "$linkServerName/get_material/$gradeId";
          static const String linkAddSubjectOnGrade= "$linkServerName/create_material";




      //Notification
          static const String linkGetNotifications = "$linkServerName/Notifincation";
          static const String linkAddNotification = "$linkServerName/addNotifincation";
          static  String linkMakeNotificationsIsRead(int id) => "$linkNotifications/$id/read";
          static const String linkPushNotifications = "$linkServerName/push-notifications"; // Kept for reference if needed
          static const String linkNotifications = "$linkServerName/notifications"; // Kept for reference if needed


      //All users
          static const String linkGetAllUsers = "$linkServerName/admin/users";
          static const String linkGetNotApprovedUsers = "$linkServerName/admin/users/pending";
          static  String linkApproveUser(id) => "$linkServerName/approve/$id";
          static const String linkGetAllTeachers = "$linkServerName/admin/teachers";
          static const String linkGetNotApprovedTeachers = "$linkServerName/admin/teachers/pending";
          static  String linkGetTeacherDetails(id) => "$linkServerName/admin/teachers/$id";
          static const String linkGetAllStudents = "$linkServerName/admin/students";
          static const String linkGetNotApprovedStudents = "$linkServerName/admin/students/pending";
          static  String linkGetStudentDetails(id) => "$linkServerName/admin/students/$id";
          static const String linkGetAllSupervisors = "$linkServerName/admin/supervisors";
          static const String linkGetNotApprovedSupervisors = "$linkServerName/admin/supervisors/pending";
          static const String linkGetCountOfTeachers = "$linkServerName/admin/count/teacher";
          static const String linkGetCountOfStudents = "$linkServerName/admin/count/student";
          static const String linkGetCountOfSupervisors = "$linkServerName/admin/count/supervisor";
          static const String linkGetCountOfClasses = "$linkServerName/admin/count/study_stage";



      // Marks
          static const String linkGetMarks = "$linkServerName/admin/marks";//done



      // Assign material to teacher
          static const String linkAssignMaterialToTeacher="$linkServerName/assign_material_to_teacher";
          static const String linkAssignTeacherToGrade="$linkServerName/assign_teacher_to_section";
          static const String linkGetSubjects="$linkServerName/get_material";

      // Student Schedule
          static String linkGetScheduleOfSection(int sectionId, int stageId) => "$linkServerName/schedul_of_section/$sectionId/$stageId";
          static const String linkCreateSchedule = "$linkServerName/create_schedule";
          static const String linkSyncScheduleSlots = "$linkServerName/schedule_slot/sync";
          static const String linkGetPeriods = "$linkServerName/get_period";

      // Reports
          static const String linkGetReports = "$linkServerName/reports";
          static String linkDownloadReport(int id) => "$linkServerName/reports/$id/download";


}