class AppConstants {

  // 1. مفاتيح التخزين المحلي (Local Storage)
  static const String tokenKey = "user_token";
  static const String userKey = "user_data";
  static const String isFirstRun = "is_first_run";

  // 2. نصوص عامة (UI Strings)
  static const String appName = "EduFlow";
  static const String defaultErrorMessage = "Something went wrong, please try again.";
  static const String noInternetMessage = "Check your internet connection.";

  // 4. إعدادات الـ Validation
  static const int minPasswordLength = 8;
  static const int phoneLength = 10;

  // 5. المسارات الافتراضية (Assets)
  static const String logoPath = "images/SchoolManagementIcon.png";
  static const String placeholderImage = "assets/images/placeholder.png";

  //API

    //Auth API
      static const String linkServerName = "http://10.214.82.99:8000/api";

        // Auth
          static const String linkSignUp = "$linkServerName/register";
          static const String linkLogIn = "$linkServerName/login";
          static const String linkLogOut = "$linkServerName/logout";
          static const String linkProfile = "$linkServerName/profile";
          static const String linkUpdateProfile = "$linkServerName/update-profile";



        //Notification
          static const String linkNotifications = "$linkServerName/notifications";
          static const String linkPushNotifications = "$linkServerName/push-notifications";


        //All users
          static const String linkAllUsers = "$linkServerName/get-all-users";

        //All users
          static const String linkAllTeachers = "$linkServerName/get-all-teachers";

        // Search
          static const String linkSearch = "$linkServerName/search";




}