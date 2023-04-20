import 'dart:developer';

import 'package:bank_al_dawa/app/core/constants/colors.dart';
import 'package:bank_al_dawa/app/core/helper/data_helper.dart';
import 'package:bank_al_dawa/app/core/models/report_models/report_log_model.dart';
import 'package:bank_al_dawa/app/core/services/size_configration.dart';
import 'package:bank_al_dawa/app/core/widgets/bottom_sheet/filter_bottom_sheet.dart';
import 'package:bank_al_dawa/app/core/widgets/neumorphic_container.dart';
import 'package:bank_al_dawa/app/core/widgets/toast.dart';
import 'package:bank_al_dawa/app/core/widgets/widget_state.dart';
import 'package:bank_al_dawa/app/modules/dashboard/all_reports/all_reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/models/report_models/report_model.dart';
import '../../../core/services/request_manager.dart';
import '../../../core/widgets/bottom_sheet/phone_bottom_sheet.dart';
import '../../../core/widgets/no_resulte.dart';
import '../../../core/widgets/pagination.dart';

class AllReportsView extends GetView<AllReportsController> {
  const AllReportsView({Key? key}) : super(key: key);

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
                child: Stack(
                  children: [
                    NestedScrollView(
                        controller: controller.scrollController,
                        headerSliverBuilder: (context, boolean) {
                          return [
                            _header(
                                context,
                                customSize.screenWidth,
                                75, //customSize.setHeight(75),
                                'all_reports_title'.tr),
                          ];
                        },
                        body: _body(context, customSize.screenWidth,
                            customSize.screenHeight)),

                    ////////////////////////////// * Add Button * //////////////////////////////
                    DataHelper.user!.permission!.name == 'مدير' ||
                            DataHelper.user!.permission!.name == 'مشرف'
                        ? _buttonAdd(context)
                        : Container()
                  ],
                ),
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

