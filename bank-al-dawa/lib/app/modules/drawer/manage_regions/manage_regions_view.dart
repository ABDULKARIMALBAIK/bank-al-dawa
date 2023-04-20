import 'package:bank_al_dawa/app/core/constants/colors.dart';
import 'package:bank_al_dawa/app/core/models/app_models/region_model.dart';
import 'package:bank_al_dawa/app/core/widgets/neumorphic_container.dart';
import 'package:bank_al_dawa/app/modules/drawer/manage_regions/manage_regions_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/request_manager.dart';
import '../../../core/services/size_configration.dart';
import '../../../core/widgets/no_resulte.dart';
import '../../../core/widgets/widget_state.dart';

// ignore: must_be_immutable
class ManageRegionsView extends GetView<ManageRegionsController> {
  const ManageRegionsView({Key? key}) : super(key: key);

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
                                50, //customSize.setHeight(75),
                                'change_location_title'.tr),
                          ];
                        },
                        body: _body(context, customSize.screenWidth,
                            customSize.screenHeight)),
                  ],
                ),
              );
            },
          )),
    );
  }

  /* Widgets Methods */

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

              ////////////////////////////// *  Add region Button * //////////////////////////////
              Align(
                alignment: Alignment.centerLeft,
                child: _buttonAddRegion(context),
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

  SizedBox _buttonAddRegion(BuildContext context) {
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
            Icons.add,
            size: 28,
            color: controller.isDark ? Colors.black54 : Colors.white,
          ),
        ),
        onPressed: () async {
          showDialogAddUpdateRegion(context);
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
          ////////////////////////////// * Reports * //////////////////////////////
          child: StateBuilder<ManageRegionsController>(
              key: UniqueKey(),
              id: controller.listRegionBuild,
              disableState: false,
              onRetryFunction: () {
                controller.loadRegions(requestType: RequestType.refresh);
              },
              noResultView: const NoResults(),
              // loadingView: ,
              // errorView: ,
              initialWidgetState: WidgetState.loading,
              builder: (widgetState, controllers) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.regions.length,
                  itemBuilder: (context, index) =>
                      _regionItem(context, controller.regions[index]),
                );
              })),
    );
  }

  Padding _regionItem(BuildContext context, RegionModel region) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: NeumorphicContainer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
          isEffective: true,
          isInnerShadow: false,
          duration: const Duration(milliseconds: 300),
          borderRadius: BorderRadius.circular(16),
          onTab: () {
            showDialogAddUpdateRegion(context, region: region);
            // showDialogDelete(context, region);
          },
          child: Center(
            child: Text(
              region.name,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  void showDialogDelete(BuildContext context, RegionModel region) {
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
            'حذف المنطقة',
            style: Theme.of(context).textTheme.headline6,
          ),
          content: Text(
            'هل تريد منطقة ${region.name} ؟',
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
                await controller.deleteRegion(region);
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

  void showDialogAddUpdateRegion(BuildContext context, {RegionModel? region}) {
    //Update Region
    if (region != null) {
      controller.addRegionController.text = region.name;
    }
    //Add Region
    else {
      controller.addRegionController.clear();
    }

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
            'اضافة المنطقة',
            style: Theme.of(context).textTheme.headline6,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اكتب اسم المنطقة الجديد :',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: NeumorphicContainer(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    borderRadius: BorderRadius.circular(16),
                    onTab: () {},
                    isInnerShadow: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: TextFormField(
                      controller: controller.addRegionController,
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
                          labelText: 'اسم المنطقة',
                          hintText: 'اسم المنطقة',
                          floatingLabelBehavior:
                              FloatingLabelBehavior.never, //always
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Icon(
                                Icons.location_on_outlined,
                                color: Theme.of(context).primaryColor,
                              ))),
                      keyboardType: TextInputType.text,
                    )),
              ),
            ],
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
                //Update Region
                if (region != null) {
                  await controller.updateRegion(region);
                }
                //Add Region
                else {
                  await controller.addRegion();
                }
                // ignore: use_build_context_synchronously
                Get.back();
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
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
