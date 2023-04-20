import 'package:bank_al_dawa/app/core/constants/colors.dart';
import 'package:bank_al_dawa/app/core/services/size_configration.dart';
import 'package:bank_al_dawa/app/core/widgets/bottom_sheet/filter_non_delivered_bottom_sheet.dart';
import 'package:bank_al_dawa/app/core/widgets/neumorphic_container.dart';
import 'package:bank_al_dawa/app/modules/dashboard/non_delivered_reports/non_delivered_reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/helper/data_helper.dart';
import '../../../core/models/report_models/report_log_model.dart';
import '../../../core/models/report_models/report_model.dart';
import '../../../core/services/request_manager.dart';
import '../../../core/widgets/bottom_sheet/phone_bottom_sheet.dart';
import '../../../core/widgets/no_resulte.dart';
import '../../../core/widgets/pagination.dart';
import '../../../core/widgets/widget_state.dart';

class NonDeliveredReportsView extends GetView<NonDeliveredReportsController> {
  const NonDeliveredReportsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: ScreenSizer(
            builder: (customSize) {
              return Container(
                width: customSize.screenWidth,
                height: customSize.screenHeight,
                decoration: _gradientColors(),
                child: NestedScrollView(
                    controller: controller.scrollController,
                    headerSliverBuilder: (context, boolean) {
                      return [
                        _header(
                            context,
                            customSize.screenWidth,
                            75, //customSize.setHeight(75)
                            'non_delivered_reports_title'.tr),
                      ];
                    },
                    body: _body(context, customSize.screenWidth,
                        customSize.screenHeight)),
              );
            },
          )),
    );
  }

  /* Widget Methods */

  BoxDecoration _gradientColors() {
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
          ConstColors().primaryColorLight(),
          ConstColors().primaryColorDark(),
        ]));
  }

  SliverToBoxAdapter _header(
      BuildContext context, double width, double height, String text) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              ////////////////////////////// *  Title * //////////////////////////////
              _headerText(context, text),

              ////////////////////////////// *  Filter Button * //////////////////////////////
              Align(
                alignment: Alignment.centerRight,
                child: _buttonFilter(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Align _headerText(BuildContext context, String text) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.white),
          ),
          SizedBox(
            child: StateBuilder<NonDeliveredReportsController>(
              key: UniqueKey(),
              id: controller.listNumberResultsId,
              disableState: true,
              onRetryFunction: () {
                controller.loadReports(requestType: RequestType.refresh);
              },
              // noResultView: ,
              // loadingView: ,
              // errorView: ,
              initialWidgetState: WidgetState.loading,
              builder: (widgetState, controllers) {
                return Text(
                  controller.numberReports.toString(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding _body(BuildContext context, double widget, double height) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        width: widget,
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        ////////////////////////////// * Reports * //////////////////////////////
        child: StateBuilder<NonDeliveredReportsController>(
          key: UniqueKey(),
          id: controller.listReportsId,
          initialWidgetState: WidgetState.loading,
          disableState: false,
          noResultView: const NoResults(),
          onRetryFunction: () {
            controller.loadReports(requestType: RequestType.refresh);
          },
          builder: (widgetState, controller) {
            return PaginationBuilder<NonDeliveredReportsController>(
              key: UniqueKey(),
              id: controller.reportsPaginationId,
              onRefresh: () async => await controller.loadReports(
                  requestType: RequestType.refresh),
              onLoadingMore: () async => await controller.loadReports(
                  requestType: RequestType.loadingMore),
              builder: (scrollController) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  // itemExtent: 245,
                  itemCount: controller.dataList.length,
                  itemBuilder: (context, index) =>
                      _allReportsItem(context, controller.dataList[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Padding _allReportsItem(BuildContext context, Report report) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 245,
        child: Center(
          child: NeumorphicContainer(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
            isEffective: true,
            isInnerShadow: false,
            duration: const Duration(milliseconds: 300),
            borderRadius: BorderRadius.circular(10),
            onTab: () {
              //Go to Rating report
              DataHelper.ratingReportModel = report;
              controller.goRatingReport();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                ////////////////////////////// * User Data * //////////////////////////////
                _userData(context, report),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _userData(BuildContext context, Report report) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ////////////////////////////// * Line Status * //////////////////////////////
        Visibility(
          visible: true, //_checkPriority(report),
          child: Container(
            width: 4,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: _setupColorPriority(report),
            ),
          ),
        ),
        const SizedBox(
          width: 9,
        ),

        ////////////////////////////// * Statement Data * //////////////////////////////
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ////////////////////////////// * Name Data * //////////////////////////////
              Flexible(
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                        color: _setupColorReason(report),
                        borderRadius: BorderRadius.circular(18)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Flexible(
                          child: Text(report.name,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText2!),
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 2,
              ),

              ////////////////////////////// * Location Data * //////////////////////////////
              _userDataItem(
                  context,
                  report.region == null ? '' : report.region!.name,
                  Icons.location_on_rounded),
              const SizedBox(
                height: 2,
              ),

              ////////////////////////////// * Phone Data * //////////////////////////////
              _userDataItem(context, report.phone, Icons.phone, onTap: () {
                PhoneBottomSheet.showPickerDialog(context, report.phone,
                    nonDeliveredController: controller);
              }),
              const SizedBox(
                height: 2,
              ),

              ////////////////////////////// * Date Data * //////////////////////////////
              _userDataItem(
                  context,
                  DateFormat('yyyy-MM-dd').format(report.createdAt),
                  Icons.calendar_today_outlined),
              const SizedBox(
                height: 2,
              ),

              ////////////////////////////// * states Data * //////////////////////////////
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: report.userIsReceived == false
                          ? Colors.grey
                          : Colors.yellow,
                      size: 19,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.star,
                      color: report.patientIsCame == false
                          ? Colors.grey
                          : Colors.green,
                      size: 19,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Flexible _userDataItem(BuildContext context, String text, IconData icon,
      {VoidCallback? onTap}) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 18,
            ),
            const SizedBox(
              width: 4,
            ),
            Flexible(
              child: Text(text,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2!),
            ),
          ],
        ),
      ),
    );
  }

  bool _checkPriority(Report report) {
    if (report.priority == null) {
      return false;
    } else {
      final String color = report.priority!.color;
      if (color == 'ضروري' || color == 'مستعجل' || color == 'انتباه') {
        return true;
      } else {
        return false;
      }
    }
  }

  Color _setupColorPriority(Report report) {
    if (report.priority == null) {
      return Colors.transparent;
    } else {
      final String color = report.priority!.color;
      if (color == 'انتباه') {
        return controller.isDark ? Colors.redAccent : Colors.red;
      } else if (color == 'مستعجل') {
        return controller.isDark ? Colors.greenAccent : Colors.green;
      } else if (color == 'ضروري') {
        return controller.isDark ? Colors.yellow : Colors.yellowAccent;
      } else {
        return Colors.transparent;
      }
    }
  }

  Color _setupColorReason(Report report) {
    if (report.reportlogs == null) {
      return Colors.transparent;
    } else if (report.reportlogs!.isEmpty) {
      return Colors.transparent;
    } else {
      String reason = '';

      if (report.reportlogs!.isNotEmpty) {
        ReportLog reportLog = report.reportlogs![0];
        for (ReportLog log in report.reportlogs!) {
          if (reportLog.id <= log.id) {
            reportLog = log;
          }
        }

        reason = reportLog.result!.name;
      }

      // final reason = report.reportlogs!.isNotEmpty
      //     ? report.reportlogs![report.reportlogs!.length - 1].result!.name
      //     : '';
      if (reason == 'حجة' || reason == '+حجة') {
        return controller.isDark ? Colors.deepOrange : Colors.deepOrangeAccent;
      } else {
        return Colors.transparent;
      }
    }
  }

  SizedBox _buttonFilter(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12),
            primary: Theme.of(context).primaryColor,
            shadowColor: Colors.black54),
        child: Center(
          child: Icon(
            Icons.filter_alt_outlined,
            size: 28,
            color: controller.isDark ? Colors.black54 : Colors.white,
          ),
        ),
        onPressed: () {
          FilterNonDeliveredBottomSheet.showFilterDialog(context, controller);
        },
      ),
    );
  }
}
