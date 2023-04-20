import 'package:bank_al_dawa/app/core/constants/colors.dart';
import 'package:bank_al_dawa/app/core/services/size_configration.dart';
import 'package:bank_al_dawa/app/core/widgets/neumorphic_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_choices/search_choices.dart';

import '../../../core/helper/data_helper.dart';
import 'register_report_controller.dart';

class RegisterReportView extends GetView<RegisterReportController> {
  const RegisterReportView({Key? key}) : super(key: key);

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
                        _header(context, customSize.screenWidth, 50
                            // customSize.setHeight(50)
                            )
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
      BuildContext context, double width, double height) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              ////////////////////////////// *  Title * //////////////////////////////
              GetBuilder<RegisterReportController>(
                id: controller.titleId,
                builder: (controllers) {
                  return _headerText(
                      context,
                      controller.isFromNonHome
                          ? 'edit_report_title'.tr
                          : 'register_report_title'.tr);
                },
              ),

              ////////////////////////////// *  Print Button * //////////////////////////////
              Visibility(
                visible: false,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _buttonSave(context),
                ),
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

  Container _body(BuildContext context, double widget, double height) {
    const spacerWidgets = SizedBox(
      height: 25,
    );

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
              height: 25,
            ),

            ////////////////////////////// * TextFields Validator * //////////////////////////////
            SizedBox(
              width: widget,
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ////////////////////////////// * Username * //////////////////////////////
                    UserNameTextField(controller),
                    // NeumorphicContainer(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 4, vertical: 1),
                    //   borderRadius: BorderRadius.circular(16),
                    //   onTab: () {},
                    //   isInnerShadow: true,
                    //   backgroundColor:
                    //       Theme.of(context).scaffoldBackgroundColor,
                    //   child: UserNameTextField(controller),
                    // ),
                    spacerWidgets,

                    ////////////////////////////// * Phone Number * //////////////////////////////
                    PhoneNumberTextField(
                        controller,
                        controller.phoneNumberController,
                        'register_textField_phoneNumber_hint'.tr),
                    // NeumorphicContainer(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 4, vertical: 1),
                    //   borderRadius: BorderRadius.circular(16),
                    //   onTab: () {},
                    //   isInnerShadow: true,
                    //   backgroundColor:
                    //       Theme.of(context).scaffoldBackgroundColor,
                    //   child: PhoneNumberTextField(
                    //       controller,
                    //       controller.phoneNumberController,
                    //       'register_textField_phoneNumber_hint'.tr),
                    // ),
                    spacerWidgets,
                  ],
                ),
              ),
            ),

            ////////////////////////////// * Phone Number 2 * //////////////////////////////
            PhoneNumberTextField(controller, controller.phoneNumber2Controller,
                'رقم الهاتف الإضافي (اختياري)'),
            // NeumorphicContainer(
            //   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            //   borderRadius: BorderRadius.circular(16),
            //   onTab: () {},
            //   isInnerShadow: true,
            //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //   child: PhoneNumberTextField(
            //       controller,
            //       controller.phoneNumber2Controller,
            //       'رقم الهاتف الإضافي (اختياري)'),
            // ),
            spacerWidgets,

            ////////////////////////////// * Address * //////////////////////////////
            _dropdownAddress(context),
            spacerWidgets,

            ////////////////////////////// * Actual Address * //////////////////////////////
            ActualAddressTextField(controller),
            // NeumorphicContainer(
            //   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            //   borderRadius: BorderRadius.circular(16),
            //   onTab: () {},
            //   isInnerShadow: true,
            //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //   child: ActualAddressTextField(controller),
            // ),
            spacerWidgets,

            ////////////////////////////// * Note * //////////////////////////////
            NoteTextField(controller),
            // NeumorphicContainer(
            //   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            //   borderRadius: BorderRadius.circular(16),
            //   onTab: () {},
            //   isInnerShadow: true,
            //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //   child: NoteTextField(controller),
            // ),
            spacerWidgets,

            ////////////////////////////// * Employee Name * //////////////////////////////
            _dropdownEmployee(context),
            spacerWidgets,

            ////////////////////////////// * check Type * //////////////////////////////
            _checkTypes(context),
            spacerWidgets,

            ////////////////////////////// * check states * //////////////////////////////
            _checkStates(context),
            spacerWidgets,

            ////////////////////////////// * Save Report * //////////////////////////////
            _saveReportButton(context),
            spacerWidgets,
          ],
        ),
      ),
    );
  }

  Container _dropdownEmployee(BuildContext context) {
    /* 
      return GetBuilder<RegisterReportController>(
      id: controller.employeeId,
      builder: (controllers) {
        return NeumorphicContainer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          isEffective: false,
          isInnerShadow: true,
          duration: Duration.zero,
          borderRadius: BorderRadius.circular(18),
          onTab: () {},
          child: StatefulBuilder(
            builder: (context, StateSetter searchState) {
              return SearchChoices.single(
                ////////////////////////This package is edited
                rightToLeft: controller.isArabic == 'arabic',
                style: Theme.of(context).textTheme.bodyText2,
                searchInputDecoration: InputDecoration(
                  iconColor: Theme.of(context).primaryColor,
                  border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  // labelStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).canvasColor),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Theme.of(context).canvasColor),
                  // labelText: "change_location_search_hint_title".tr,
                  hintText: "register_report_employee_dropdown_hint".tr,
                ),
                items: DataHelper.employees.map((employee) {
                  return DropdownMenuItem(
                    value: employee.name,
                    child: Text(
                      employee.name,
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                value: controller.selectedEmployee,
                hint: Text(
                  "register_report_employee_dropdown_hint".tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Theme.of(context).canvasColor),
                ),
                // searchHint: null,
                iconEnabledColor:
                    controller.isDark ? Colors.white54 : Colors.black54,
                iconDisabledColor:
                    controller.isDark ? Colors.white54 : Colors.black54,
                menuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                onChanged: (newEmployee) {
                  searchState(() {
                    controller.selectedEmployee = newEmployee;
                  });
                  //
                  // controller.update();
                  // print('selectedSearch_${selectedSearch}');
                  //controller.updateLocationSearchedItem(newLocation);
                },
                dialogBox: false,
                isExpanded: true,
                closeButton: 'change_location_close'.tr,
                displayClearIcon: false,
                // onClear: (){
                //   //controller.locationSearchSelected = '';
                // },
                menuConstraints:
                    BoxConstraints.tight(const Size.fromHeight(350)),
              );
            },
          ),
        );
      },
    );
    */

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: GetBuilder<RegisterReportController>(
        id: controller.employeeId,
        builder: (controllers) {
          return StatefulBuilder(
            builder: (context, StateSetter searchState) {
              return SearchChoices.single(
                ////////////////////////This package is edited
                rightToLeft: controller.isArabic == 'arabic',
                style: Theme.of(context).textTheme.bodyText2,
                searchInputDecoration: InputDecoration(
                  iconColor: Theme.of(context).primaryColor,
                  border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  labelStyle: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Theme.of(context).canvasColor),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Theme.of(context).canvasColor),
                  // labelText: "change_location_search_hint_title".tr,
                  hintText: "register_report_employee_dropdown_hint".tr,
                ),
                items: DataHelper.employees.map((employee) {
                  return DropdownMenuItem(
                    value: employee.name,
                    child: Text(
                      employee.name,
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                value: controller.selectedEmployee,
                hint: Text(
                  "register_report_employee_dropdown_hint".tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Theme.of(context).canvasColor),
                ),
                // searchHint: null,
                iconEnabledColor:
                    controller.isDark ? Colors.white54 : Colors.black54,
                iconDisabledColor:
                    controller.isDark ? Colors.white54 : Colors.black54,
                menuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                onChanged: (newEmployee) {
                  searchState(() {
                    controller.selectedEmployee = newEmployee;
                  });
                  //
                  // controller.update();
                  // print('selectedSearch_${selectedSearch}');
                  //controller.updateLocationSearchedItem(newLocation);
                },
                dialogBox: false,
                isExpanded: true,
                closeButton: 'change_location_close'.tr,
                displayClearIcon: false,
                // onClear: (){
                //   //controller.locationSearchSelected = '';
                // },
                menuConstraints:
                    BoxConstraints.tight(const Size.fromHeight(350)),
              );
            },
          );
        },
      ),
    );
  }

  Container _dropdownAddress(BuildContext context) {
    /*
      return GetBuilder<RegisterReportController>(
      id: controller.regionsId,
      builder: (controllers) {
        return NeumorphicContainer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          isEffective: false,
          isInnerShadow: true,
          duration: Duration.zero,
          borderRadius: BorderRadius.circular(18),
          onTab: () {},
          child: StatefulBuilder(
            builder: (context, StateSetter searchState) {
              return SearchChoices.single(
                //This package is edited
                rightToLeft: controller.isArabic == 'arabic',
                style: Theme.of(context).textTheme.bodyText2,
                searchInputDecoration: InputDecoration(
                  iconColor: Theme.of(context).primaryColor,
                  border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  // labelStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).canvasColor),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Theme.of(context).canvasColor),
                  // labelText: "change_location_search_hint_title".tr,
                  hintText: "register_report_address_dropdown_hint".tr,
                ),
                items: DataHelper.regions.map((region) {
                  return DropdownMenuItem(
                    value: region.name,
                    child: Text(
                      region.name,
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                value: controller.selectedAddress,
                hint: Text(
                  "register_report_address_dropdown_hint".tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Theme.of(context).canvasColor),
                ),
                // searchHint: null,
                iconEnabledColor:
                    controller.isDark ? Colors.white54 : Colors.black54,
                iconDisabledColor:
                    controller.isDark ? Colors.white54 : Colors.black54,
                menuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                onChanged: (newAddress) {
                  searchState(() {
                    controller.selectedAddress = newAddress;
                  });
                  //
                  // controller.update();
                  // print('selectedSearch_${selectedSearch}');
                  //controller.updateLocationSearchedItem(newLocation);
                },
                dialogBox: false,
                isExpanded: true,
                closeButton: 'change_location_close'.tr,
                displayClearIcon: false,
                // onClear: (){
                //   //controller.locationSearchSelected = '';
                // },
                menuConstraints:
                    BoxConstraints.tight(const Size.fromHeight(350)),
              );
            },
          ),
        );
      },
    );
     */

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: GetBuilder<RegisterReportController>(
        id: controller.regionsId,
        builder: (controllers) {
          return StatefulBuilder(
            builder: (context, StateSetter searchState) {
              return SearchChoices.single(
                //This package is edited
                rightToLeft: controller.isArabic == 'arabic',
                style: Theme.of(context).textTheme.bodyText2,
                searchInputDecoration: InputDecoration(
                  iconColor: Theme.of(context).primaryColor,
                  border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  // labelStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).canvasColor),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Theme.of(context).canvasColor),
                  // labelText: "change_location_search_hint_title".tr,
                  hintText: "register_report_address_dropdown_hint".tr,
                ),
                items: DataHelper.regions.map((region) {
                  return DropdownMenuItem(
                    value: region.name,
                    child: Text(
                      region.name,
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                value: controller.selectedAddress,
                hint: Text(
                  "register_report_address_dropdown_hint".tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Theme.of(context).canvasColor),
                ),
                // searchHint: null,
                iconEnabledColor:
                    controller.isDark ? Colors.white54 : Colors.black54,
                iconDisabledColor:
                    controller.isDark ? Colors.white54 : Colors.black54,
                menuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                onChanged: (newAddress) {
                  searchState(() {
                    controller.selectedAddress = newAddress;
                  });
                  //
                  // controller.update();
                  // print('selectedSearch_${selectedSearch}');
                  //controller.updateLocationSearchedItem(newLocation);
                },
                dialogBox: false,
                isExpanded: true,
                closeButton: 'change_location_close'.tr,
                displayClearIcon: false,
                // onClear: (){
                //   //controller.locationSearchSelected = '';
                // },
                menuConstraints:
                    BoxConstraints.tight(const Size.fromHeight(350)),
              );
            },
          );
        },
      ),
    );
  }

  SizedBox _buttonSave(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(6),
            primary: Theme.of(context).primaryColor,
            shadowColor: Colors.black54),
        child: Center(
          child: Icon(
            Icons.save,
            size: 28,
            color: controller.isDark ? Colors.black54 : Colors.white,
          ),
        ),
        onPressed: () {},
      ),
    );
  }

  GetBuilder _checkStates(BuildContext context) {
    const Duration durationAnimation = Duration(milliseconds: 150);

    /*
    GetBuilder<RegisterReportController>(
      id: controller.statesId,
      builder: (controllers) {
        return ScreenSizer(
          builder: (customSize) {
            final double indicatorWidth =
                (customSize.screenWidth - 12 * 2) / checkStates.length;
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
                                  .checkStatesSelected, //controller.checkStatesSelected == 0 ? indicatorWidth * controller.checkStatesSelected :
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
                                checkStates.length,
                                (index) => Expanded(
                                      child: GestureDetector(
                                        onTap: () => setAnimation(() =>
                                            controller.checkStatesSelected =
                                                index),
                                        child: AnimatedDefaultTextStyle(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                  color: index ==
                                                          controller
                                                              .checkStatesSelected
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .bodyText2!
                                                          .color),
                                          duration: durationAnimation,
                                          child: Text(
                                            checkStates[index],
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
     */

    return GetBuilder<RegisterReportController>(
      id: controller.statesId,
      builder: (controllers) {
        return ScreenSizer(
          builder: (customSize) {
            final double indicatorWidth =
                (customSize.screenWidth - 12 * 2) / checkStates.length;
            return StatefulBuilder(
              builder: (context, StateSetter setAnimation) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 5),
                            color: Colors.black26,
                            blurRadius: 9,
                            spreadRadius: 1.5)
                      ],
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.all(10),
                    duration: Duration.zero,
                    child: Stack(
                      children: [
                        ////////////////////////////// * check states * //////////////////////////////
                        AnimatedPositionedDirectional(
                          start: indicatorWidth *
                              controller
                                  .checkStatesSelected, //controller.checkStatesSelected == 0 ? indicatorWidth * controller.checkStatesSelected :
                          bottom: 0,
                          top: 0,
                          duration: durationAnimation,
                          child: SizedBox(
                            width: indicatorWidth,
                            height: 90,
                            child: AnimatedContainer(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.all(4),
                              duration: durationAnimation,
                              child: const SizedBox(),
                            ),
                          ),
                        ),

                        ////////////////////////////// * Items * //////////////////////////////
                        Positioned.fill(
                          child: Row(
                            children: List.generate(
                                checkStates.length,
                                (index) => Expanded(
                                      child: GestureDetector(
                                        onTap: () => setAnimation(() =>
                                            controller.checkStatesSelected =
                                                index),
                                        child: AnimatedDefaultTextStyle(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                  color: index ==
                                                          controller
                                                              .checkStatesSelected
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .bodyText2!
                                                          .color),
                                          duration: durationAnimation,
                                          child: Text(
                                            checkStates[index],
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

  GetBuilder _checkTypes(BuildContext context) {
    return GetBuilder<RegisterReportController>(
        id: controller.typesId,
        builder: (controllers) {
          return CheckTypes(controller: controller);
        });
  }

  SizedBox _saveReportButton(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 50,
      child: NeumorphicContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.symmetric(horizontal: 0),
        borderRadius: BorderRadius.circular(120),
        onTab: () {
          debugPrint('clicked');
        },
        isInnerShadow: false,
        isEffective: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(4),
            elevation: 0,
            side: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(300),
            ),
            shadowColor: Colors.transparent,
          ),
          child: Text(
            'register_report_button_text'.tr,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(), //color: Theme.of(context).primaryColor
          ),
          onPressed: () {
            controller.registerNewReport();
          },
        ),
      ),
    );
  }
}

/* Username TextField Class */

// ignore: must_be_immutable
class UserNameTextField extends StatelessWidget {
  UserNameTextField(this.controller, {Key? key}) : super(key: key);

  RegisterReportController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: const [AutofillHints.username],
      controller: controller.usernameController,
      enableSuggestions: true,
      readOnly: false,
      autocorrect: true,
      style: Theme.of(context)
          .textTheme
          .subtitle1, //TextStyle(color: Colors.black.withOpacity(0.9)),
      textInputAction: TextInputAction.next,
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
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1)),
          labelText: 'login_textField_username_label'.tr,
          hintText: 'login_textField_username_hint'.tr,
          floatingLabelBehavior: FloatingLabelBehavior.never, //always
          // border: InputBorder.none,
          // focusedBorder: InputBorder.none,
          // enabledBorder: InputBorder.none,
          prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ))),
      keyboardType: TextInputType.name,
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
      // ],
      validator: (name) {
        if (name == null || name.isEmpty) {
          return 'login_username_empty'.tr;
        }
        return null;
      },
    );
  }
}

