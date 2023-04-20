import 'package:bank_al_dawa/app/modules/dashboard/all_reports/all_reports_binding.dart';
import 'package:bank_al_dawa/app/modules/dashboard/all_reports/all_reports_view.dart';
import 'package:bank_al_dawa/app/modules/dashboard/calendar/calendar_binding.dart';
import 'package:bank_al_dawa/app/modules/dashboard/charts/chart_binding.dart';
import 'package:bank_al_dawa/app/modules/dashboard/charts/chart_view.dart';
import 'package:bank_al_dawa/app/modules/dashboard/home/home_view.dart';
import 'package:bank_al_dawa/app/modules/dashboard/non_delivered_reports/non_delivered_reports_binding.dart';
import 'package:bank_al_dawa/app/modules/dashboard/notification/notification_binding.dart';
import 'package:bank_al_dawa/app/modules/dashboard/notification/notification_view.dart';
import 'package:bank_al_dawa/app/modules/dashboard/rating_report/rating_report_binding.dart';
import 'package:bank_al_dawa/app/modules/dashboard/rating_report/rating_report_view.dart';
import 'package:bank_al_dawa/app/modules/dashboard/register_report/register_report_binding.dart';
import 'package:bank_al_dawa/app/modules/dashboard/register_report/register_report_view.dart';
import 'package:get/get.dart';

import 'calendar/calendar_view.dart';
import 'home/home_binding.dart';
import 'non_delivered_reports/non_delivered_reports_view.dart';
import 'shared/constant/dashboard_routes.dart';

part 'shared/dashboard_pages.dart';

class DashboardModule {
  static List<GetPage> get dashboardPages => _DashboardPages.dashboardPages;
}
