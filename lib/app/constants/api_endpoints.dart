class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  // For Android Emulator
  static const String baseUrl = "http://10.0.2.2:5000/api/";
  static const String url = "http://10.0.2.2:5000";

  // ============= Auth Routes =============
  static const String login = "auth/login";
  static const String signUp = "auth/signup";
  static const String editProfile = 'auth/edit-profile';
  static const String forgotPassword = 'auth/forgot-password';

  // ============= User Routes =============
  static const String reportUrl = 'reports/user';

  // ================== Report Routes ==================
  static const String createReport = "reports/submit";
  static const String getReportDetails = "reports/detail";
  static String editReport(String id) => "reports/$id/edit";
  static String deleteReport(String id) => "reports/$id/delete";
}