/* Actual Address TextField Class */

// ignore: must_be_immutable
class ActualAddressTextField extends StatelessWidget {
  ActualAddressTextField(this.controller, {Key? key}) : super(key: key);

  RegisterReportController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.actualAddressController,
      enableSuggestions: true,
      readOnly: false,
      autocorrect: true,
      style: Theme.of(context)
          .textTheme
          .subtitle1, //TextStyle(color: Colors.black.withOpacity(0.9)),
      textInputAction: TextInputAction.next,
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
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1)),
          labelText:
              "${'register_report_actual_address_textField_label'.tr} (اختياري)",
          hintText:
              "${'register_report_actual_address_textField_label'.tr} (اختياري)",
          floatingLabelBehavior: FloatingLabelBehavior.never, //always
          // border: InputBorder.none,
          // focusedBorder: InputBorder.none,
          // enabledBorder: InputBorder.none,
          prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Icon(
                Icons.map,
                color: Theme.of(context).primaryColor,
              ))),
      keyboardType: TextInputType.text,
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
      // ],
      validator: (address) {
        if (address == null || address.isEmpty) {
          return 'login_username_empty'.tr;
        }
        return null;
      },
    );
  }
}

/* PhoneNumber TextField Class */

// ignore: must_be_immutable
class PhoneNumberTextField extends StatelessWidget {
  PhoneNumberTextField(
      this.controller, this.textEditingController, this.hintTextField,
      {Key? key})
      : super(key: key);

