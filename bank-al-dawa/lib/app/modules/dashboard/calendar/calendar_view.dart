import 'package:bank_al_dawa/app/core/constants/colors.dart';
import 'package:bank_al_dawa/app/core/helper/data_helper.dart';
import 'package:bank_al_dawa/app/core/services/request_manager.dart';
import 'package:bank_al_dawa/app/core/services/size_configration.dart';
import 'package:bank_al_dawa/app/core/widgets/neumorphic_container.dart';
import 'package:bank_al_dawa/app/core/widgets/widget_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/models/report_models/report_model.dart';
import '../../../core/widgets/bottom_sheet/add_meeting_bottom_sheet.dart';
import '../../../core/widgets/pagination.dart';
import 'calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({Key? key}) : super(key: key);

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
                            // customSize.setHeight(37)
                            75,
                            'calendar_title'.tr),
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
            ],
          ),
        ),
      ),
    );
  }

  Align _headerText(BuildContext context, String text) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.white),
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

          ////////////////////////////// * Items * //////////////////////////////
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: controller.scrollController,
            child: Column(
              children: [
                ////////////////////////////// * Calendar Item * //////////////////////////////
                _calendarItem(context),
                const SizedBox(
                  height: 0,
                ),

                ////////////////////////////// * Select Item * //////////////////////////////
                _selectItem(context),

                ////////////////////////////// * List Data Item * //////////////////////////////
                _gridItem(context, widget),
                const SizedBox(
                  height: 0,
                ),

                ////////////////////////////// * Add Meeting * //////////////////////////////
                _addMeetingButton(context),
                const SizedBox(
                  height: 18,
                ),
              ],
            ),
          )),
    );
  }

  GetBuilder _calendarItem(BuildContext context) {
    return GetBuilder<CalendarController>(
      id: controller.buildCalendarItem,
      builder: (c) {
        return Padding(
          padding: const EdgeInsets.all(0),
          child: TableCalendar(
            // locale: DataHelper.languageApp!
            //     .countryCode, //DataHelper.languageApp!.languageCode
            weekendDays: const [DateTime.friday],
            calendarFormat: CalendarFormat.month,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: controller.selectedDateTime,
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextStyle: Theme.of(context).textTheme.headline6!,
            ),
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekHeight: 26,
            daysOfWeekVisible: true,
            daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: Theme.of(context).textTheme.bodyText1!,
                weekendStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: controller.isDark ? Colors.redAccent : Colors.red)),
            calendarStyle: CalendarStyle(
              canMarkersOverflow: true,
              cellMargin: const EdgeInsets.all(6),
              cellPadding: const EdgeInsets.all(0),
              //today
              todayDecoration: BoxDecoration(
                  color: controller.isDark ? Colors.blueAccent : Colors.blue,
                  borderRadius: BorderRadius.circular(300),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 17, //30
                        offset: -const Offset(7, 7), //-widget.distance
                        color: Theme.of(context).hintColor),
                    BoxShadow(
                        blurRadius: 17, //30
                        offset: const Offset(7, 7), //widget.distance
                        color: Theme.of(context).dividerColor),
                  ]),
              todayTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color:
                        controller.isDark ? Colors.yellow : Colors.yellowAccent,
                  ),
              //default
              defaultDecoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(300),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 17, //30
                        offset: -const Offset(7, 7), //-widget.distance
                        color: Theme.of(context).hintColor),
                    BoxShadow(
                        blurRadius: 17, //30
                        offset: const Offset(7, 7), //widget.distance
                        color: Theme.of(context).dividerColor),
                  ]),
              defaultTextStyle: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Theme.of(context).primaryColor),
              //disabled
              disabledDecoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(300),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 17, //30
                        offset: -const Offset(7, 7), //-widget.distance
                        color: Theme.of(context).hintColor),
                    BoxShadow(
                        blurRadius: 17, //30
                        offset: const Offset(7, 7), //widget.distance
                        color: Theme.of(context).dividerColor),
                  ]),
              disabledTextStyle: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Theme.of(context).primaryColor),
              //selected
              selectedDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(300),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 17, //30
                        offset: -const Offset(7, 7), //-widget.distance
                        color: Theme.of(context).hintColor),
                    BoxShadow(
                        blurRadius: 17, //30
                        offset: const Offset(7, 7), //widget.distance
                        color: Theme.of(context).dividerColor),
                  ]),
              selectedTextStyle: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.white),
              //weekend
              weekendDecoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(300),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 17, //30
                        offset: -const Offset(7, 7), //-widget.distance
                        color: Theme.of(context).hintColor),
                    BoxShadow(
                        blurRadius: 17, //30
                        offset: const Offset(7, 7), //widget.distance
                        color: Theme.of(context).dividerColor),
                  ]),
              weekendTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: controller.isDark ? Colors.redAccent : Colors.red),
            ),
            selectedDayPredicate: (day) {
              return isSameDay(controller.selectedDateTime, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              controller.selectedDateTime = selectedDay;
              controller.loadReports(requestType: RequestType.refresh);
              // controller.gerReportsDate();
              controller.update([controller.buildCalendarItem]);
            },
          ),
        );
      },
    );
  }

  Padding _gridItem(BuildContext context, double widget) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      child: SizedBox(
        width: widget, //MediaQuery.of(context).size.width
        height: 220,
        child: StateBuilder<CalendarController>(
          key: UniqueKey(),
          id: controller.listDataReportsId,
          disableState: false,
          onRetryFunction: () {
            // controller.gerReportsDate();
            controller.loadReports(requestType: RequestType.refresh);
          },
          noResultView: SizedBox(
            width: widget, //MediaQuery.of(context).size.width
            height: 220,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning,
                    size: 25,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'لا يوجد كشوفات لعرضها',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // loadingView: ,
          // errorView: ,
          initialWidgetState: WidgetState.loading,
          builder: (widgetState, controllers) {
            return PaginationBuilder<CalendarController>(
              id: controller.reportsDataPaginationId,
              onRefresh: () =>
                  controller.loadReports(requestType: RequestType.refresh),
              onLoadingMore: () =>
                  controller.loadReports(requestType: RequestType.loadingMore),
              builder: (scrollControllers) {
                return GridView.builder(
                  controller: scrollControllers,
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 200 / 300),
                  itemCount: controller.dataList.length,
                  itemBuilder: (context, index) => _reportItem(
                      context, index, controller.dataList[index], widget),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Padding _reportItem(
      BuildContext context, int index, Report report, double widget) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SizedBox(
        // width: widget, //MediaQuery.of(context).size.width,
        height: 150,
        child: Center(
          child: StatefulBuilder(builder: (context, stater) {
            return NeumorphicContainer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
              isEffective: true,
              isInnerShadow: false,
              duration: const Duration(milliseconds: 300),
              borderRadius: BorderRadius.circular(10),
              onLongPress: () {
                //Go to Rating report
                DataHelper.ratingReportModel = report;
                controller.goRatingReport();
              },
              onTab: () {
                controller.selectItem(report, index);
                stater(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ////////////////////////////// * User Data * //////////////////////////////
                  _userData(context, report),

                  ////////////////////////////// * Check Selected * //////////////////////////////
                  const SizedBox(
                    width: 15,
                  ),
                  GetBuilder<CalendarController>(
                    id: report.id,
                    builder: (controllers) {
                      return Flexible(
                        child: Center(
                          child: AnimatedOpacity(
                            opacity: report.checkDate != null
                                ? 1
                                : (report.isSelected ? 1 : 0),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.ease,
                            child: Icon(
                              Icons.stream,
                              color: report.checkDate != null
                                  ? Colors.purple
                                  : Colors.orange,
                              size: 30,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
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
          visible: _checkPriority(report),
          child: Container(
            width: 4,
            height: 170,
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
                  context, report.region!.name, Icons.location_on_rounded),
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
                      // ignore: unnecessary_null_comparison
                      color: report.userIsReceived == null
                          ? Colors.grey
                          : (report.userIsReceived == false
                              ? Colors.grey
                              : Colors.yellow),
                      size: 19,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.star,
                      // ignore: unnecessary_null_comparison
                      color: report.userIsReceived == null
                          ? Colors.grey
                          : (report.userIsReceived == false
                              ? Colors.grey
                              : Colors.green),
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
    final reason = report.name;
    if (reason == 'حجة' || reason == '+حجة') {
      return controller.isDark ? Colors.deepOrange : Colors.deepOrangeAccent;
    } else {
      return Colors.transparent;
    }
  }

  Flexible _userDataItem(BuildContext context, String text, IconData icon) {
    return Flexible(
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
    );
  }

  //NeumorphicContainer _reportItem(BuildContext context, int index , ReportModel report) {
  //     return NeumorphicContainer(
  //       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //       isEffective: false,
  //       isInnerShadow: false,
  //       duration: Duration.zero,
  //       borderRadius: BorderRadius.circular(18),
  //       onTab: () {},
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           ////////////////////////////// * user name * //////////////////////////////
  //           _reportItemData(context, Icons.person, 'احمد '),
  //           const SizedBox(
  //             height: 5,
  //           ),
  //
  //           ////////////////////////////// * employee name * //////////////////////////////
  //           _reportItemData(context, Icons.person_pin, ' علي'),
  //           const SizedBox(
  //             height: 5,
  //           ),
  //
  //           ////////////////////////////// * report type * //////////////////////////////
  //           _reportItemData(context, Icons.insert_drive_file_rounded, 'B'),
  //         ],
  //       ),
  //     );
  //   }

  // ListTile _reportItemData(BuildContext context, IconData icon, String text) {
  //   return ListTile(
  //     leading: Icon(
  //       icon,
  //       size: 25,
  //       color: Theme.of(context).primaryColor,
  //     ),
  //     title: Text(
  //       text,
  //       style: Theme.of(context).textTheme.bodyText2,
  //     ),
  //     horizontalTitleGap: 12,
  //     minLeadingWidth: 12,
  //     dense: true,
  //   );
  // }

  Padding _addMeetingButton(BuildContext context) {
    return DataHelper.user!.permission!.name == 'مدير' ||
            DataHelper.user!.permission!.name == 'مشرف'
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: NeumorphicContainer(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                isEffective: true,
                isInnerShadow: false,
                duration: const Duration(milliseconds: 300),
                borderRadius: BorderRadius.circular(10),
                onTab: () {
                  //open Dialog
                  AddMeetingBottomSheet.showAddMeetingDialog(
                      context, controller);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          'calendar_bottom_sheet_button'.tr,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : const Padding(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: SizedBox(),
          );
  }

  Padding _selectItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ////////////////////////////// * Number * //////////////////////////////
          GetBuilder<CalendarController>(
            id: controller.totalSelectedId,
            builder: (controllers) {
              return Text(
                'العدد:  ${controller.selectedReportsNumber}',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: controller.selectedReports.length > 10
                        ? Colors.red
                        : Theme.of(context).textTheme.bodyText1!.color),
                textAlign: TextAlign.start,
              );
            },
          ),

          ////////////////////////////// * Submit Button * //////////////////////////////
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12)),
          //     primary: Theme.of(context).primaryColor,
          //     padding: const EdgeInsets.all(5),
          //     elevation: 10,
          //   ),
          //   child: Center(
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Text(
          //         'مراجعة',
          //         style: Theme.of(context)
          //             .textTheme
          //             .bodyText1!
          //             .copyWith(color: Colors.white),
          //         textAlign: TextAlign.center,
          //       ),
          //     ),
          //   ),
          //   onPressed: () {
          //     controller.reviewReports();
          //   },
          // )
        ],
      ),
    );
  }
}
