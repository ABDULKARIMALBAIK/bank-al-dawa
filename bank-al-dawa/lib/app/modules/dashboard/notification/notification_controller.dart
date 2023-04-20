import 'package:bank_al_dawa/app/core/helper/data_helper.dart';
import 'package:bank_al_dawa/app/core/models/report_models/report_model.dart';
import 'package:bank_al_dawa/app/core/services/data_list.dart';
import 'package:bank_al_dawa/app/core/services/getx_storage_controller.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/constant/dashboard_routes.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/models/app_models/notification_model.dart';
import '../../../core/services/request_manager.dart';
import '../../../core/widgets/toast.dart';
import '../../../core/widgets/widget_state.dart';
import '../shared/dashboard_repository.dart';

class NotificationController extends GetxStorageController
    with DataList<NotificationModel> {
  DashboardRepository dashboardRepository;
  ScrollController scrollController = ScrollController();
  String builderId = "notification_id";
  String builderPaginationId = 'notification_builder_id';

  final int limit = 30;

  NotificationController({required this.dashboardRepository});

  @override
  void onInit() {
    super.onInit();

    //Fetch meetings data
    // Future.delayed(const Duration(milliseconds: 1000))
    //     .then((value) => getNotifications());
    getNotifications();
  }

  Future<void> getNotifications(
      {RequestType requestType = RequestType.getData}) async {
    try {
      if (requestType == RequestType.refresh) {
        updateState([builderId], WidgetState.loading);
      }

      if (requestType == RequestType.getData) {
        updateState([builderId], WidgetState.loading);
      }

      final List<NotificationModel> notifications =
          await dashboardRepository.getNotifications(
              requestType == RequestType.refresh ? 0 : lastId,
              limit,
              !(DataHelper.user!.permission!.name == 'موظف'));

      handelDataList(
          ids: [builderPaginationId],
          requestType: requestType,
          function: () async {
            return Future.value(notifications);
          });

      if (notifications.isEmpty && dataList.isEmpty) {
        updateState([builderId], WidgetState.noResults);
      } else {
        updateState([builderId], WidgetState.loaded);
      }
    } on CustomException catch (e) {
      updateState([builderId], WidgetState.error);
      CustomToast.showError(e.error);
    }
  }

  Future<void> getNotificationDetails(int id) async {
    try {
      BotToast.showLoading();
      final Report report = await dashboardRepository.getReportDetails(id);
      DataHelper.ratingReportModel = report;
      Get.toNamed(
        DashboardRoutes.ratingReportsRoute,
        arguments: [
          {"from_non_delivered_report": true}
        ],
      );
    } catch (_) {}
    BotToast.closeAllLoading();
  }
}
