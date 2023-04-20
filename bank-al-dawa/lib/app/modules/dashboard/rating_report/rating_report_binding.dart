import 'package:bank_al_dawa/app/modules/dashboard/rating_report/rating_report_controller.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:get/get.dart';

class RatingReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RatingReportController(
        dashboardRepository: Get.find<DashboardRepository>()));
  }
}
