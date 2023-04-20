import 'package:bank_al_dawa/app/core/helper/data_helper.dart';
import 'package:bank_al_dawa/app/core/services/request_manager.dart';
import 'package:bank_al_dawa/app/core/widgets/widget_state.dart';
import 'package:bank_al_dawa/app/modules/dashboard/all_reports/all_reports_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_choices/search_choices.dart';

import '../../services/size_configration.dart';
import '../neumorphic_container.dart';

class FilterBottomSheet {
  static Future<void> showFilterDialog(
      BuildContext context, AllReportsController controller) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      elevation: 10,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      isDismissible: true,
      clipBehavior: Clip.antiAlias,
      builder: (context) => BottomSheet(
          enableDrag: true,
          animationController: controller.bottomSheetAnimationController,
          onClosing: () {},
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 10,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          clipBehavior: Clip.antiAlias,
          builder: (context) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ////////////////////////////// * Shape line * //////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Container(
                        width: 100, height: 3, color: Colors.grey.shade700),
                  ),

                  ////////////////////////////// * Title Filter * //////////////////////////////
                  _filterTitle(context),
                  const SizedBox(
                    height: 30,
                  ),

                  ////////////////////////////// * Search TextField  * //////////////////////////////
                  _searchUserTextField(context, controller),
                  const SizedBox(
                    height: 5,
                  ),

                  ////////////////////////////// * Employee Dropdown  * //////////////////////////////
                  _employeeDropdown(context, controller),
                  const SizedBox(
                    height: 5,
                  ),

                  ////////////////////////////// * List of Employees  * //////////////////////////////
                  _ListEmployees(context, controller),
                  const SizedBox(
                    height: 5,
                  ),

                  ////////////////////////////// * Region Dropdown  * //////////////////////////////
                  _regionDropdown(context, controller),
                  const SizedBox(
                    height: 5,
                  ),

                  ////////////////////////////// * List of Regions  * //////////////////////////////
                  _ListRegions(context, controller),
                  const SizedBox(
                    height: 5,
                  ),

                  ////////////////////////////// * Results Dropdown * //////////////////////////////
                  _resultType(context, controller),
                  const SizedBox(
                    height: 5,
                  ),

                  ////////////////////////////// * List of Results  * //////////////////////////////
                  _ListResults(context, controller),
                  const SizedBox(
                    height: 5,
                  ),

                  ////////////////////////////// * Priority Dropdown * //////////////////////////////
                  _priorityDropdown(context, controller),
                  const SizedBox(
                    height: 5,
                  ),

                  ////////////////////////////// * List of Priorities  * /////////////////////////////
                  _listPriorities(context, controller),
                  const SizedBox(
                    height: 5,
                  ),

                  ////////////////////////////// * Type Dropdown * //////////////////////////////
                  _TypesDropdown(context, controller),
                  const SizedBox(
                    height: 5,
                  ),

                  ////////////////////////////// * List of Types  * //////////////////////////////
                  _listTypes(context, controller),
                  const SizedBox(
                    height: 5,
                  ),

                  ////////////////////////////// * First Date * //////////////////////////////
                  _firstDate(context, controller),
                  const SizedBox(
                    height: 10,
                  ),

                  ////////////////////////////// * Second Date * //////////////////////////////
                  _secondDate(context, controller),
                  const SizedBox(
                    height: 10,
                  ),

                  ////////////////////////////// * Filter Button * //////////////////////////////
                  _filterButton(context, controller),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          }),
    );
  }

  static SizedBox _employeeDropdown(
      BuildContext context, AllReportsController controller) {
    /*
      SizedBox(
      width: 350,
      child: NeumorphicContainer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(4),
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
                hintText: "all_reports_user_dropdown_hint".tr,
              ),
              items: DataHelper.employees.map((employee) {
                return DropdownMenuItem(
                  onTap: () {
                    if (!controller.usersFilter.contains(employee)) {
                      controller.usersFilter.add(employee);
                      controller.updateState([controller.listEmployeesFilterId],
                          WidgetState.loaded);
                    }
                  },
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
                "all_reports_user_dropdown_hint".tr,
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
              clearIcon: Icon(
                Icons.clear,
                color: controller.isDark ? Colors.white54 : Colors.black54,
              ),
              onClear: () {
                controller.selectedEmployee = "";
              },
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
              displayClearIcon: true,
              // onClear: (){
              //controller.locationSearchSelected = '';
              // },
              menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
            );
          },
        ),
      ),
    );
     */

    return SizedBox(
        width: 350,
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
          duration: Duration.zero,
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
                  hintText: "all_reports_user_dropdown_hint".tr,
                ),
                items: DataHelper.employees.map((employee) {
                  return DropdownMenuItem(
                    onTap: () {
                      if (!controller.usersFilter.contains(employee)) {
                        controller.usersFilter.add(employee);
                        controller.updateState(
                            [controller.listEmployeesFilterId],
                            WidgetState.loaded);
                      }
                    },
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
                  "all_reports_user_dropdown_hint".tr,
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
                clearIcon: Icon(
                  Icons.clear,
                  color: controller.isDark ? Colors.white54 : Colors.black54,
                ),
                onClear: () {
                  controller.selectedEmployee = "";
                },
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
                displayClearIcon: true,
                // onClear: (){
                //controller.locationSearchSelected = '';
                // },
                menuConstraints:
                    BoxConstraints.tight(const Size.fromHeight(350)),
              );
            },
          ),
        ));
  }

  static SizedBox _regionDropdown(
      BuildContext context, AllReportsController controller) {
    /*
      SizedBox(
      width: 350,
      child: NeumorphicContainer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(4),
        isEffective: false,
        isInnerShadow: true,
        duration: Duration.zero,
        borderRadius: BorderRadius.circular(18),
        onTab: () {
          // FocusManager.instance.primaryFocus?.unfocus();
        },
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
                hintText: "all_reports_region_dropdown_hint".tr,
              ),
              items: DataHelper.regions.map((region) {
                return DropdownMenuItem(
                  onTap: () {
                    if (!controller.regionsFilter.contains(region)) {
                      controller.regionsFilter.add(region);
                      controller.updateState(
                          [controller.listRegionsFilterId], WidgetState.loaded);
                    }
                  },
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
              value: controller.selectedRegion,
              hint: Text(
                "all_reports_region_dropdown_hint".tr,
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

              clearIcon: Icon(
                Icons.clear,
                color: controller.isDark ? Colors.white54 : Colors.black54,
                size: 20,
              ),
              onClear: () {
                controller.selectedRegion = "";
              },
              onChanged: (newRegion) {
                searchState(() {
                  controller.selectedRegion = newRegion;
                });
                //
                // controller.update();
                // print('selectedSearch_${selectedSearch}');
                //controller.updateLocationSearchedItem(newLocation);
              },
              dialogBox: false,
              isExpanded: true,
              closeButton: 'change_location_close'.tr,
              displayClearIcon: true,
              // onClear: (){
              //   //controller.locationSearchSelected = '';
              // },
              menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
            );
          },
        ),
      ),
    );
     */

    return SizedBox(
      width: 350,
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(15),
        ),
        duration: Duration.zero,
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
                hintText: "all_reports_region_dropdown_hint".tr,
              ),
              items: DataHelper.regions.map((region) {
                return DropdownMenuItem(
                  onTap: () {
                    if (!controller.regionsFilter.contains(region)) {
                      controller.regionsFilter.add(region);
                      controller.updateState(
                          [controller.listRegionsFilterId], WidgetState.loaded);
                    }
                  },
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
              value: controller.selectedRegion,
              hint: Text(
                "all_reports_region_dropdown_hint".tr,
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

              clearIcon: Icon(
                Icons.clear,
                color: controller.isDark ? Colors.white54 : Colors.black54,
                size: 20,
              ),
              onClear: () {
                controller.selectedRegion = "";
              },
              onChanged: (newRegion) {
                searchState(() {
                  controller.selectedRegion = newRegion;
                });
                //
                // controller.update();
                // print('selectedSearch_${selectedSearch}');
                //controller.updateLocationSearchedItem(newLocation);
              },
              dialogBox: false,
              isExpanded: true,
              closeButton: 'change_location_close'.tr,
              displayClearIcon: true,
              // onClear: (){
              //   //controller.locationSearchSelected = '';
              // },
              menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
            );
          },
        ),
      ),
    );
  }

  static Padding _searchUserTextField(
      BuildContext context, AllReportsController controller) {
    /*
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
      child: NeumorphicContainer(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        borderRadius: BorderRadius.circular(16),
        onTab: () {},
        isInnerShadow: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: TextFormField(
          textDirection: TextDirection.rtl,
          autofillHints: const [AutofillHints.username],
          controller: controller.userTextField,
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
              labelText: 'all_reports_user_textField_label'.tr,
              hintText: 'all_reports_user_textField_hint'.tr,
              floatingLabelBehavior: FloatingLabelBehavior.never, //always
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ))),
          keyboardType: TextInputType.text,
          // inputFormatters: <TextInputFormatter>[
          //   FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
          // ],
          validator: (search) {
            if (search == null || search.isEmpty) {
              return 'all_reports_user_textField_empty'.tr;
            }
            return null;
          },
        ),
      ),
    );
     */

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
      child: TextFormField(
        textDirection: TextDirection.rtl,
        autofillHints: const [AutofillHints.username],
        controller: controller.userTextField,
        enableSuggestions: true,
        readOnly: false,
        autofocus: false,
        maxLines: 1,
        autocorrect: true,
        style: Theme.of(context)
            .textTheme
            .subtitle2, //TextStyle(color: Colors.black.withOpacity(0.9)),
        textInputAction: TextInputAction.done,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            hintStyle: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .color!
                    .withOpacity(0.5)),
            labelStyle: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .color!
                    .withOpacity(0.5)),
            errorStyle: const TextStyle(
                color: Colors.red,
                fontSize: 10,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w200),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, width: 1)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, width: 1)),
            labelText: 'all_reports_user_textField_label'.tr,
            hintText: 'all_reports_user_textField_hint'.tr,
            floatingLabelBehavior: FloatingLabelBehavior.never, //always
            // border: InputBorder.none,
            // focusedBorder: InputBorder.none,
            // enabledBorder: InputBorder.none,
            prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Icon(
                  Icons.search,
                  color: Theme.of(context).primaryColor,
                ))),
        keyboardType: TextInputType.text,
        // inputFormatters: <TextInputFormatter>[
        //   FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
        // ],
        validator: (search) {
          if (search == null || search.isEmpty) {
            return 'all_reports_user_textField_empty'.tr;
          }
          return null;
        },
      ),
    );
  }

  static Padding _filterTitle(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 12, left: 24, right: 24),
        child: Text('all_reports_filter_title'.tr,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle1!));
  }

  // static StatefulBuilder _checkButton(
  //     BuildContext context, AllReportsController controller) {
  //   return StatefulBuilder(
  //     builder: (context, StateSetter searchState) {
  //       return NeumorphicContainer(
  //           backgroundColor: controller.releaseReports
  //               ? Theme.of(context).primaryColor
  //               : Theme.of(context).scaffoldBackgroundColor,
  //           padding: const EdgeInsets.all(12),
  //           isEffective: true,
  //           isInnerShadow: false,
  //           duration: const Duration(milliseconds: 300),
  //           borderRadius: BorderRadius.circular(18),
  //           onTab: () {
  //             searchState(() {
  //               controller.releaseReports = !controller.releaseReports;
  //             });
  //           },
  //           child: Icon(
  //             Icons.done,
  //             size: 30,
  //             color: controller.releaseReports
  //                 ? Colors.yellow
  //                 : Theme.of(context).primaryColor,
  //           ));
  //     },
  //   );
  // }

  static SizedBox _filterButton(
      BuildContext context, AllReportsController controller) {
    return SizedBox(
      width: 140,
      height: 55,
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
            'all_reports__filter_button_text'.tr,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(), //color: Theme.of(context).primaryColor
          ),
          onPressed: () async {
            // Start Filtering results
            await controller.loadReports(
                requestType: RequestType.refresh, showLoading: true);
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  // ignore: unused_element
  static ScreenSizer _datePicker(
      BuildContext context, AllReportsController controller) {
    return ScreenSizer(
      builder: (customSize) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: StatefulBuilder(
            builder: (context, StateSetter stateDate) {
              return SizedBox(
                width:
                    customSize.screenWidth, //MediaQuery.of(context).size.width
                height: 120,
                child: CupertinoDatePicker(
                  onDateTimeChanged: (dateTime) {
                    stateDate(() {
                      controller.selectedDatetime = dateTime;
                      debugPrint(
                          'date: ${controller.selectedDatetime.toString()}');
                    });
                  },
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  initialDateTime: controller.selectedDatetime,
                  mode: CupertinoDatePickerMode.date,
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  static Container _ListEmployees(
      BuildContext context, AllReportsController controller) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: StateBuilder<AllReportsController>(
        key: UniqueKey(),
        id: controller.listEmployeesFilterId,
        disableState: false,
        onRetryFunction: () {},
        // noResultView: ,
        // loadingView: ,
        // errorView: ,
        initialWidgetState: WidgetState.loaded,
        builder: (widgetState, controllers) {
          return controller.usersFilter.isEmpty
              ? const SizedBox()
              : ScreenSizer(
                  builder: (customSize) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: SizedBox(
                        width: customSize
                            .screenWidth, //MediaQuery.of(context).size.width
                        height: 80,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(4),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.usersFilter.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                height: 80,
                                child: NeumorphicContainer(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    padding: const EdgeInsets.all(16),
                                    isEffective: true,
                                    isInnerShadow: false,
                                    duration: const Duration(milliseconds: 300),
                                    borderRadius: BorderRadius.circular(18),
                                    onTab: () {
                                      controller.usersFilter.removeAt(index);
                                      controller.updateState(
                                          [controller.listEmployeesFilterId],
                                          WidgetState.loaded);
                                    },
                                    child: Center(
                                      child: Text(
                                        controller.usersFilter[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
  static StateBuilder<AllReportsController> _ListRegions(
      BuildContext context, AllReportsController controller) {
    return StateBuilder<AllReportsController>(
      key: UniqueKey(),
      id: controller.listRegionsFilterId,
      disableState: false,
      onRetryFunction: () {},
      // noResultView: ,
      // loadingView: ,
      // errorView: ,
      initialWidgetState: WidgetState.loaded,
      builder: (widgetState, controllers) {
        return controller.regionsFilter.isEmpty
            ? const SizedBox()
            : ScreenSizer(
                builder: (customSize) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: SizedBox(
                      width: customSize
                          .screenWidth, //MediaQuery.of(context).size.width
                      height: 80,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(4),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.regionsFilter.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              height: 80,
                              child: NeumorphicContainer(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  padding: const EdgeInsets.all(16),
                                  isEffective: true,
                                  isInnerShadow: false,
                                  duration: const Duration(milliseconds: 300),
                                  borderRadius: BorderRadius.circular(18),
                                  onTab: () {
                                    controller.regionsFilter.removeAt(index);
                                    controller.updateState(
                                        [controller.listRegionsFilterId],
                                        WidgetState.loaded);
                                  },
                                  child: Center(
                                    child: Text(
                                      controller.regionsFilter[index].name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  static Padding _firstDate(
      BuildContext context, AllReportsController controller) {
    /*
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
      child: Row(
        children: [
          Flexible(
            child: NeumorphicContainer(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              borderRadius: BorderRadius.circular(16),
              onTab: () {
                controller.firstDateTextField.clear();
              },
              isInnerShadow: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: TextFormField(
                  enabled: false,
                  controller: controller.firstDateTextField,
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
                      labelText: 'تاريخ البداية',
                      hintText: 'تاريخ البداية',
                      floatingLabelBehavior:
                          FloatingLabelBehavior.never, //always
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      // suffixIcon: Padding(
                      //     padding: const EdgeInsets.only(left: 0.0),
                      //     child: GestureDetector(
                      //       onTap: () {
                      //         controller.secondDateTextField.clear();
                      //       },
                      //       child: Icon(
                      //         Icons.clear,
                      //         color: Theme.of(context).primaryColor,
                      //       ),
                      //     )),
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
              child: Center(
                child: Icon(
                  Icons.edit,
                  size: 28,
                  color: controller.isDark ? Colors.black54 : Colors.white,
                ),
              ),
              onPressed: () {
                controller.showDatePickerDialog(
                    context, controller.firstDateTextField);
              },
            ),
          ),
        ],
      ),
    );
    
     */

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GestureDetector(
                  onTap: () => controller.firstDateTextField.clear(),
                  child: TextFormField(
                    enabled: false,
                    controller: controller.firstDateTextField,
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1)),
                        labelText: 'تاريخ البداية',
                        hintText: 'تاريخ البداية',
                        floatingLabelBehavior:
                            FloatingLabelBehavior.never, //always
                        // border: InputBorder.none,
                        // focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        // suffixIcon: Padding(
                        //     padding: const EdgeInsets.only(left: 0.0),
                        //     child: GestureDetector(
                        //       onTap: () {
                        //         controller.secondDateTextField.clear();
                        //       },
                        //       child: Icon(
                        //         Icons.clear,
                        //         color: Theme.of(context).primaryColor,
                        //       ),
                        //     )),
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
              child: Center(
                child: Icon(
                  Icons.edit,
                  size: 28,
                  color: controller.isDark ? Colors.black54 : Colors.white,
                ),
              ),
              onPressed: () {
                controller.showDatePickerDialog(
                    context, controller.firstDateTextField);
              },
            ),
          ),
        ],
      ),
    );
  }

  static Padding _secondDate(
      BuildContext context, AllReportsController controller) {
    /*
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
      child: Row(
        children: [
          Flexible(
            child: NeumorphicContainer(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              borderRadius: BorderRadius.circular(16),
              onTab: () {
                controller.secondDateTextField.clear();
              },
              isInnerShadow: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: TextFormField(
                  enabled: false,
                  controller: controller.secondDateTextField,
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
                      labelText: 'تاريخ النهاية',
                      hintText: 'تاريخ النهاية',
                      floatingLabelBehavior:
                          FloatingLabelBehavior.never, //always
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      // suffixIcon: Padding(
                      //     padding: const EdgeInsets.only(left: 0.0),
                      //     child: GestureDetector(
                      //       onTap: () {
                      //         controller.secondDateTextField.clear();
                      //       },
                      //       child: Icon(
                      //         Icons.clear,
                      //         color: Theme.of(context).primaryColor,
                      //       ),
                      //     )),
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
              child: Center(
                child: Icon(
                  Icons.edit,
                  size: 28,
                  color: controller.isDark ? Colors.black54 : Colors.white,
                ),
              ),
              onPressed: () {
                controller.showDatePickerDialog(
                    context, controller.secondDateTextField);
              },
            ),
          ),
        ],
      ),
    );
  
     */

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GestureDetector(
                  onTap: () => controller.secondDateTextField.clear(),
                  child: TextFormField(
                    enabled: false,
                    controller: controller.secondDateTextField,
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1)),
                        labelText: 'تاريخ النهاية',
                        hintText: 'تاريخ النهاية',
                        floatingLabelBehavior:
                            FloatingLabelBehavior.never, //always
                        // border: InputBorder.none,
                        // focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        // suffixIcon: Padding(
                        //     padding: const EdgeInsets.only(left: 0.0),
                        //     child: GestureDetector(
                        //       onTap: () {
                        //         controller.secondDateTextField.clear();
                        //       },
                        //       child: Icon(
                        //         Icons.clear,
                        //         color: Theme.of(context).primaryColor,
                        //       ),
                        //     )),
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
              child: Center(
                child: Icon(
                  Icons.edit,
                  size: 28,
                  color: controller.isDark ? Colors.black54 : Colors.white,
                ),
              ),
              onPressed: () {
                controller.showDatePickerDialog(
                    context, controller.secondDateTextField);
              },
            ),
          ),
        ],
      ),
    );
  }

  static SizedBox _resultType(
      BuildContext context, AllReportsController controller) {
    /*
    SizedBox(
      width: 350,
      child: NeumorphicContainer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(4),
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
                hintText: 'النتيجة',
              ),
              items: controller.results.map((result) {
                return DropdownMenuItem(
                  onTap: () {
                    if (!controller.resultsFilter.contains(result)) {
                      controller.resultsFilter.add(result);
                      controller.updateState(
                          [controller.listResultsFilterId], WidgetState.loaded);
                    }
                  },
                  value: result.name,
                  child: Text(
                    result.name,
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              value: controller.selectedResults,
              hint: Text(
                'النتيجة',
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
              clearIcon: Icon(
                Icons.clear,
                color: controller.isDark ? Colors.white54 : Colors.black54,
              ),
              onClear: () {
                controller.selectedResults = "";
              },
              menuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onChanged: (newResult) {
                searchState(() {
                  controller.selectedResults = newResult;
                });
                //
                // controller.update();
                // print('selectedSearch_${selectedSearch}');
                //controller.updateLocationSearchedItem(newLocation);
              },
              dialogBox: false,
              isExpanded: true,
              closeButton: 'change_location_close'.tr,
              displayClearIcon: true,
              // onClear: (){
              //controller.locationSearchSelected = '';
              // },
              menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
            );
          },
        ),
      ),
    );
     */

    return SizedBox(
      width: 350,
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(15),
        ),
        duration: Duration.zero,
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
                hintText: 'النتيجة',
              ),
              items: controller.results.map((result) {
                return DropdownMenuItem(
                  onTap: () {
                    if (!controller.resultsFilter.contains(result)) {
                      controller.resultsFilter.add(result);
                      controller.updateState(
                          [controller.listResultsFilterId], WidgetState.loaded);
                    }
                  },
                  value: result.name,
                  child: Text(
                    result.name,
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              value: controller.selectedResults,
              hint: Text(
                'النتيجة',
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
              clearIcon: Icon(
                Icons.clear,
                color: controller.isDark ? Colors.white54 : Colors.black54,
              ),
              onClear: () {
                controller.selectedResults = "";
              },
              menuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onChanged: (newResult) {
                searchState(() {
                  controller.selectedResults = newResult;
                });
                //
                // controller.update();
                // print('selectedSearch_${selectedSearch}');
                //controller.updateLocationSearchedItem(newLocation);
              },
              dialogBox: false,
              isExpanded: true,
              closeButton: 'change_location_close'.tr,
              displayClearIcon: true,
              // onClear: (){
              //controller.locationSearchSelected = '';
              // },
              menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
            );
          },
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  static Container _ListResults(
      BuildContext context, AllReportsController controller) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: StateBuilder<AllReportsController>(
        key: UniqueKey(),
        id: controller.listResultsFilterId,
        disableState: false,
        onRetryFunction: () {},
        // noResultView: ,
        // loadingView: ,
        // errorView: ,
        initialWidgetState: WidgetState.loaded,
        builder: (widgetState, controllers) {
          return controller.resultsFilter.isEmpty
              ? const SizedBox()
              : ScreenSizer(
                  builder: (customSize) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: SizedBox(
                        width: customSize
                            .screenWidth, //MediaQuery.of(context).size.width
                        height: 80,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(4),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.resultsFilter.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                height: 80,
                                child: NeumorphicContainer(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    padding: const EdgeInsets.all(16),
                                    isEffective: true,
                                    isInnerShadow: false,
                                    duration: const Duration(milliseconds: 300),
                                    borderRadius: BorderRadius.circular(18),
                                    onTab: () {
                                      controller.resultsFilter.removeAt(index);
                                      controller.updateState(
                                          [controller.listResultsFilterId],
                                          WidgetState.loaded);
                                    },
                                    child: Center(
                                      child: Text(
                                        controller.resultsFilter[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  static SizedBox _priorityDropdown(
      BuildContext context, AllReportsController controller) {
    return SizedBox(
        width: 350,
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
          duration: Duration.zero,
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
                  hintText: 'الأولوية',
                ),
                items: controller.priorities.map((priority) {
                  return DropdownMenuItem(
                    onTap: () {
                      if (!controller.prioritiesFilter.contains(priority)) {
                        controller.prioritiesFilter.add(priority);
                        controller.updateState(
                            [controller.listPriorityFilterId],
                            WidgetState.loaded);
                      }
                    },
                    value: priority.color,
                    child: Text(
                      priority.color,
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                value: controller.selectedPriority,
                hint: Text(
                  'الأولوية',
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
                clearIcon: Icon(
                  Icons.clear,
                  color: controller.isDark ? Colors.white54 : Colors.black54,
                ),
                onClear: () {
                  controller.selectedPriority = "";
                },
                menuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                onChanged: (newPriority) {
                  searchState(() {
                    controller.selectedPriority = newPriority;
                  });
                  //
                  // controller.update();
                  // print('selectedSearch_${selectedSearch}');
                  //controller.updateLocationSearchedItem(newLocation);
                },
                dialogBox: false,
                isExpanded: true,
                closeButton: 'change_location_close'.tr,
                displayClearIcon: true,
                // onClear: (){
                //controller.locationSearchSelected = '';
                // },
                menuConstraints:
                    BoxConstraints.tight(const Size.fromHeight(350)),
              );
            },
          ),
        ));
  }

  static Container _listPriorities(
      BuildContext context, AllReportsController controller) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: StateBuilder<AllReportsController>(
        key: UniqueKey(),
        id: controller.listPriorityFilterId,
        disableState: false,
        onRetryFunction: () {},
        // noResultView: ,
        // loadingView: ,
        // errorView: ,
        initialWidgetState: WidgetState.loaded,
        builder: (widgetState, controllers) {
          return controller.prioritiesFilter.isEmpty
              ? const SizedBox()
              : ScreenSizer(
                  builder: (customSize) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: SizedBox(
                        width: customSize
                            .screenWidth, //MediaQuery.of(context).size.width
                        height: 80,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(4),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.prioritiesFilter.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                height: 80,
                                child: NeumorphicContainer(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    padding: const EdgeInsets.all(16),
                                    isEffective: true,
                                    isInnerShadow: false,
                                    duration: const Duration(milliseconds: 300),
                                    borderRadius: BorderRadius.circular(18),
                                    onTab: () {
                                      controller.prioritiesFilter
                                          .removeAt(index);
                                      controller.updateState(
                                          [controller.listPriorityFilterId],
                                          WidgetState.loaded);
                                    },
                                    child: Center(
                                      child: Text(
                                        controller
                                            .prioritiesFilter[index].color,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  static SizedBox _TypesDropdown(
      BuildContext context, AllReportsController controller) {
    return SizedBox(
        width: 350,
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
          duration: Duration.zero,
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
                  hintText: 'النوع',
                ),
                items: controller.types.map((type) {
                  return DropdownMenuItem(
                    onTap: () {
                      if (!controller.typesFilter.contains(type)) {
                        controller.typesFilter.add(type);
                        controller.updateState(
                            [controller.listTypeFilterId], WidgetState.loaded);
                      }
                    },
                    value: type.name,
                    child: Text(
                      type.name,
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                value: controller.selectedType,
                hint: Text(
                  'النوع',
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
                clearIcon: Icon(
                  Icons.clear,
                  color: controller.isDark ? Colors.white54 : Colors.black54,
                ),
                onClear: () {
                  controller.selectedType = "";
                },
                menuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                onChanged: (newType) {
                  searchState(() {
                    controller.selectedType = newType;
                  });
                  //
                  // controller.update();
                  // print('selectedSearch_${selectedSearch}');
                  //controller.updateLocationSearchedItem(newLocation);
                },
                dialogBox: false,
                isExpanded: true,
                closeButton: 'change_location_close'.tr,
                displayClearIcon: true,
                // onClear: (){
                //controller.locationSearchSelected = '';
                // },
                menuConstraints:
                    BoxConstraints.tight(const Size.fromHeight(350)),
              );
            },
          ),
        ));
  }

  static Container _listTypes(
      BuildContext context, AllReportsController controller) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: StateBuilder<AllReportsController>(
        key: UniqueKey(),
        id: controller.listTypeFilterId,
        disableState: false,
        onRetryFunction: () {},
        // noResultView: ,
        // loadingView: ,
        // errorView: ,
        initialWidgetState: WidgetState.loaded,
        builder: (widgetState, controllers) {
          return controller.typesFilter.isEmpty
              ? const SizedBox()
              : ScreenSizer(
                  builder: (customSize) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: SizedBox(
                        width: customSize
                            .screenWidth, //MediaQuery.of(context).size.width
                        height: 80,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(4),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.typesFilter.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                height: 80,
                                child: NeumorphicContainer(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    padding: const EdgeInsets.all(16),
                                    isEffective: true,
                                    isInnerShadow: false,
                                    duration: const Duration(milliseconds: 300),
                                    borderRadius: BorderRadius.circular(18),
                                    onTab: () {
                                      controller.typesFilter.removeAt(index);
                                      controller.updateState(
                                          [controller.listTypeFilterId],
                                          WidgetState.loaded);
                                    },
                                    child: Center(
                                      child: Text(
                                        controller.typesFilter[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
