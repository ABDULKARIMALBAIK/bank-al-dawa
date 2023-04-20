import 'package:bank_al_dawa/app/modules/dashboard/notification/notification_controller.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:get/get.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController(
        dashboardRepository: Get.find<DashboardRepository>()));
  }
}
