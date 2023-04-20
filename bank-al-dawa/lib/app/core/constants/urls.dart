import 'package:flutter/material.dart';

class ConstUrls {
  static String baseUrl = "";
  static String uploadFileUrl =
      "";
  static String loginEndPoint = 'auth/login';
  static String constantEndPoint = 'constant';
  static String updateDownloadReportEndPoint = 'download/update';
  static String downloadReportsEndPoint = 'download';
  static String downloadReportsUserEndPoint = 'download/member';
  static String registerEndPoint = 'auth/signup';
  static String meetingsEndPoint = 'meeting';
  static String manageAccountsEndPoint = 'user';
  static String notificationsEndPoint = 'notification';
  static String deleteAccountEndPoint = 'user';
  static String reportDateEndPoint = 'report/visitDate';
  static String createMeetingEndPoint = 'meeting';
  static String updateAccountEndPoint = 'user'; //PATCH
  static String allRegionsEndPoint = 'region';
  static String registerNewReportEndPoint = 'report/admin';
  static String updateReportEndPoint = 'report'; //PATCH
  static String getAllReportsEndPoint = 'report-log/filter';
  static String deleteReportEndPoint = 'report'; //DELETE
  static String updateReportStateEndPoint = 'report/userIsReceived'; //PATCH
  static String submitResultEndPoint = 'report-log';
  static String reviewReportEndPoint = 'report/checkAt';

  static String welcomeLottieUrl = 'assets/lottie/welcome.json';
  static String noResultsImageUrl = 'assets/images/no_results.svg';
  static String appIconUrl = 'assets/images/ic_launcher.png';

  static String appName = 'Bank_AlDawa';

  static Locale getCurrentLanguage(String currentLanguage) {
    if (currentLanguage == 'english') {
      return const Locale('en');
    } else if (currentLanguage == 'arabic') {
      return const Locale('ar');
    } else {
      return const Locale('en');
    }
  }
}