  RegisterReportController controller;
  TextEditingController textEditingController;
  String hintTextField;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: const [AutofillHints.telephoneNumber],
      controller: textEditingController,
      enableSuggestions: true,
      readOnly: false,
      autocorrect: true,
      style: Theme.of(context)
          .textTheme
          .subtitle1, //TextStyle(color: Colors.black.withOpacity(0.9)),
      textInputAction: TextInputAction.next,
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
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1)),
          labelText: hintTextField,
          hintText: hintTextField,
          floatingLabelBehavior: FloatingLabelBehavior.never, //always
          // border: InputBorder.none,
          // focusedBorder: InputBorder.none,
          // enabledBorder: InputBorder.none,
          prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Icon(
                Icons.phone,
                color: Theme.of(context).primaryColor,
              ))),
      keyboardType: TextInputType.phone,
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
      // ],
      validator: (phone) {
        if (phone == null || phone.isEmpty) {
          return 'register_textField_phoneNumber_empty'.tr;
        }
        return null;
      },
    );
  }
}

/* Note TextField Class */

// ignore: must_be_immutable
class NoteTextField extends StatelessWidget {
  NoteTextField(this.controller, {Key? key}) : super(key: key);

  RegisterReportController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.noteController,
      enableSuggestions: true,
      readOnly: false,
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
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1)),
          labelText: 'ادخل ملاحظة (اختياري)',
          hintText: 'ادخل ملاحظة (اختياري)',
          floatingLabelBehavior: FloatingLabelBehavior.never, //always
          // border: InputBorder.none,
          // focusedBorder: InputBorder.none,
          // enabledBorder: InputBorder.none,
          prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Icon(
                Icons.note,
                color: Theme.of(context).primaryColor,
              ))),
      keyboardType: TextInputType.text,
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
      // ],
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'رجاء ادخل ملاحظة';
        }
        return null;
      },
    );
  }
}

