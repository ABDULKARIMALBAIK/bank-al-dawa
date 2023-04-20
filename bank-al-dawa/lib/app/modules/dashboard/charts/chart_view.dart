import 'package:bank_al_dawa/app/core/constants/colors.dart';
import 'package:bank_al_dawa/app/core/services/size_configration.dart';
import 'package:bank_al_dawa/app/core/widgets/neumorphic_container.dart';
import 'package:bank_al_dawa/app/core/widgets/widget_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chart_controller.dart';

class ChartView extends GetView<ChartController> {
  const ChartView({Key? key}) : super(key: key);

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
                            // customSize.setHeight(50)
                            50,
                            'chart_title'.tr),
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

              ////////////////////////////// *  Print Button * //////////////////////////////
              Align(
                alignment: Alignment.centerLeft,
                child: _buttonDate(context),
              ),
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

  SizedBox _buttonDate(BuildContext context) {
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
            Icons.calendar_today_outlined,
            size: 24,
            color: controller.isDark ? Colors.black54 : Colors.white,
          ),
        ),
        onPressed: () {
          _showDatePickerDialog(context);
        },
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
                ////////////////////////////// * Tap Bar Item * //////////////////////////////
                _tabBarItem(context),
                const SizedBox(
                  height: 20,
                ),

                ////////////////////////////// * First Pie Chart Item * //////////////////////////////
                _pieFirstChartItem(context),
                // _chartItem(context),
                const SizedBox(
                  height: 20,
                ),

                ////////////////////////////// *  First Pie Types Item * //////////////////////////////
                _typesFirstChartItem(context),
                const SizedBox(
                  height: 20,
                ),

                ////////////////////////////// * Second Pie Chart Item * //////////////////////////////
                _pieSecondChartItem(context),
                // _chartItem(context),
                const SizedBox(
                  height: 20,
                ),

                ////////////////////////////// * Second Pie Types Item * //////////////////////////////
                _typesSecondChartItem(context),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
    );
  }

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

  ScreenSizer _tabBarItem(BuildContext context) {
    const Duration durationAnimation = Duration(milliseconds: 150);

    return ScreenSizer(
      builder: (customSize) {
        final double indicatorWidth =
            (customSize.screenWidth - 12 * 2) / types.length;
        return StatefulBuilder(
          builder: (context, StateSetter setAnimation) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: NeumorphicContainer(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.all(10),
                isEffective: false,
                isInnerShadow: true,
                duration: Duration.zero,
                borderRadius: BorderRadius.circular(18),
                onTab: () {},
                child: Stack(
                  children: [
                    ////////////////////////////// * check states * //////////////////////////////
                    AnimatedPositionedDirectional(
                      start: indicatorWidth *
                          controller
                              .selectedType, //controller.checkStatesSelected == 0 ? indicatorWidth * controller.checkStatesSelected :
                      bottom: 0,
                      top: 0,
                      duration: durationAnimation,
                      child: SizedBox(
                        width: indicatorWidth,
                        height: 90,
                        child: NeumorphicContainer(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          padding: const EdgeInsets.all(4),
                          isEffective: false,
                          isInnerShadow: false,
                          duration: durationAnimation,
                          borderRadius: BorderRadius.circular(18),
                          onTab: () {},
                          child: const SizedBox(),
                        ),
                      ),
                    ),

                    ////////////////////////////// * Items * //////////////////////////////
                    Positioned.fill(
                      child: Row(
                        children: List.generate(
                            types.length,
                            (index) => Expanded(
                                  child: GestureDetector(
                                    onTap: () => setAnimation(
                                        () => controller.selectedType = index),
                                    child: AnimatedDefaultTextStyle(
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              color: index ==
                                                      controller.selectedType
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .color),
                                      duration: durationAnimation,
                                      child: Text(
                                        types[index],
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                )),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ignore: unused_element
  StateBuilder<ChartController> _chartItem(BuildContext context) {
    late List<BarChartGroupData> rawBarGroups;
    late List<BarChartGroupData> showingBarGroups;

    final barGroup1 =
        makeGroupData(0, aData: 10, bData: 8, cData: 3, xData: 5, okData: 2);

    final barGroup2 =
        makeGroupData(0, aData: 6, bData: 2, cData: 10, xData: 4, okData: 6);

    final barGroup3 =
        makeGroupData(0, aData: 10, bData: 5, cData: 3, xData: 8, okData: 4);

    final barGroup4 =
        makeGroupData(0, aData: 2, bData: 6, cData: 3, xData: 9, okData: 7);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;

    int touchedGroupIndex = -1;

    return StateBuilder<ChartController>(
      key: UniqueKey(),
      id: 'not_used',
      disableState: true,
      onRetryFunction: () {},
      // noResultView: ,
      // loadingView: ,
      // errorView: ,
      initialWidgetState: WidgetState.loading,
      builder: (widgetState, controllers) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 400,
            child: BarChart(BarChartData(
              maxY: 20,
              barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.grey,
                    getTooltipItem: (a, b, c, d) => null,
                  ),
                  touchCallback: (FlTouchEvent event, response) {
                    if (response == null || response.spot == null) {
                      touchedGroupIndex = -1;
                      showingBarGroups = List.of(rawBarGroups);
                      controller.updateState([], WidgetState.loaded);
                      return;
                    }

                    touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                    if (!event.isInterestedForInteractions) {
                      touchedGroupIndex = -1;
                      showingBarGroups = List.of(rawBarGroups);
                      return;
                    }
                    showingBarGroups = List.of(rawBarGroups);
                    if (touchedGroupIndex != -1) {
                      var sum = 0.0;
                      for (var rod
                          in showingBarGroups[touchedGroupIndex].barRods) {
                        sum += rod.toY;
                      }
                      final avg = sum /
                          showingBarGroups[touchedGroupIndex].barRods.length;

                      showingBarGroups[touchedGroupIndex] =
                          showingBarGroups[touchedGroupIndex].copyWith(
                        barRods: showingBarGroups[touchedGroupIndex]
                            .barRods
                            .map((rod) {
                          return rod.copyWith(toY: avg);
                        }).toList(),
                      );
                    }

                    controller.updateState([], WidgetState.loaded);
                  }),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) =>
                        bottomTitles(value, meta, context),
                    reservedSize: 42,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1,
                    getTitlesWidget: (value, meta) =>
                        leftTitles(value, meta, context),
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: showingBarGroups,
              gridData: FlGridData(show: false),
            )),
          ),
        );
      },
    );
  }

  SizedBox _pieFirstChartItem(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: StateBuilder<ChartController>(
        key: UniqueKey(),
        id: controller.buildFirstChartItem,
        disableState: false,
        onRetryFunction: () {
          controller.loadDataFirstChart();
        },
        // noResultView: ,
        loadingView: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          )),
        ),
        // errorView: ,
        initialWidgetState: WidgetState.loading,
        builder: (widgetState, controllers) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: (controller.firstPieChartModel.alibiCount == 0 &&
                    controller.firstPieChartModel.alibiPlusCount == 0 &&
                    controller.firstPieChartModel.doneCount == 0 &&
                    controller.firstPieChartModel.unfinishedReports == 0)
                ? Center(
                    child: Text(
                      'لا يوجد بيانات لعرضها في هذا التاريخ',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  )
                : PieChart(
                    PieChartData(
                        pieTouchData: PieTouchData(touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            controller.firstTouchedIndex = -1;
                            return;
                          }
                          controller.firstTouchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;

                          controller.updateState(
                              [controller.buildFirstChartItem],
                              WidgetState.loaded);
                        }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingFirstChartSections()),
                  ),
          );
        },
      ),
    );
  }

  SizedBox _pieSecondChartItem(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: StateBuilder<ChartController>(
        key: UniqueKey(),
        id: controller.buildSecondChartItem,
        disableState: false,
        onRetryFunction: () {
          controller.loadDataSecondChart();
        },
        // noResultView: ,
        loadingView: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          )),
        ),
        // errorView: ,
        initialWidgetState: WidgetState.loading,
        builder: (widgetState, controllers) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: (controller.secondPieChartModel.aCount == 0 &&
                    controller.secondPieChartModel.bCount == 0 &&
                    controller.secondPieChartModel.cCount == 0 &&
                    controller.secondPieChartModel.dCount == 0 &&
                    controller.secondPieChartModel.xCount == 0)
                ? Center(
                    child: Text(
                      'لا يوجد بيانات لعرضها في هذا التاريخ',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  )
                : PieChart(
                    PieChartData(
                        pieTouchData: PieTouchData(touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            controller.secondTouchedIndex = -1;
                            return;
                          }
                          controller.secondTouchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;

                          controller.updateState(
                              [controller.buildSecondChartItem],
                              WidgetState.loaded);
                        }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSecondChartSections()),
                  ),
          );
        },
      ),
    );
  }

  List<PieChartSectionData> showingFirstChartSections() {
    return List.generate(4, (i) {
      final isTouched = i == controller.firstTouchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: controller.firstPieChartModel.alibiCount.abs().toDouble(),
            title: controller.firstPieChartModel.alibiCount.abs().toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.deepPurple,
            value:
                controller.firstPieChartModel.alibiPlusCount.abs().toDouble(),
            title:
                controller.firstPieChartModel.alibiPlusCount.abs().toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.blue,
            value: controller.firstPieChartModel.doneCount.abs().toDouble(),
            title: controller.firstPieChartModel.doneCount.abs().toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: controller.firstPieChartModel.unfinishedReports
                .abs()
                .toDouble(),
            title: controller.firstPieChartModel.unfinishedReports
                .abs()
                .toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }

  List<PieChartSectionData> showingSecondChartSections() {
    return List.generate(5, (i) {
      final isTouched = i == controller.secondTouchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.purple,
            value: controller.secondPieChartModel.aCount.abs().toDouble(),
            title: controller.secondPieChartModel.aCount.abs().toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.brown,
            value: controller.secondPieChartModel.bCount.abs().toDouble(),
            title: controller.secondPieChartModel.bCount.abs().toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.yellow,
            value: controller.secondPieChartModel.cCount.abs().toDouble(),
            title: controller.secondPieChartModel.cCount.abs().toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.orange,
            value: controller.secondPieChartModel.dCount.abs().toDouble(),
            title: controller.secondPieChartModel.dCount.abs().toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.cyan,
            value: controller.secondPieChartModel.xCount.abs().toDouble(),
            title: controller.secondPieChartModel.xCount.abs().toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }

  Widget leftTitles(double value, TitleMeta meta, BuildContext context) {
    final style = TextStyle(
      color: Theme.of(context).textTheme.caption!.color,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String text = '';

    if (value == 0) {
      text = '10';
    } else if (value == 10) {
      text = '20';
    } else if (value == 19) {
      text = '40';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta, BuildContext context) {
    final style = TextStyle(
      color: Theme.of(context).textTheme.caption!.color,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
          'Mn',
          style: style,
        );
        break;
      case 1:
        text = Text(
          'Te',
          style: style,
        );
        break;
      case 2:
        text = Text(
          'Wd',
          style: style,
        );
        break;
      case 3:
        text = Text(
          'Tu',
          style: style,
        );
        break;
      default:
        text = Text(
          '',
          style: style,
        );
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartGroupData makeGroupData(
    int x, {
    required double aData,
    required double bData,
    required double cData,
    required double xData,
    required double okData,
  }) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        toY: aData,
        color: colorA,
        width: width, //width
      ),
      BarChartRodData(
        toY: bData,
        color: colorB,
        width: width, //width
      ),
      BarChartRodData(
        toY: cData,
        color: colorC,
        width: width, //width
      ),
      BarChartRodData(
        toY: xData,
        color: colorX,
        width: width, //width
      ),
      BarChartRodData(
        toY: okData,
        color: colorHAG,
        width: width, //width
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }

  Padding _typesFirstChartItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 15,
            children: [
              _chartTypeItem(context, Colors.red, 'حجة'),
              _chartTypeItem(context, Colors.deepPurple, '+حجة'),
              _chartTypeItem(context, Colors.blue, 'تم'),
              _chartTypeItem(context, Colors.green, 'لم يتم'),
            ],
          ),
        ),
      ),
    );
  }

  Padding _typesSecondChartItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 15,
            children: [
              _chartTypeItem(context, Colors.purple, 'A'),
              _chartTypeItem(context, Colors.brown, 'B'),
              _chartTypeItem(context, Colors.yellow, 'C'),
              _chartTypeItem(context, Colors.orange, 'D'),
              _chartTypeItem(context, Colors.cyan, 'X'),
            ],
          ),
        ),
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

  Future<void> _showDatePickerDialog(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale('en'),
        initialDate: DateTime.now().subtract(const Duration(days: 7)),
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2021),
        lastDate: DateTime.now().subtract(const Duration(days: 7)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                    primary: Theme.of(context).primaryColor,
                    onPrimary: Colors.white,
                    onSurface: Theme.of(context).primaryColor),
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor))),
            child: child!,
          );
        });

    if (picked != null) {
      //&& picked != selectedDate

      controller.selectedDateTime = picked;
      await controller.loadDataFirstChart();
      Future.delayed(const Duration(microseconds: 1000));
      await controller.loadDataSecondChart();
    }
  }
}

const colorHAG = Colors.brown;
const colorA = Colors.red;
const colorB = Colors.deepPurple;
const colorC = Colors.blue;
const colorX = Colors.green;
const double width = 7;

List<String> types = [
  'chart_type_week'.tr,
  'chart_type_month'.tr,
  'chart_type_year'.tr,
];