              ////////////////////////////// *  Print Button * //////////////////////////////
              Align(
                alignment: Alignment.centerLeft,
                child: _buttonPrint(context),
              ),

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
            child: StateBuilder<AllReportsController>(
              key: UniqueKey(),
              id: controller.listNumberResults,
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
        child: StateBuilder<AllReportsController>(
          key: UniqueKey(),
          id: controller.listReportsId,
          disableState: false,
          onRetryFunction: () {
            controller.loadReports(requestType: RequestType.refresh);
          },
          noResultView: const NoResults(),
          // loadingView: ,
          // errorView: ,
          initialWidgetState: WidgetState.loading,
          builder: (widgetState, controllers) {
            return PaginationBuilder<AllReportsController>(
              id: controller.reportsPaginationId,
              onRefresh: () =>
                  controller.loadReports(requestType: RequestType.refresh),
              onLoadingMore: () =>
                  controller.loadReports(requestType: RequestType.loadingMore),
              builder: (scrollController) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
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
        //DataHelper.user!.permission! != null
        child: report.patientIsCame == false
            ? Slidable(
                key: UniqueKey(),
                useTextDirection: false,
                enabled: true,
                closeOnScroll: false,
                direction: Axis.horizontal,
                startActionPane: ActionPane(
                  dragDismissible: false,
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(onDismissed: () {
                    controller.updateReportState(report);
                  }),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 25),
                      child: SizedBox(
                        width: 150,
                        height: 245,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SlidableAction(
                              borderRadius: BorderRadius.circular(10),
                              onPressed: (context) {
                                controller.updateReportState(report);
                              },
                              backgroundColor:
                                  _setBackgroundDismissible(report),
                              foregroundColor: Colors.white,
                              icon: Icons.star,
                              label: _setLabel(report),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // endActionPane: ,
                child: slideItem(context, report))
            : slideItem(context, report));
  }

  SizedBox slideItem(BuildContext context, Report report) {
    return SizedBox(
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

              ////////////////////////////// * Editing buttons * //////////////////////////////
              DataHelper.user!.permission!.name == 'مدير' ||
                      DataHelper.user!.permission!.name == 'مشرف'
                  ? _cardButtons(context, report)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Flexible _cardButtons(BuildContext context, Report reportResponse) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ////////////////////////////// * Edit button * //////////////////////////////
            NeumorphicContainer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(16),
              isEffective: true,
              isInnerShadow: false,
              duration: const Duration(milliseconds: 300),
              borderRadius: BorderRadius.circular(18),
              onTab: () {
                DataHelper.reportModel = reportResponse;
                controller.goRegisterReport(true);
              },
              child: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(
              height: 14,
            ),

            ////////////////////////////// * Delete button * //////////////////////////////
            NeumorphicContainer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(16),
              isEffective: true,
              isInnerShadow: false,
              duration: const Duration(milliseconds: 300),
              borderRadius: BorderRadius.circular(18),
              onTab: () {
                //Show dialog
                _showDialogDelete(context, reportResponse);
              },
              child: Icon(
                Icons.delete,
                color: controller.isDark ? Colors.redAccent : Colors.red,
                size: 20,
              ),
            ),
          ],
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
          visible: true, //_checkPriority(report)
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
                    controller: controller);
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

  Align _buttonAdd(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 65,
          height: 65,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(4),
                primary: Theme.of(context).primaryColor,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))),
            child: Center(
              child: Icon(
                Icons.add,
                size: 28,
                color: controller.isDark ? Colors.black54 : Colors.white,
              ),
            ),
            onPressed: () {
              controller.goRegisterReport(false);
            },
          ),
        ),
      ),
    );
  }

  SizedBox _buttonPrint(BuildContext context) {
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
            Icons.print,
            size: 28,
            color: controller.isDark ? Colors.black54 : Colors.white,
          ),
        ),
        onPressed: () async {
          try {
            CustomToast.showLoading();
            await controller.makeExcelFile();
            CustomToast.closeLoading();
          } catch (e) {
            CustomToast.closeLoading();
            log('excelFileError:$e');
          }
        },
      ),
    );
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
          FilterBottomSheet.showFilterDialog(context, controller);
        },
      ),
    );
  }

  void _showDialogDelete(BuildContext context, Report reportResponse) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 10,
          title: Text(
            'all_reports__dialog_delete_title'.tr,
            style: Theme.of(context).textTheme.headline6,
          ),
          content: Text(
            'all_reports__dialog_delete_description'.tr,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: <Widget>[
            // Submit
            TextButton(
              style: TextButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.all(4),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                primary: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              child: Text(
                'dialog_yes'.tr,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Theme.of(context).primaryColor),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
              onPressed: () async {
                await controller.deleteReport(reportResponse);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            ),

            // Cancel
            TextButton(
              style: TextButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.all(4),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                primary: controller.isDark ? Colors.redAccent : Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              child: Text(
                'dialog_cancel'.tr,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: controller.isDark ? Colors.redAccent : Colors.red),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  bool _checkPriority(Report report) {
    final String color = report.priority!.color;
    if (color == 'ضروري' || color == 'مستعجل' || color == 'انتباه') {
      return true;
    } else {
      return false;
    }
  }

  Color _setupColorPriority(Report report) {
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

  Color _setupColorReason(Report report) {
    if (report.reportlogs!.isEmpty) {
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

      //
      if (reason == 'حجة' || reason == '+حجة') {
        return controller.isDark ? Colors.deepOrange : Colors.deepOrangeAccent;
      } else {
        return Colors.transparent;
      }
    }
  }

  Color _setBackgroundDismissible(Report report) {
    // ignore: unnecessary_null_comparison
    if (report.userIsReceived == null) {
      return controller.isDark ? Colors.yellow : Colors.yellow;
    } else if (report.userIsReceived == false) {
      return controller.isDark ? Colors.yellow : Colors.yellow;
    }
    // ignore: unnecessary_null_comparison
    else if (report.patientIsCame == null) {
      return controller.isDark ? Colors.greenAccent : Colors.green;
    } else {
      return controller.isDark ? Colors.greenAccent : Colors.green;
    }
  }

  String _setLabel(Report report) {
    // ignore: unnecessary_null_comparison
    if (report.userIsReceived == null) {
      return 'تم الاستلام';
    } else if (report.userIsReceived == false) {
      return 'تم الاستلام';
    }
    // ignore: unnecessary_null_comparison
    else if (report.patientIsCame == null) {
      return 'تم المراجعة';
    } else {
      return 'تم المراجعة';
    }
  }
}
