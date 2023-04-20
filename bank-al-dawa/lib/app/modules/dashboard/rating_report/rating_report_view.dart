import 'package:bank_al_dawa/app/core/constants/colors.dart';
import 'package:bank_al_dawa/app/core/models/report_models/report_log_model.dart';
import 'package:bank_al_dawa/app/core/services/size_configration.dart';
import 'package:bank_al_dawa/app/core/widgets/neumorphic_container.dart';
import 'package:bank_al_dawa/app/core/widgets/toast.dart';
import 'package:bank_al_dawa/app/modules/dashboard/rating_report/rating_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/bottom_sheet/phone_bottom_sheet.dart';

class RatingReportView extends GetView<RatingReportController> {
  const RatingReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RatingReportController>(
      builder: (c) {
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
                                'rating_report_title'.tr)
                          ];
                        },
                        body: _body(context, customSize.screenWidth,
                            customSize.screenHeight, customSize)),
                  );
                },
              )),
        );
      },
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
            child: Align(
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
            )),
      ),
    );
  }

  Container _body(BuildContext context, double widget, double height,
      CustomSize customSize) {
    return Container(
      width: widget,
      height: height,
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

            ////////////////////////////// * User Data * //////////////////////////////
            _userData(context, widget, customSize),
            const SizedBox(
              height: 25,
            ),

            ////////////////////////////// * Employee Data * //////////////////////////////
            _employeeData(context, widget, customSize),
            const SizedBox(
              height: 30,
            ),

            ////////////////////////////// * Old Ratings * //////////////////////////////
            _oldRatings(context, widget),
            const SizedBox(
              height: 30,
            ),

            ////////////////////////////// * Data Type * //////////////////////////////
            _typesPageView(context, widget),
            const SizedBox(
              height: 30,
            ),

            ////////////////////////////// * Status Report * //////////////////////////////
            _completePageView(context, widget),
            // _checkStates(context),
            const SizedBox(
              height: 15,
            ),

            ////////////////////////////// * Note Textfield * //////////////////////////////
            NeumorphicContainer(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              borderRadius: BorderRadius.circular(16),
              onTab: () {},
              isInnerShadow: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: CauseTextField(controller),
            ),
            const SizedBox(
              height: 15,
            ),

            ////////////////////////////// * Check At Date * //////////////////////////////
            _checkAtDate(context, widget),

            ////////////////////////////// * Submit Button * //////////////////////////////
            controller.isFromNonDeliveredReports
                ? const SizedBox()
                : _submitButton(context),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  GetBuilder _checkStates(BuildContext context) {
    const Duration durationAnimation = Duration(milliseconds: 150);

    return GetBuilder<RatingReportController>(
      id: 'updateTypeResult',
      builder: (controllers) {
        return ScreenSizer(
          builder: (customSize) {
            final double indicatorWidth =
                (customSize.screenWidth - 12 * 2) / status.length;
            return StatefulBuilder(
              builder: (context, StateSetter setAnimation) {
                return SizedBox(
                  width: customSize
                      .screenWidth, //MediaQuery.of(context).size.width
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
                                  .checkStatusSelected, //controller.checkStatesSelected == 0 ? indicatorWidth * controller.checkStatesSelected :
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
                                status.length,
                                (index) => Expanded(
                                      child: GestureDetector(
                                        onTap: () => setAnimation(() =>
                                            controller.checkStatusSelected =
                                                index),
                                        child: AnimatedDefaultTextStyle(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                  color: index ==
                                                          controller
                                                              .checkStatusSelected
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .bodyText2!
                                                          .color),
                                          duration: durationAnimation,
                                          child: Text(
                                            status[index],
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
      },
    );
  }

  SizedBox _userData(
      BuildContext context, double screenWidth, CustomSize customSize) {
    const spacerWidgets = SizedBox(
      height: 3,
    );

    return SizedBox(
      width: screenWidth, //MediaQuery.of(context).size.width
      child: NeumorphicContainer(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        borderRadius: BorderRadius.circular(16),
        onTab: () {},
        isInnerShadow: false,
        isEffective: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ////////////////////////////// * User Name * //////////////////////////////
            _listTitleOne(context),
            spacerWidgets,

            ////////////////////////////// * User Location * //////////////////////////////
            _listTitleSecond(context),
            spacerWidgets,

            ////////////////////////////// * User Data 1 * //////////////////////////////
            _listTitleRow(
              firstWidget: Flexible(
                  child: _listTitleCaption(
                      screenWidth: screenWidth,
                      context: context,
                      maxLines: 2,
                      icon: Icons.calendar_today_outlined,
                      title: 'تاريخ اضافة الكشف',
                      subtitle: controller.createReportDate,
                      customSize: customSize)),
              secondWidget: Flexible(
                  child: _listTitleCaption(
                      screenWidth: screenWidth,
                      context: context,
                      icon: Icons.date_range,
                      title: 'آخر تعديل للكشف',
                      subtitle: controller.updateDate,
                      customSize: customSize,
                      maxLines: 2)),
            ),
            spacerWidgets,

            ////////////////////////////// * User Data 2 * //////////////////////////////
            _listTitleRow(
              firstWidget: Flexible(
                  child: _listTitleCaption(
                      screenWidth: screenWidth,
                      context: context,
                      maxLines: 2,
                      icon: Icons.phone,
                      customSize: customSize,
                      title: 'رقم الهاتف',
                      subtitle: controller.phoneNumber,
                      onTap: () {
                        if (controller.phoneNumber.isNotEmpty) {
                          PhoneBottomSheet.showPickerDialog(
                              context, controller.phoneNumber,
                              ratingReportController: controller);
                        }
                      })),
              secondWidget: Flexible(
                  child: _listTitleCaption(
                screenWidth: screenWidth,
                context: context,
                icon: Icons.work,
                maxLines: 2,
                customSize: customSize,
                title: 'النوع',
                subtitle: controller.type,
              )),
            ),
            spacerWidgets,

            ////////////////////////////// * User Data 3 * //////////////////////////////
            _listTitleRow(
              firstWidget: Flexible(
                  child: _listTitleCaption(
                      screenWidth: screenWidth,
                      context: context,
                      icon: Icons.phone_android,
                      title: 'رقم الهاتف الاختياري',
                      maxLines: 2,
                      customSize: customSize,
                      subtitle: controller.phoneNumberOptional,
                      onTap: () {
                        if (controller.phoneNumberOptional.isNotEmpty) {
                          PhoneBottomSheet.showPickerDialog(
                              context, controller.phoneNumberOptional,
                              ratingReportController: controller);
                        }
                      })),
              secondWidget: Flexible(
                  child: _listTitleCaption(
                      screenWidth: screenWidth,
                      context: context,
                      icon: Icons.note,
                      title: 'ملاحظة',
                      subtitle: controller.noteText,
                      customSize: customSize,
                      maxLines: 3)),
            ),
            spacerWidgets,

            ////////////////////////////// * Coming date * //////////////////////////////
            Flexible(
              child: _listTitleCaption(
                  screenWidth: screenWidth,
                  context: context,
                  icon: Icons.edit,
                  title: 'تاريخ قدوم المريض للجمعية',
                  subtitle: controller.checkDate,
                  customSize: customSize,
                  maxLines: 2),
            ),
            spacerWidgets,
          ],
        ),
      ),
    );
  }

  SizedBox _employeeData(
      BuildContext context, double screenWidth, CustomSize customSize) {
    return SizedBox(
      width: screenWidth, //MediaQuery.of(context).size.width,
      child: NeumorphicContainer(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        borderRadius: BorderRadius.circular(16),
        onTab: () {},
        isInnerShadow: false,
        isEffective: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ////////////////////////////// * Employee Data * //////////////////////////////
            Flexible(
              child: _listTitleCaption(
                screenWidth: screenWidth,
                context: context,
                customSize: customSize,
                icon: Icons.account_circle_outlined,
                iconSize: 35,
                maxLines: 2,
                title: 'اسم الموظف',
                subtitle: controller.employeeName, //'محمد مروش'
              ),
            ),

            ////////////////////////////// * Line Divider * //////////////////////////////
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 1.5,
                height: 90,
                color: Theme.of(context).primaryColorLight,
              ),
            ),

            ////////////////////////////// * Column Data * //////////////////////////////
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ////////////////////////////// * Date * //////////////////////////////
                  _listTitleCaption(
                    screenWidth: screenWidth,
                    context: context,
                    maxLines: 2,
                    customSize: customSize,
                    icon: Icons.calendar_today_outlined,
                    title: 'تاريخ النتيجة',
                    subtitle: controller.resultDate, //'20-05-2022'
                  ),

                  ////////////////////////////// * Result * //////////////////////////////
                  _listTitleCaption(
                    screenWidth: screenWidth,
                    context: context,
                    icon: Icons.edit,
                    maxLines: 2,
                    title: 'النتيجة',
                    customSize: customSize,
                    subtitle: controller.result, //'X'
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _typesPageView(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      child: SizedBox(
        width: screenWidth, //MediaQuery.of(context).size.width,
        child: NeumorphicContainer(
          padding: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(16),
          onTab: () {},
          isInnerShadow: false,
          isEffective: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: NeumorphicContainer(
            padding: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(16),
            onTab: () {},
            isInnerShadow: true,
            isEffective: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: SizedBox(
              width: screenWidth, // MediaQuery.of(context).size.width,
              height: 50,
              child: Center(
                child: PageView.builder(
                  controller: controller.pageControllerType,
                  itemCount: types.length, // types.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Text(
                        types[index],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _submitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: NeumorphicContainer(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
        borderRadius: BorderRadius.circular(11),
        isInnerShadow: false,
        isEffective: true,
        duration: const Duration(milliseconds: 300),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Text(
          'rating_report_button'.tr,
          style: Theme.of(context).textTheme.bodyText1,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
        onTab: () {
          controller.submitResult();
        },
      ),
    );
  }

  ListTile _listTitleOne(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.person,
        size: 25,
        color: Theme.of(context).primaryColorLight,
      ),
      title: Text(
        controller.patientName,
        style: Theme.of(context).textTheme.subtitle1,
        maxLines: 1,
        textAlign: TextAlign.start,
      ),
    );
  }

  ListTile _listTitleSecond(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.location_on_outlined,
        size: 25,
        color: Theme.of(context).primaryColorLight,
      ),
      title: Text(
        controller.region,
        style: Theme.of(context).textTheme.subtitle2!,
        maxLines: 1,
        textAlign: TextAlign.start,
      ),
      subtitle: Text(
        controller.detailsAddress,
        style: Theme.of(context).textTheme.caption!,
        maxLines: 2,
        textAlign: TextAlign.start,
      ),
    );
  }

  SizedBox _listTitleCaption(
      {required double screenWidth,
      required String title,
      required String subtitle,
      required BuildContext context,
      required IconData icon,
      required CustomSize customSize,
      Function()? onTap,
      int? maxLines = 1,
      double iconSize = 25}) {
    return SizedBox(
      width: screenWidth,
      child: GestureDetector(
        onTap: onTap,
        child: ListTile(
          leading: Icon(
            icon,
            size: iconSize,
            color: Theme.of(context).primaryColorLight,
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.caption!,
            maxLines: maxLines,
            textAlign: TextAlign.start,
          ),
          subtitle: Text(
            overflow: TextOverflow.clip,
            subtitle,
            style: Theme.of(context).textTheme.overline!.copyWith(
                fontSize: screenWidth >= 411
                    ? 10.0
                    : 10.0 - ((411 / screenWidth).ceil() + 1),
                foreground: Paint()
                  ..style = PaintingStyle.fill
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1),
            maxLines: maxLines,
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }

  Row _listTitleRow(
      {required Widget firstWidget, required Widget secondWidget}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        firstWidget,
        const SizedBox(
          width: 15,
        ),
        secondWidget,
      ],
    );
  }

  Padding _completePageView(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: SizedBox(
        width: screenWidth, //MediaQuery.of(context).size.width,
        height: 68,
        child: Center(
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.pageControllerComplete,
            scrollDirection: Axis.horizontal,
            children: [
              //No Rating
              Center(
                child: Text(
                  'rating_report_no_rating'.tr,
                  style: Theme.of(context).textTheme.headline6,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),

              //Rating
              Center(child: _checkStates(context)),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   mainAxisSize: MainAxisSize.min,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [

              //     const SizedBox(
              //       height: 15,
              //     ),
              //     NeumorphicContainer(
              //       padding:
              //           const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              //       borderRadius: BorderRadius.circular(16),
              //       onTab: () {},
              //       isInnerShadow: true,
              //       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              //       child: ReasonTextField(controller),
              //     ),
              //   ],
              // ),

              //Reason
              Center(
                child: NeumorphicContainer(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  borderRadius: BorderRadius.circular(16),
                  onTab: () {},
                  isInnerShadow: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: ReasonTextField(controller),
                ),
              ),

              //Reason +
              Center(
                child: NeumorphicContainer(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  borderRadius: BorderRadius.circular(16),
                  onTab: () {},
                  isInnerShadow: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: ReasonPlusTextField(controller),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _oldRatings(BuildContext context, double width) {
    if (controller.reportLogs.isEmpty) {
      return const SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ////////////////////////////// * Title Old Ratings * /////////////////////////////
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text('التقييمات',
                    style: Theme.of(context).textTheme.headline6,
                    maxLines: 1,
                    textAlign: TextAlign.start),
              ),

              ////////////////////////////// * List Old Ratings * /////////////////////////////
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: width,
                  height: 255,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.reportLogs.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _itemRatingLog(context, index,
                            controller.reportLogs[index], width);
                      }),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget _itemRatingLog(
      BuildContext context, int index, ReportLog reportLog, double width) {
    print('length_${status.length}');
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: width - 70,
        // height: 190,
        child: NeumorphicContainer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
          isEffective: true,
          isInnerShadow: false,
          duration: const Duration(milliseconds: 300),
          borderRadius: BorderRadius.circular(10),
          onTab: () {},
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ////////////////////////////// * Result * /////////////////////////////
                  const SizedBox(
                    height: 10,
                  ),
                  Text('النتيجة: ${reportLog.result!.name}',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.start,
                      maxLines: 1),
                  const SizedBox(
                    height: 10,
                  ),

                  ////////////////////////////// * Type OR details * /////////////////////////////

                  if (reportLog.result!.name != 'لم يتم الكشف') ...[
                    Text(
                        // (reportLog.details.trim().isEmpty || reportLog.details == " ")
                        reportLog.result!.name == 'تم'
                            ? "النمط: ${reportLog.result!.type}"
                            : "السبب: ${reportLog.details}",
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.start,
                        maxLines: 2),
                    const SizedBox(
                      height: 10,
                    ),
                  ],

                  ////////////////////////////// * Type OR details * /////////////////////////////
                  Text(
                      reportLog.note.isEmpty
                          ? 'الملاحظة: لا شيء'
                          : 'الملاحظة: ${reportLog.note}',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.start,
                      maxLines: 2),
                  const SizedBox(
                    height: 10,
                  ),

                  ////////////////////////////// * Date * /////////////////////////////
                  Text(
                      'التاريخ: ${DateFormat("yyyy-MM-dd").format(reportLog.date)}',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.start,
                      maxLines: 1),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _checkAtDate(BuildContext context, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Row(
        children: [
          Flexible(
            child: NeumorphicContainer(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              borderRadius: BorderRadius.circular(16),
              onTab: () {
                controller.checkAtDateController.clear();
              },
              isInnerShadow: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: TextFormField(
                enabled: false,
                controller: controller.checkAtDateController,
                enableSuggestions: true,
                readOnly: false,
                autofocus: false,
                maxLines: 1,
                autocorrect: true,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1, //TextStyle(color: Colors.black.withOpacity(0.9)),
                textInputAction: TextInputAction.done,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .color!
                            .withOpacity(0.5)),
                    labelStyle: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .color!
                            .withOpacity(0.5)),
                    errorStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w200),
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(15),
                    //     borderSide: BorderSide(
                    //         color: Theme.of(context).primaryColor, width: 1)),
                    // focusedBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(15),
                    //     borderSide: BorderSide(
                    //         color: Theme.of(context).primaryColor, width: 1)),
                    // enabledBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(15),
                    //     borderSide: BorderSide(
                    //         color: Theme.of(context).primaryColor, width: 1)),
                    labelText: 'تاريخ قدوم المريض',
                    hintText: 'تاريخ قدوم المريض',
                    floatingLabelBehavior: FloatingLabelBehavior.never, //always
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Icon(
                          Icons.date_range,
                          color: Theme.of(context).primaryColor,
                        ))),
                keyboardType: TextInputType.text,
                // inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
                // ],
                // validator: (search) {
                //   if (search == null || search.isEmpty) {
                //     return 'all_reports_user_textField_empty'.tr;
                //   }
                //   return null;
                // },
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          SizedBox(
            width: 65,
            height: 65,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(12),
                  primary: Theme.of(context).primaryColor,
                  shadowColor: Colors.black54),
              child: const Center(
                child: Icon(
                  Icons.edit,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                if (controller.checkStatusSelected != 3) {
                  controller.showDatePickerDialog(context);
                } else {
                  CustomToast.showDefault(
                      'لا يمكن تحديد موعد قدوم المريض في حال تقييم النتيجة بـ X ');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

List<String> types = [
  'لم يتم الكشف',
  'تم الكشف',
  'حجة',
  'حجة+',
];

List<String> status = [
  'A',
  'B',
  'C',
  'X',
  'تم',
];

/* Reason TextField Class */

// ignore: must_be_immutable
class ReasonTextField extends StatelessWidget {
  ReasonTextField(this.controller, {Key? key}) : super(key: key);

  RatingReportController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.reasonController,
      enableSuggestions: true,
      readOnly: false,
      autocorrect: true,
      style: Theme.of(context).textTheme.subtitle1,
      textInputAction: TextInputAction.done,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
          hintStyle: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .color!
                  .withOpacity(0.5)),
          labelStyle: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .color!
                  .withOpacity(0.5)),
          errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w200),
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(15),
          //     borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1)
          // ),
          // focusedBorder:  OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(15),
          //     borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1)
          // ),
          // enabledBorder:  OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(15),
          //     borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1)
          // ),
          labelText: 'rating_report_textField_reason_label'.tr,
          hintText: 'rating_report_textField_reason_hint'.tr,
          floatingLabelBehavior: FloatingLabelBehavior.never, //always
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Icon(
                Icons.error,
                color: Theme.of(context).primaryColor,
              ))),
      keyboardType: TextInputType.text,
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
      // ],
      // validator: (name) {
      //   if (name == null || name.isEmpty) {
      //     return 'register_username_empty'.tr;
      //   }
      //   return null;
      // },
    );
  }
}

/* Reason Plus TextField Class */

// ignore: must_be_immutable
class ReasonPlusTextField extends StatelessWidget {
  ReasonPlusTextField(this.controller, {Key? key}) : super(key: key);

  RatingReportController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.reasonPlusController,
      enableSuggestions: true,
      readOnly: false,
      autocorrect: true,
      style: Theme.of(context).textTheme.subtitle1,
      textInputAction: TextInputAction.done,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
          hintStyle: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .color!
                  .withOpacity(0.5)),
          labelStyle: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .color!
                  .withOpacity(0.5)),
          errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w200),
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(15),
          //     borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1)
          // ),
          // focusedBorder:  OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(15),
          //     borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1)
          // ),
          // enabledBorder:  OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(15),
          //     borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1)
          // ),
          labelText: 'rating_report_textField_reason_plus_label'.tr,
          hintText: 'rating_report_textField_reason_plus_hint'.tr,
          floatingLabelBehavior: FloatingLabelBehavior.never, //always
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Icon(
                Icons.error_outline,
                color: Theme.of(context).primaryColor,
              ))),
      keyboardType: TextInputType.text,
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
      // ],
      // validator: (name) {
      //   if (name == null || name.isEmpty) {
      //     return 'register_username_empty'.tr;
      //   }
      //   return null;
      // },
    );
  }
}

/* Cause TextField Class */

// ignore: must_be_immutable
class CauseTextField extends StatelessWidget {
  CauseTextField(this.controller, {Key? key}) : super(key: key);

  RatingReportController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.causeController,
      maxLines: 1,
      enableSuggestions: true,
      readOnly: false,
      autocorrect: true,
      style: Theme.of(context).textTheme.subtitle1,
      textInputAction: TextInputAction.done,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
          hintStyle: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .color!
                  .withOpacity(0.5)),
          labelStyle: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .color!
                  .withOpacity(0.5)),
          errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w200),
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(15),
          //     borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1)
          // ),
          // focusedBorder:  OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(15),
          //     borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1)
          // ),
          // enabledBorder:  OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(15),
          //     borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1)
          // ),
          labelText: 'كتابة ملاحظة',
          hintText: 'كتابة ملاحظة',
          floatingLabelBehavior: FloatingLabelBehavior.never, //always
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Icon(
                Icons.error_outline,
                color: Theme.of(context).primaryColor,
              ))),
      keyboardType: TextInputType.text,
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
      // ],
      // validator: (name) {
      //   if (name == null || name.isEmpty) {
      //     return 'register_username_empty'.tr;
      //   }
      //   return null;
      // },
    );
  }
}