/* CheckTypes Class */

// ignore: must_be_immutable
class CheckTypes extends StatefulWidget {
  RegisterReportController controller;

  CheckTypes({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckTypesState();
}

class _CheckTypesState extends State<CheckTypes> {
  /*
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: NeumorphicContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(12),
              borderRadius: BorderRadius.circular(16),
              onTab: () {
                if (widget.controller.isPressed1) {
                  widget.controller.isPressed1 = false;
                  widget.controller.checkTypesSelected = 4;
                }
                //other jobs or empty
                else {
                  widget.controller.isPressed1 = true;
                  widget.controller.isPressed2 = false;
                  widget.controller.isPressed3 = false;
                  widget.controller.checkTypesSelected = 0;
                }

                setState(() {});
              },
              isInnerShadow: false,
              isEffective: true,
              backgroundColor: widget.controller.isPressed1
                  ? (widget.controller.isDark ? Colors.redAccent : Colors.red)
                  : Theme.of(context).scaffoldBackgroundColor,
              child: Icon(
                Icons.done,
                size: 25,
                color: widget.controller.isPressed1
                    ? (widget.controller.isDark ? Colors.black54 : Colors.white)
                    : (widget.controller.isDark
                        ? Colors.redAccent
                        : Colors.red),
              )),
        ),
        const SizedBox(
          width: 16,
        ),
        Flexible(
          child: NeumorphicContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(12),
              borderRadius: BorderRadius.circular(16),
              onTab: () {
                if (widget.controller.isPressed2) {
                  widget.controller.isPressed2 = false;
                  widget.controller.checkTypesSelected = 4;
                }
                //other jobs or empty
                else {
                  widget.controller.isPressed1 = false;
                  widget.controller.isPressed2 = true;
                  widget.controller.isPressed3 = false;
                  widget.controller.checkTypesSelected = 1;
                }

                setState(() {});
              },
              isInnerShadow: false,
              isEffective: true,
              backgroundColor: widget.controller.isPressed2
                  ? (widget.controller.isDark
                      ? Colors.greenAccent
                      : Colors.green)
                  : Theme.of(context).scaffoldBackgroundColor,
              child: Icon(
                Icons.done,
                size: 25,
                color: widget.controller.isPressed2
                    ? (widget.controller.isDark ? Colors.black54 : Colors.white)
                    : (widget.controller.isDark
                        ? Colors.greenAccent
                        : Colors.green),
              )),
        ),
        const SizedBox(
          width: 16,
        ),
        Flexible(
          child: NeumorphicContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(12),
              borderRadius: BorderRadius.circular(16),
              onTab: () {
                if (widget.controller.isPressed3) {
                  widget.controller.isPressed3 = false;
                  widget.controller.checkTypesSelected = 4;
                }
                //other jobs or empty
                else {
                  widget.controller.isPressed1 = false;
                  widget.controller.isPressed2 = false;
                  widget.controller.isPressed3 = true;
                  widget.controller.checkTypesSelected = 2;
                }

                setState(() {});
              },
              isInnerShadow: false,
              isEffective: true,
              backgroundColor: widget.controller.isPressed3
                  ? (widget.controller.isDark
                      ? Colors.yellow
                      : Colors.yellowAccent)
                  : Theme.of(context).scaffoldBackgroundColor,
              child: Icon(
                Icons.done,
                size: 25,
                color: widget.controller.isPressed3
                    ? (widget.controller.isDark ? Colors.black54 : Colors.white)
                    : (widget.controller.isDark
                        ? Colors.yellow
                        : Colors.yellowAccent),
              )),
        ),
        const SizedBox(
          width: 16,
        ),
      ],
    );
  
   */

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: GestureDetector(
            onTap: () {
              if (widget.controller.isPressed1) {
                widget.controller.isPressed1 = false;
                widget.controller.checkTypesSelected = 4;
              }
              //other jobs or empty
              else {
                widget.controller.isPressed1 = true;
                widget.controller.isPressed2 = false;
                widget.controller.isPressed3 = false;
                widget.controller.checkTypesSelected = 0;
              }

              setState(() {});
            },
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 3),
                        color: Colors.black26,
                        blurRadius: 8,
                        spreadRadius: 0.5)
                  ],
                  color: widget.controller.isPressed1
                      ? (widget.controller.isDark
                          ? Colors.redAccent
                          : Colors.red)
                      : Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'انتباه',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: widget.controller.isPressed1
                          ? (widget.controller.isDark
                              ? Colors.black54
                              : Colors.white)
                          : (widget.controller.isDark
                              ? Colors.redAccent
                              : Colors.red)),
                )),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              if (widget.controller.isPressed2) {
                widget.controller.isPressed2 = false;
                widget.controller.checkTypesSelected = 4;
              }
              //other jobs or empty
              else {
                widget.controller.isPressed1 = false;
                widget.controller.isPressed2 = true;
                widget.controller.isPressed3 = false;
                widget.controller.checkTypesSelected = 1;
              }

              setState(() {});
            },
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 3),
                        color: Colors.black26,
                        blurRadius: 8,
                        spreadRadius: 0.5)
                  ],
                  borderRadius: BorderRadius.circular(16),
                  color: widget.controller.isPressed2
                      ? (widget.controller.isDark
                          ? Colors.greenAccent
                          : Colors.green)
                      : Theme.of(context).backgroundColor,
                ),
                child: Text(
                  'مستعجل',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: widget.controller.isPressed2
                          ? (widget.controller.isDark
                              ? Colors.black54
                              : Colors.white)
                          : (widget.controller.isDark
                              ? Colors.greenAccent
                              : Colors.green)),
                )),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              if (widget.controller.isPressed3) {
                widget.controller.isPressed3 = false;
                widget.controller.checkTypesSelected = 4;
              }
              //other jobs or empty
              else {
                widget.controller.isPressed1 = false;
                widget.controller.isPressed2 = false;
                widget.controller.isPressed3 = true;
                widget.controller.checkTypesSelected = 2;
              }

              setState(() {});
            },
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 3),
                        color: Colors.black26,
                        blurRadius: 8,
                        spreadRadius: 0.5)
                  ],
                  borderRadius: BorderRadius.circular(16),
                  color: widget.controller.isPressed3
                      ? (widget.controller.isDark
                          ? Colors.yellow
                          : Colors.yellowAccent)
                      : Theme.of(context).backgroundColor,
                ),
                child: Text(
                  'ضروري',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: widget.controller.isPressed3
                            ? (widget.controller.isDark
                                ? Colors.black54
                                : Colors.white)
                            : (widget.controller.isDark
                                ? Colors.yellow
                                : Colors.yellowAccent),
                      ),
                )),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
      ],
    );
  }
}

List<String> checkStates = [
  'مساعدة',
  'جديد',
  'إعادة',
];
