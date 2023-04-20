import 'package:bank_al_dawa/app/modules/dashboard/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_choices/search_choices.dart';

import '../../helper/data_helper.dart';
import '../neumorphic_container.dart';

class ChangeRegionBottomSheet {
  static Future<void> showDialog(
      BuildContext context, HomeController controller) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
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

                  ////////////////////////////// * Title * //////////////////////////////
                  _title(context),
                  const SizedBox(
                    height: 15,
                  ),

                  ////////////////////////////// * Subtitle * //////////////////////////////
                  _subtitle(context),
                  const SizedBox(
                    height: 15,
                  ),

                  ////////////////////////////// * Regions Dropdown TextField  * //////////////////////////////
                  _dropdownRegions(context, controller),
                  const SizedBox(
                    height: 15,
                  ),

                  ////////////////////////////// * Add Meeting Button  * //////////////////////////////
                  _button(context, controller),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }),
    );
  }

  static Padding _title(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 12, left: 24, right: 24),
        child: Text('تغيير المنطقة',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle1!));
  }

  static Padding _subtitle(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 12, left: 24, right: 24),
        child: Text('اختر منطقة جديدة للعمل',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: Theme.of(context).textTheme.headline6!));
  }

  static Padding _button(BuildContext context, HomeController controller) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: NeumorphicContainer(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        borderRadius: BorderRadius.circular(16),
        onTab: () {
          //Transfer Reports
          controller.changeRegion(context);
        },
        isInnerShadow: false,
        isEffective: true,
        duration: const Duration(milliseconds: 300),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'تغيير',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  static Padding _dropdownRegions(
      BuildContext context, HomeController controller) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GetBuilder<HomeController>(
        id: controller.changeRegionBottomSheetId,
        builder: (controllers) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    rightToLeft: controller.isArabic == 'arabic',
                    style: Theme.of(context).textTheme.bodyText2,
                    searchInputDecoration: InputDecoration(
                      iconColor: Theme.of(context).primaryColor,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      // labelStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).canvasColor),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Theme.of(context).canvasColor),
                      // labelText: "change_location_search_hint_title".tr,
                      hintText: "change_location_search_hint_title".tr,
                    ),
                    items: DataHelper.regions.map((location) {
                      return DropdownMenuItem(
                        value: location.name,
                        child: Text(
                          location.name,
                          style: Theme.of(context).textTheme.bodyText1,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    value: controller.changeRegionId,
                    hint: Text(
                      "change_location_search_hint_title".tr,
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
                    menuBackgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    onChanged: (newLocation) {
                      searchState(() {
                        controller.changeRegionId = newLocation;
                      });
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
            ),
          );
        },
      ),
    );
  }
}
