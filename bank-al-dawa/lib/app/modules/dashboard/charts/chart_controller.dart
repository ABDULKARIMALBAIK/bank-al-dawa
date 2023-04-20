import 'package:bank_al_dawa/app/core/models/app_models/first_pie_chart_model.dart';
import 'package:bank_al_dawa/app/core/models/app_models/second_pie_chart_model.dart';
import 'package:bank_al_dawa/app/core/services/getx_storage_controller.dart';
import 'package:bank_al_dawa/app/core/widgets/widget_state.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/widgets/toast.dart';

class ChartController extends GetxStorageController
    with GetSingleTickerProviderStateMixin {
  DashboardRepository dashboardRepository;

  ScrollController scrollController = ScrollController();
  bool isDark = false;
  String isArabic = 'arabic';

  String buildFirstChartItem = 'buildFirstChartItem';
  String buildSecondChartItem = 'buildSecondChartItem';
  int firstTouchedIndex = -1;
  int secondTouchedIndex = -1;

  int selectedType = 0;

  DateTime selectedDateTime = DateTime.now().subtract(const Duration(days: 7));

  late FirstPieChartModel firstPieChartModel;
  late SecondPieChartModel secondPieChartModel;

  @override
  void onInit() async {
    //Fetch meetings data (here delay is important to fix a bug)
    updateState(
        [buildFirstChartItem, buildSecondChartItem], WidgetState.loading);
    Future.delayed(const Duration(milliseconds: 100)).then((value) async {
      loadDataFirstChart();
    });
    await Future.delayed(const Duration(milliseconds: 1000))
        .then((value) async {
      loadDataSecondChart();
    });

    super.onInit();
  }

  ChartController({required this.dashboardRepository});

  Future<void> loadDataFirstChart() async {
    try {
      updateState([buildFirstChartItem], WidgetState.loading);

      firstPieChartModel = await dashboardRepository.loadFirstChartData(
          type: getSelectedType(),
          date: DateFormat('yyyy-MM-dd').format(selectedDateTime));
      updateState([buildFirstChartItem], WidgetState.loaded);
    } on CustomException catch (e) {
      updateState([buildFirstChartItem], WidgetState.error);
      CustomToast.showError(e.error);
    }
  }

  Future<void> loadDataSecondChart() async {
    try {
      updateState([buildSecondChartItem], WidgetState.loading);

      secondPieChartModel = await dashboardRepository.loadSecondChartData(
          type: getSelectedType(),
          date: DateFormat('yyyy-MM-dd').format(selectedDateTime));

      updateState([buildSecondChartItem], WidgetState.loaded);
    } on CustomException catch (e) {
      updateState([buildSecondChartItem], WidgetState.error);
      CustomToast.showError(e.error);
    }
  }

  String getSelectedType() {
    switch (selectedType) {
      case 0:
        {
          return 'weekly';
        }
      case 1:
        {
          return 'monthly';
        }
      case 2:
        {
          return 'annual';
        }
      default:
        {
          return 'weekly';
        }
    }
  }
}
