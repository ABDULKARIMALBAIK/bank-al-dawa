part of '../dashboard_module.dart';

class _DashboardPages {
  _DashboardPages._();

  static List<GetPage> dashboardPages = [
    GetPage(
      name: DashboardRoutes.allReportsRoute,
      page: () => const AllReportsView(),
      binding: AllReportsBinding(),
    ),
    GetPage(
      name: DashboardRoutes.registerReportRoute,
      page: () => const RegisterReportView(),
      binding: RegisterReportBinding(),
    ),
    GetPage(
      name: DashboardRoutes.notificationRoute,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: DashboardRoutes.nonDeliveredReportsRoute,
      page: () => const NonDeliveredReportsView(),
      binding: NonDeliveredReportsBinding(),
    ),
    GetPage(
      name: DashboardRoutes.ratingReportsRoute,
      page: () => const RatingReportView(),
      binding: RatingReportBinding(),
    ),
    GetPage(
      name: DashboardRoutes.homeRoute,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: DashboardRoutes.calendarRoute,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: DashboardRoutes.chartRoute,
      page: () => const ChartView(),
      binding: ChartBinding(),
    ),
  ];
}
