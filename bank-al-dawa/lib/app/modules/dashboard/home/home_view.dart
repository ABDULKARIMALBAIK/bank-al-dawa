import 'dart:developer';

import 'package:bank_al_dawa/app/core/constants/colors.dart';
import 'package:bank_al_dawa/app/core/services/size_configration.dart';
import 'package:bank_al_dawa/app/core/widgets/neumorphic_container.dart';
import 'package:bank_al_dawa/app/core/widgets/widget_state.dart';
import 'package:bank_al_dawa/app/modules/dashboard/home/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';

import '../../../core/helper/data_helper.dart';
import '../../../core/models/report_models/report_model.dart';
import '../../../core/widgets/bottom_sheet/change_region_bottom_sheet.dart';
import '../../../core/widgets/bottom_sheet/transfer_reports_reviewer_bottom_sheet.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: controller.scaffoldKey,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawer: _drawer(context),
          body: StateBuilder<HomeController>(
            key: UniqueKey(),
            id: controller.buildHomeScreen,
            disableState: false,
            onRetryFunction: () {
              controller.loadHomeData();
            },
            // noResultView: ,
            // loadingView: ,
            // errorView: ,
            initialWidgetState: WidgetState.loading,
            builder: (widgetState, controllers) {
              return ScreenSizer(
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
                                // customSize.setHeight(50)
                                50,
                                'home_title'.tr)
                          ];
                        },
                        body: _body(context, customSize)),
                  );
                },
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
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      controller.scaffoldKey.currentState!.openDrawer();
                    },
                    child: const Icon(
                      Icons.list,
                      size: 33,
                      color: Colors.white,
                    ),
                  ),
                ),
                Align(
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
                )
              ],
            )),
      ),
    );
  }

  Container _body(BuildContext context, CustomSize customSize) {
    return Container(
      width: customSize.screenWidth,
      height: customSize.screenHeight,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: controller.scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ////////////////////////////// * Padding Top * //////////////////////////////
            const SizedBox(
              height: 15,
            ),

            ////////////////////////////// * Employee Data * //////////////////////////////
            _employeeData(context, customSize),
            const SizedBox(
              height: 25,
            ),

            ////////////////////////////// * Chart + Reports + R * //////////////////////////////
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                ////////////////////////////// * Chart + Reports * //////////////////////////////
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ////////////////////////////// * Chart  * //////////////////////////////
                    _chart(context, customSize),

                    ////////////////////////////// * Reports  * //////////////////////////////
                    _reports(context),
                  ],
                ),

                ////////////////////////////// * Controllers + buttons * //////////////////////////////
                _controllersButtons(context, customSize),
              ],
            )
          ],
        ),
      ),
    );
  }

  ListTile _cardDataItem(BuildContext context, IconData icon, String text) {
    return ListTile(
      horizontalTitleGap: 0,
      dense: true,
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.caption,
        maxLines: 1,
        textAlign: TextAlign.start,
      ),
    );
  }

  Row _chartTypeItem(BuildContext context, Color color, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(300)),
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.overline!,
        )
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      5,
      (i) {
        final isTouched = i == controller.chartPieIndexTouched;
        final opacity = isTouched ? 1.0 : 0.6;

        const colorHAG = Colors.brown;
        const colorA = Colors.red;
        const colorB = Colors.deepPurple;
        const colorC = Colors.blue;
        const colorX = Colors.green;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: colorHAG.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 80,
              // titleStyle: const TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     color: Color(0xff044d7c)),
              // titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(color: colorHAG, width: 6)
                  : BorderSide(color: colorHAG.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: colorA.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 65,
              // titleStyle: const TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     color: Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(color: colorA, width: 6)
                  : BorderSide(color: colorA.withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: colorB.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 60,
              // titleStyle: const TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     color: Color(0xff4c3788)),
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? const BorderSide(color: colorB, width: 6)
                  : BorderSide(color: colorB.withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: colorC.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 70,
              // titleStyle: const TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     color: Color(0xff0c7f55)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(color: colorC, width: 6)
                  : BorderSide(color: colorC.withOpacity(0)),
            );
          case 4:
            return PieChartSectionData(
              color: colorX.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 70,
              // titleStyle: const TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     color: Color(0xff0c7f55)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(color: colorX, width: 6)
                  : BorderSide(color: colorX.withOpacity(0)),
            );
          default:
            throw Error();
        }
      },
    );
  }

  SizedBox _wifiItem(BuildContext context, CustomSize customSize) {
    return SizedBox(
      child: StateBuilder<HomeController>(
        key: UniqueKey(),
        id: controller.buildWifi,
        disableState: true,
        onRetryFunction: () {
          controller.loadHomeData(showLoadingDialog: true);
        },
        // noResultView: ,
        // loadingView: ,
        // errorView: ,
        initialWidgetState: WidgetState.loading,
        builder: ((widgetState, controller) {
          return StreamBuilder<ConnectivityResult>(
            stream: controller.connectivityController,
            builder: (context, snapshot) {
              log('inernet:_${snapshot.data}');
              return Icon(
                (snapshot.data == ConnectivityResult.mobile ||
                        snapshot.data == ConnectivityResult.wifi ||
                        (snapshot.data == null && controller.homeModel != null))
                    ? Icons.wifi
                    : Icons.wifi_off,
                size: customSize.setWidth(45),
                color: (snapshot.data == ConnectivityResult.mobile ||
                        snapshot.data == ConnectivityResult.wifi ||
                        snapshot.data == null && controller.homeModel != null)
                    ? Theme.of(context).primaryColorLight
                    : Colors.grey,
              );
            },
          );
        }),
      ),
    );
  }

  GestureDetector _refreshItem(BuildContext context, CustomSize customSize) {
    return GestureDetector(
      onTap: () {
        controller.loadHomeData(showLoadingDialog: true);
        // if (controller.homeModel == null) {
        //   controller.loadHomeData(showLoadingDialog: true);
        // } else {
        //   controller.updateReports(showLoadingDialog: true);
        // }
      },
      child: Icon(
        Icons.refresh,
        size: customSize.setWidth(45),
        color: Theme.of(context).primaryColorLight,
      ),
    );
  }

  // ignore: unused_element
  Column _nonReceivedItem(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.call_received,
          size: 45,
          color: Colors.red,
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          '0',
          style: Theme.of(context).textTheme.overline,
        )
      ],
    );
  }

  // ignore: unused_element
  GestureDetector _nonDeliveredReportsItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.goToNonDeliveredReports();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.attach_file,
            size: 45,
            color: Colors.redAccent,
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            '0',
            style: Theme.of(context).textTheme.overline,
          )
        ],
      ),
    );
  }

  GestureDetector _notificationsItem(
      BuildContext context, CustomSize customSize) {
    return GestureDetector(
      onTap: () {
        controller.goToNotifications();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notification_important,
            size: customSize.setWidth(45),
            color: Colors.yellow,
          ),
          const SizedBox(
            height: 2,
          ),
          // Text(
          //   controller.homeModel == null
          //       ? '0'
          //       : controller.homeModel!.numberOfNewNotifications.toString(),
          //   style: Theme.of(context).textTheme.overline,
          // )
        ],
      ),
    );
  }

  SizedBox _employeeData(BuildContext context, CustomSize customSize) {
    return SizedBox(
      width: customSize.screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: NeumorphicContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          borderRadius: BorderRadius.circular(12),
          onTab: () {},
          isInnerShadow: false,
          isEffective: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ////////////////////////////// * Data * //////////////////////////////
              _userDataItems(context),

              ////////////////////////////// * Calendar Button * //////////////////////////////
              _calendarButton(context),
            ],
          ),
        ),
      ),
    );
  }

  NeumorphicContainer _calendarButton(BuildContext context) {
    return NeumorphicContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      isInnerShadow: false,
      isEffective: true,
      duration: const Duration(milliseconds: 300),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Icon(
        Icons.calendar_today_outlined,
        color: Theme.of(context).primaryColorLight,
        size: 25,
      ),
      onTab: () {
        controller.goToCalendar();
      },
    );
  }

  Padding _chart(BuildContext context, CustomSize customSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: NeumorphicContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(12),
        onTab: () {},
        isInnerShadow: false,
        isEffective: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 14,
              children: [
                _chartTypeItem(context, Colors.brown, 'حجة'),
                _chartTypeItem(context, Colors.red, 'A'),
                _chartTypeItem(context, Colors.deepPurple, 'B'),
                _chartTypeItem(context, Colors.blue, 'C'),
                _chartTypeItem(context, Colors.green, 'X'),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: customSize.setWidth(250),
              height: customSize.setWidth(250),
              child: NeumorphicContainer(
                padding: const EdgeInsets.all(6),
                borderRadius: BorderRadius.circular(300),
                onTab: () {},
                isInnerShadow: false,
                isEffective: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: Stack(
                  children: [
                    Center(
                      child: PieChart(
                        PieChartData(
                            pieTouchData: PieTouchData(touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                controller.chartPieIndexTouched = -1;
                                return;
                              }
                              controller.chartPieIndexTouched = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;

                              controller.update();
                            }),
                            startDegreeOffset: 180,
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: showingSections()),
                      ),
                    ),
                    Center(
                      child: NeumorphicContainer(
                        padding: const EdgeInsets.all(6),
                        borderRadius: BorderRadius.circular(300),
                        onTab: () {
                          controller.goToCharts();
                        },
                        isInnerShadow: false,
                        isEffective: true,
                        duration: const Duration(milliseconds: 300),
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: Icon(
                          Icons.bar_chart_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 50,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _reports(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: SizedBox(
        width: 250,
        height: 250,
        child: GetBuilder<HomeController>(
          id: controller.buildReports,
          builder: (controllers) {
            return NeumorphicContainer(
              padding: const EdgeInsets.all(20),
              borderRadius: BorderRadius.circular(12),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onTab: () {},
              isInnerShadow: false,
              isEffective: false,
              child: controller.localReports.isEmpty
                  ? SizedBox(
                      width: 250,
                      height: 250,
                      child: Center(
                        child: Text(
                          'كل الكشوفات مسلمة',
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return _reportItem(
                            context, index, controller.localReports[index]);
                      },
                      itemCount: controller.localReports.length,
                      pagination: controller.swiperPagination,
                      controller: controller.swiperController,
                      control: controller.swiperControl,
                      scrollDirection: Axis.horizontal,
                      axisDirection: AxisDirection.left,
                      indicatorLayout: PageIndicatorLayout.COLOR,
                      // containerHeight: 200,
                      // containerWidth: 200,
                    ),
            );
          },
        ),
      ),
    );
  }

  Container _reportItem(BuildContext context, int index, Report report) {
    const spacer = SizedBox(
      height: 3,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _cardDataItem(context, Icons.person, report.name),
          spacer,
          _cardDataItem(context, Icons.location_on_outlined,
              report.region == null ? '' : report.region!.name),
          spacer,
          _cardDataItem(context, Icons.work, report.type!.name),
          spacer,
        ],
      ),
    );
  }

  Flexible _controllersButtons(BuildContext context, CustomSize customSize) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ////////////////////////////// * Controllers * //////////////////////////////
          _controllers(context, customSize),
          const SizedBox(
            height: 15,
          ),

          ////////////////////////////// * New Reports Button * //////////////////////////////
          DataHelper.user!.permission!.name == 'مدير' ||
                  DataHelper.user!.permission!.name == 'مشرف'
              ? _newReportButton(context, customSize)
              : Container(),
          const SizedBox(
            height: 15,
          ),

          ////////////////////////////// * All Reports Button * //////////////////////////////
          _allReportsButton(context, customSize),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  Padding _controllers(BuildContext context, CustomSize customSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
      child: SizedBox(
        width: customSize.setWidth(80),
        child: NeumorphicContainer(
          padding: const EdgeInsets.all(12),
          borderRadius: BorderRadius.circular(12),
          onTab: () {},
          isInnerShadow: true,
          isEffective: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ////////////////////////////// * Wifi * //////////////////////////////
              const SizedBox(
                height: 15,
              ),
              _wifiItem(context, customSize),
              const SizedBox(
                height: 30,
              ),

              ////////////////////////////// * Refresh * //////////////////////////////
              _refreshItem(context, customSize),
              const SizedBox(
                height: 30,
              ),

              ////////////////////////////// * Non Opps * //////////////////////////////
              // _nonReceivedItem(context),
              // const SizedBox(
              //   height: 30,
              // ),

              ////////////////////////////// * Non Delivered Reports * //////////////////////////////
              // _nonDeliveredReportsItem(context),
              // const SizedBox(
              //   height: 30,
              // ),

              ////////////////////////////// * Notifications * //////////////////////////////
              _notificationsItem(context, customSize),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  NeumorphicContainer _newReportButton(
      BuildContext context, CustomSize customSize) {
    return NeumorphicContainer(
      padding: EdgeInsets.all(customSize.setWidth(16)),
      borderRadius: BorderRadius.circular(12),
      isInnerShadow: false,
      isEffective: true,
      duration: const Duration(milliseconds: 300),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Icon(
        Icons.add,
        color: Theme.of(context).primaryColorLight,
        size: customSize.setWidth(32),
      ),
      onTab: () {
        controller.goToRegisterReport();
      },
    );
  }

  NeumorphicContainer _allReportsButton(
      BuildContext context, CustomSize customSize) {
    return NeumorphicContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      isInnerShadow: false,
      isEffective: true,
      duration: const Duration(milliseconds: 300),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Icon(
        Icons.file_copy,
        color: Theme.of(context).primaryColorLight,
        size: customSize.setWidth(32),
      ),
      onTab: () {
        controller.goToAllReports();
      },
    );
  }

  Flexible _userDataItems(BuildContext context) {
    const spacerWidgets = SizedBox(height: 3);

    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ////////////////////////////// * Date Time * //////////////////////////////
          Flexible(
            child: Text(
              '${getMonthArabic()}: ${DateFormat("yyyy-MM-dd").format(DateTime.now())}',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
          ),
          const SizedBox(
            height: 6,
          ),

          ////////////////////////////// * Closest time * //////////////////////////////
          Flexible(
            child: _listTitleCaption(
              context: context,
              icon: Icons.add_circle_outline,
              title:
                  '${'home_head_closest_date'.tr} ${controller.homeModel == null ? 'YYYY-MM-DD' : DateFormat('yyyy-MM-dd').format(controller.homeModel!.earliestCheckDate!)}',
            ),
          ),

          ////////////////////////////// * Achieved Total Reports * //////////////////////////////
          Flexible(
            child: _listTitleCaption(
              context: context,
              icon: Icons.done,
              title:
                  '${'home_head_total_reports'.tr} ${controller.homeModel == null ? '0' : controller.homeModel!.doneForThisWeek.abs()}', //100
            ),
          ),

          ////////////////////////////// * Remained Reports * //////////////////////////////
          Flexible(
            child: _listTitleCaption(
              context: context,
              icon: Icons.remove,
              title:
                  '${'home_head_remained_reports'.tr} ${controller.homeModel == null ? '0' : controller.homeModel!.unfinishedReports.abs()}', //30
            ),
          ),
          spacerWidgets
        ],
      ),
    );
  }

  ListTile _listTitleCaption(
      {required String title,
      required BuildContext context,
      required IconData icon,
      double iconSize = 25}) {
    return ListTile(
      horizontalTitleGap: 0,
      dense: true,
      leading: Icon(
        icon,
        size: iconSize,
        color: Theme.of(context).primaryColorLight,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.caption!,
        maxLines: 3,
        textAlign: TextAlign.start,
      ),
    );
  }

  Drawer _drawer(BuildContext context) {
    final List<Map<String, dynamic>> drawerSections = [
      {
        'text': 'إدارة الحسابات',
        'icon': Icons.account_circle_outlined,
      },
      {
        'text': 'الكشوفات الغير مسلمة',
        'icon': Icons.adjust_sharp,
      },
      {
        'text': 'الاجتماعات',
        'icon': Icons.supervisor_account_outlined,
      },
      {
        'text': 'إنشاء حساب',
        'icon': Icons.person_add_alt_1_outlined,
      },
      {
        'text': 'إدارة المناطق',
        'icon': Icons.location_on_outlined,
      },
      {
        'text': 'تسجيل الخروج',
        'icon': Icons.logout,
      },
    ];

    if (DataHelper.user!.permission!.name == 'موظف') {
      drawerSections.removeAt(0);
      drawerSections.removeAt(2);
      drawerSections.removeAt(2);
    } else if (DataHelper.user!.permission!.name == 'مشرف') {
      drawerSections.removeAt(0);
      drawerSections.removeAt(2);
    }

    //Transfer feature to reviewer
    if (DataHelper.user!.permission!.name == 'مشرف') {
      drawerSections.insert(drawerSections.length - 1,
          {'text': 'نقل الكشوفات', 'icon': Icons.reply_rounded});
    }

    //Change region of employee
    if (DataHelper.user!.permission!.name == 'موظف') {
      drawerSections.insert(drawerSections.length - 1,
          {'text': 'تغيير المنطقة', 'icon': Icons.location_searching_outlined});
    }

    return Drawer(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22), bottomLeft: Radius.circular(22))),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22), bottomLeft: Radius.circular(22)),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 25.0, 0, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ////////////////////////////// * Photo * //////////////////////////////
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: NeumorphicContainer(
                        padding: const EdgeInsets.all(4),
                        borderRadius: BorderRadius.circular(300),
                        isInnerShadow: false,
                        isEffective: true,
                        duration: const Duration(milliseconds: 250),
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        onTab: () {},
                        child: ClipOval(
                          child: OctoImage(
                            image: CachedNetworkImageProvider(
                                DataHelper.user == null
                                    ? ''
                                    : DataHelper.user!.imageUrl,
                                maxWidth: 150,
                                maxHeight: 150),
                            placeholderBuilder: (c) => Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            errorBuilder: (b, o, s) => const Center(
                              child: Icon(
                                Icons.error,
                                size: 50,
                                color: Colors.red,
                              ),
                            ),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  ////////////////////////////// * Name * //////////////////////////////
                  Text(
                    DataHelper.user == null ? '' : DataHelper.user!.name,
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  ////////////////////////////// * Buttons * //////////////////////////////
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (int i = 0; i < drawerSections.length; i++) ...[
                        _drawerItem(context, drawerSections[i]['text'],
                            drawerSections[i]['icon'], () {
                          switch (drawerSections[i]['text']) {
                            case 'إدارة الحسابات':
                              {
                                controller.goToManageAccounts();
                                break;
                              }
                            case 'الكشوفات الغير مسلمة':
                              {
                                controller.goToNonDeliveredReports();
                                break;
                              }
                            case 'الاجتماعات':
                              {
                                controller.goToMeetings();
                                break;
                              }
                            case 'إنشاء حساب':
                              {
                                controller.goToRegisterAccount();
                                break;
                              }
                            case 'إدارة المناطق':
                              {
                                controller.goToManageRegions();
                                break;
                              }
                            case 'نقل الكشوفات':
                              {
                                TransferReportsReviewerBottomSheet.showDialog(
                                    context, controller);
                                break;
                              }
                            case 'تسجيل الخروج':
                              {
                                showDialogLogout(context);
                                break;
                              }
                            case 'تغيير المنطقة':
                              {
                                ChangeRegionBottomSheet.showDialog(
                                    context, controller);
                                break;
                              }
                          }
                        }),
                      ]
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _drawerItem(
      BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: NeumorphicContainer(
        padding: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(12),
        isInnerShadow: false,
        isEffective: true,
        duration: const Duration(milliseconds: 250),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onTab: onTap,
        child: Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 15,
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.button,
                textAlign: TextAlign.start,
                maxLines: 1,
              ),
              Icon(
                icon,
                size: 30,
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  void showDialogLogout(BuildContext context) {
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
            'تسجيل الخروج',
            style: Theme.of(context).textTheme.headline6,
          ),
          content: Text(
            'هل تريد الخروج من هذا الحساب ؟',
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
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                controller.logoutAccount();
              },
            ),

            // Cancel
            TextButton(
              style: TextButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.all(4),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              child: Text(
                'dialog_cancel'.tr,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.red),
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

  String getMonthArabic() {
    switch (DateTime.now().month) {
      case 1:
        {
          return 'كانون الثاني';
        }
      case 2:
        {
          return 'شباط';
        }
      case 3:
        {
          return 'آذار';
        }
      case 4:
        {
          return 'نيسان';
        }
      case 5:
        {
          return 'أيار';
        }
      case 6:
        {
          return 'حزيران';
        }
      case 7:
        {
          return 'تموز';
        }
      case 8:
        {
          return 'آب';
        }
      case 9:
        {
          return 'أيلول';
        }
      case 10:
        {
          return 'تشرين الأول';
        }
      case 11:
        {
          return 'تشرين الثاني';
        }
      case 12:
        {
          return 'كانون الأول';
        }
      default:
        {
          return 'شباط';
        }
    }
  }
}
