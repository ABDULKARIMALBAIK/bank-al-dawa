import 'package:bank_al_dawa/app/core/helper/data_helper.dart';
import 'package:bank_al_dawa/app/core/widgets/bottom_sheet/pick_image_bottom_sheet.dart';
import 'package:bank_al_dawa/app/core/widgets/bottom_sheet/transfer_reports_bottom_sheet%20copy.dart';
import 'package:bank_al_dawa/app/core/widgets/neumorphic_container.dart';
import 'package:bank_al_dawa/app/core/widgets/widget_state.dart';
import 'package:bank_al_dawa/app/modules/authentication/register/register_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';
import 'package:search_choices/search_choices.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ////////////////////////////// *  Title * //////////////////////////////
                    const SizedBox(
                      height: 40,
                    ),
                    _registerTitle(context),
                    const SizedBox(
                      height: 25,
                    ),

                    ////////////////////////////// *  Employee Image * //////////////////////////////
                    _employeePhoto(context),
                    const SizedBox(
                      height: 4,
                    ),

                    ////////////////////////////// *  TextFields * //////////////////////////////
                    _textField(context),
                    const SizedBox(
                      height: 10,
                    ),

                    ////////////////////////////// *  Job * //////////////////////////////
                    _jobs(context),
                    const SizedBox(
                      height: 20,
                    ),

                    ////////////////////////////// *  Regions * //////////////////////////////
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 2),
                            child: _titleTextFields(
                                context, 'register_title_regions'.tr)),
                        const SizedBox(
                          height: 6,
                        ),
                        GetBuilder<RegisterController>(
                          id: controller.regionsId,
                          builder: (controllers) {
                            return _dropdown(context);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    ////////////////////////////// * Transfer Report Button * //////////////////////////////
                    controller.isFromManageAccounts
                        ? _transferReportsButton(context)
                        : const SizedBox(),
                    const SizedBox(
                      height: 30,
                    ),

                    ////////////////////////////// *  Button * //////////////////////////////
                    _registerButton(context),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /* Widget methods */

  GetBuilder _registerTitle(BuildContext context) {
    return GetBuilder<RegisterController>(
      id: controller.titleId,
      builder: (controllers) {
        return Text(
          controller.isFromManageAccounts
              ? 'register_edit_title'.tr
              : 'register_title'.tr,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline5!.copyWith(shadows: [
            Shadow(color: Theme.of(context).primaryColor, blurRadius: 4)
          ], color: Theme.of(context).primaryColor),
        );
      },
    );
  }

  Container _textField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      width: MediaQuery.of(context).size.width,
      child: AutofillGroup(
        child: Form(
          key: controller.formRegisterKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //////////////////////// * Username TextField * ////////////////////////
              _titleTextFields(context, 'register_username'.tr),
              UsernameTextField(controller),
              // NeumorphicContainer(
              //   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              //   borderRadius: BorderRadius.circular(16),
              //   onTab: () {},
              //   isInnerShadow: true,
              //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              //   child: UsernameTextField(controller),
              // ),
              const SizedBox(
                height: 12,
              ),

              //////////////////////// * Password TextField   * ////////////////////////
              _titleTextFields(context, 'register_password'.tr),
              PasswordTextField(controller),
              // NeumorphicContainer(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              //     borderRadius: BorderRadius.circular(16),
              //     onTab: () {},
              //     isInnerShadow: true,
              //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              //     child: PasswordTextField(controller)),
              const SizedBox(
                height: 12,
              ),

              //////////////////////// * Ensure Password TextField  * ////////////////////////
              _titleTextFields(context, 'register_ensure_password'.tr),
              EnsurePasswordTextField(controller),
              // NeumorphicContainer(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              //     borderRadius: BorderRadius.circular(16),
              //     onTab: () {},
              //     isInnerShadow: true,
              //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              //     child: EnsurePasswordTextField(controller)),
              const SizedBox(
                height: 12,
              ),

              //////////////////////// * PhoneNumber TextField  * ////////////////////////
              _titleTextFields(context, 'register_phoneNumber'.tr),
              PhoneNumberTextField(controller),
              // NeumorphicContainer(
              //   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              //   borderRadius: BorderRadius.circular(16),
              //   onTab: () {},
              //   isInnerShadow: true,
              //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              //   child: PhoneNumberTextField(controller),
              // ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _titleTextFields(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyText1!,
      ),
    );
  }

  Padding _jobs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
      child: Wrap(
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.horizontal,
        runSpacing: 15,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'register_job'.tr,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1!,
          ),
          const SizedBox(
            width: 30,
          ),
          SizedBox(
              child: GetBuilder<RegisterController>(
            id: controller.jobStateId,
            builder: (controllers) {
              return JobsStates(controller: controller);
            },
          )),
        ],
      ),
    );
  }

  SizedBox _registerButton(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 60,
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
            'register_button'.tr,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(), //color: Theme.of(context).primaryColor
          ),
          onPressed: () {
            controller.register();
          },
        ),
      ),
    );
  }

  SizedBox _transferReportsButton(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 60,
      child: NeumorphicContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.symmetric(horizontal: 0),
        borderRadius: BorderRadius.circular(120),
        onTab: () {},
        isInnerShadow: false,
        isEffective: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(4),
            elevation: 0,
            side: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(300),
            ),
            shadowColor: Colors.transparent,
          ),
          child: Text(
            'نقل التقارير',
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.white), //color: Theme.of(context).primaryColor
          ),
          onPressed: () {
            TransferReportsBottomSheet.showDialog(
                context, controller, DataHelper.accountUser!);
          },
        ),
      ),
    );
  }

  Padding _employeePhoto(BuildContext context) {
    /*
    Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 150,
        height: 150,
        child: StateBuilder<RegisterController>(
          id: controller.imageBuilderId,
          disableState: false,
          // onRetryFunction: ,
          // noResultView: ,
          loadingView: NeumorphicContainer(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(0),
            isEffective: true,
            isInnerShadow: false,
            duration: const Duration(milliseconds: 250),
            borderRadius: BorderRadius.circular(400),
            onTab: () {
              //Show Bottom Sheet
              PickImageBottomSheet.showImagePickerDialog(context, controller);
            },
            child: SizedBox(
              width: 150,
              height: 150,
              // color: Theme.of(context).backgroundColor,
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          // errorView: ,
          initialWidgetState: WidgetState.loading,
          builder: (widgetState, controllers) {
            return _loadImageChecker(context);
          },
        ),
      ),
    );
     */

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 150,
        height: 150,
        child: StateBuilder<RegisterController>(
          id: controller.imageBuilderId,
          disableState: false,
          // onRetryFunction: ,
          // noResultView: ,
          loadingView: GestureDetector(
            onTap: () {
              //Show Bottom Sheet
              PickImageBottomSheet.showImagePickerDialog(context, controller);
            },
            child: AnimatedContainer(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 6),
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(400),
              ),
              padding: const EdgeInsets.all(0),
              duration: const Duration(milliseconds: 250),
              child: SizedBox(
                width: 150,
                height: 150,
                // color: Theme.of(context).backgroundColor,
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          // errorView: ,
          initialWidgetState: WidgetState.loading,
          builder: (widgetState, controllers) {
            return _loadImageChecker(context);
          },
        ),
      ),
    );
  }

  Padding _dropdown(BuildContext context) {
    /*
      Padding(
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
              value: controller.locationSearchSelected,
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
              menuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onChanged: (newLocation) {
                searchState(() {
                  controller.locationSearchSelected = newLocation;
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
              menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
            );
          },
        ),
      ),
    );
    
     */

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              value: controller.locationSearchSelected,
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
              menuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onChanged: (newLocation) {
                searchState(() {
                  controller.locationSearchSelected = newLocation;
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
              menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
            );
          },
        ),
      ),
    );
  }

  Widget _loadImageChecker(BuildContext context) {
    /*
      if (controller.isFromManageAccounts) {
      return NeumorphicContainer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(0),
        isEffective: true,
        isInnerShadow: false,
        duration: const Duration(milliseconds: 250),
        borderRadius: BorderRadius.circular(400),
        onTab: () {
          //Show Bottom Sheet
          PickImageBottomSheet.showImagePickerDialog(context, controller);
        },
        child: ClipOval(
          child: controller.imagePath != null
              ? Image.file(
                  controller.imagePath!,
                  // errorBuilder: (a , b , c) => GestureDetector(
                  //   onTap: (){
                  //     //Show Bottom Sheet
                  //     PickImageBottomSheet.showImagePickerDialog(context, controller);
                  //   },
                  //   child: SizedBox(
                  //     width: 150,
                  //     height: 150,
                  //     // color: Theme.of(context).backgroundColor,
                  //     child: Center(
                  //       child: Icon(
                  //         Icons.person,
                  //         size: 50,
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                )
              : OctoImage(
                  image: CachedNetworkImageProvider(
                    DataHelper.accountUser == null
                        ? ''
                        : DataHelper.accountUser!.imageUrl,
                  ), //maxWidth: 150, maxHeight: 150
                  errorBuilder: (b, o, s) => Center(
                    child: Icon(
                      Icons.error,
                      size: 50,
                      color: controller.isDark ? Colors.redAccent : Colors.red,
                    ),
                  ),
                  placeholderBuilder: (c) => Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
        ),
      );
    } else {
      return NeumorphicContainer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(0),
        isEffective: true,
        isInnerShadow: false,
        duration: const Duration(milliseconds: 250),
        borderRadius: BorderRadius.circular(400),
        onTab: () {
          //Show Bottom Sheet
          PickImageBottomSheet.showImagePickerDialog(context, controller);
        },
        child: ClipOval(
          child: controller.imagePath != null
              ? Image.file(
                  controller.imagePath!,
                  // errorBuilder: (a , b , c) => GestureDetector(
                  //   onTap: (){
                  //     //Show Bottom Sheet
                  //     PickImageBottomSheet.showImagePickerDialog(context, controller);
                  //   },
                  //   child: SizedBox(
                  //     width: 150,
                  //     height: 150,
                  //     // color: Theme.of(context).backgroundColor,
                  //     child: Center(
                  //       child: Icon(
                  //         Icons.person,
                  //         size: 50,
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                )
              : GestureDetector(
                  onTap: () {
                    //Show Bottom Sheet
                    PickImageBottomSheet.showImagePickerDialog(
                        context, controller);
                  },
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    // color: Theme.of(context).backgroundColor,
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
        ),
      );
    }
     */

    if (controller.isFromManageAccounts) {
      return GestureDetector(
        onTap: () {
          //Show Bottom Sheet
          PickImageBottomSheet.showImagePickerDialog(context, controller);
        },
        child: AnimatedContainer(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 6),
                  color: Colors.black26,
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(400),
          ),
          padding: const EdgeInsets.all(0),
          duration: const Duration(milliseconds: 250),
          child: ClipOval(
            child: controller.imagePath != null
                ? Image.file(
                    controller.imagePath!,
                    // errorBuilder: (a , b , c) => GestureDetector(
                    //   onTap: (){
                    //     //Show Bottom Sheet
                    //     PickImageBottomSheet.showImagePickerDialog(context, controller);
                    //   },
                    //   child: SizedBox(
                    //     width: 150,
                    //     height: 150,
                    //     // color: Theme.of(context).backgroundColor,
                    //     child: Center(
                    //       child: Icon(
                    //         Icons.person,
                    //         size: 50,
                    //         color: Theme.of(context).primaryColor,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : OctoImage(
                    image: CachedNetworkImageProvider(
                      DataHelper.accountUser == null
                          ? ''
                          : DataHelper.accountUser!.imageUrl,
                    ), //maxWidth: 150, maxHeight: 150
                    errorBuilder: (b, o, s) => Center(
                      child: Icon(
                        Icons.error,
                        size: 50,
                        color:
                            controller.isDark ? Colors.redAccent : Colors.red,
                      ),
                    ),
                    placeholderBuilder: (c) => Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          //Show Bottom Sheet
          PickImageBottomSheet.showImagePickerDialog(context, controller);
        },
        child: AnimatedContainer(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 6),
                  color: Colors.black26,
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(400),
          ),
          padding: const EdgeInsets.all(0),
          duration: const Duration(milliseconds: 250),
          child: ClipOval(
            child: controller.imagePath != null
                ? Image.file(
                    controller.imagePath!,
                    // errorBuilder: (a , b , c) => GestureDetector(
                    //   onTap: (){
                    //     //Show Bottom Sheet
                    //     PickImageBottomSheet.showImagePickerDialog(context, controller);
                    //   },
                    //   child: SizedBox(
                    //     width: 150,
                    //     height: 150,
                    //     // color: Theme.of(context).backgroundColor,
                    //     child: Center(
                    //       child: Icon(
                    //         Icons.person,
                    //         size: 50,
                    //         color: Theme.of(context).primaryColor,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : GestureDetector(
                    onTap: () {
                      //Show Bottom Sheet
                      PickImageBottomSheet.showImagePickerDialog(
                          context, controller);
                    },
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      // color: Theme.of(context).backgroundColor,
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      );
    }
  }
}

/* Password TextField Class */

// ignore: must_be_immutable
class PasswordTextField extends StatefulWidget {
  bool isSecurePassword = true;
  RegisterController controller;

  PasswordTextField(this.controller, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: const [AutofillHints.password],
      controller: widget.controller.passwordController,
      obscureText: widget.isSecurePassword,
      autocorrect: true,
      enableSuggestions: true,
      readOnly: false,
      textInputAction: TextInputAction.next,
      cursorColor: Theme.of(context).primaryColor,
      style: Theme.of(context).textTheme.subtitle1,
      decoration: InputDecoration(
        hintStyle: TextStyle(
            color:
                Theme.of(context).textTheme.subtitle1!.color!.withOpacity(0.5)),
        labelStyle: TextStyle(
            color:
                Theme.of(context).textTheme.subtitle1!.color!.withOpacity(0.5)),
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

        // border: InputBorder.none,
        // focusedBorder: InputBorder.none,
        // enabledBorder: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.never, //always

        labelText: 'register_textField_password_label'.tr,
        hintText: 'register_textField_password_hint'.tr,

        prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.vpn_key_outlined,
              color: Theme.of(context).primaryColor,
            )),
        suffixIcon: IconButton(
          icon: Icon(widget.isSecurePassword
              ? Icons.visibility
              : Icons.visibility_off),
          color: Theme.of(context).primaryColor,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onPressed: () {
            widget.isSecurePassword = !widget.isSecurePassword;
            setState(() {});
          },
        ),
      ),
      keyboardType: TextInputType.text,
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
      // ],
      validator: (password) {
        if (password == null || password.isEmpty) {
          return 'register_textField_password_empty'.tr;
        }
        return null;
      },
    );
  }
}

/* Ensure Password TextField Class */

// ignore: must_be_immutable
class EnsurePasswordTextField extends StatefulWidget {
  bool isSecurePassword = true;
  RegisterController controller;

  EnsurePasswordTextField(this.controller, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnsurePasswordTextFieldState();
}

class _EnsurePasswordTextFieldState extends State<EnsurePasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: const [AutofillHints.password],
      controller: widget.controller.ensurePasswordController,
      obscureText: widget.isSecurePassword,
      autocorrect: true,
      enableSuggestions: true,
      readOnly: false,
      textInputAction: TextInputAction.next,
      cursorColor: Theme.of(context).primaryColor,
      style: Theme.of(context).textTheme.subtitle1,
      decoration: InputDecoration(
        hintStyle: TextStyle(
            color:
                Theme.of(context).textTheme.subtitle1!.color!.withOpacity(0.5)),
        labelStyle: TextStyle(
            color:
                Theme.of(context).textTheme.subtitle1!.color!.withOpacity(0.5)),
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

        // border: InputBorder.none,
        // focusedBorder: InputBorder.none,
        // enabledBorder: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.never, //always

        labelText: 'register_textField_ensure_password_label'.tr,
        hintText: 'register_textField_ensure_password_hint'.tr,

        prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.security,
              color: Theme.of(context).primaryColor,
            )),
        suffixIcon: IconButton(
          icon: Icon(widget.isSecurePassword
              ? Icons.visibility
              : Icons.visibility_off),
          color: Theme.of(context).primaryColor,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onPressed: () {
            widget.isSecurePassword = !widget.isSecurePassword;
            setState(() {});
          },
        ),
      ),
      keyboardType: TextInputType.text,
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
      // ],
      validator: (password) {
        if (password == null || password.isEmpty) {
          return 'register_textField_ensure_password_empty'.tr;
        }
        return null;
      },
    );
  }
}

/* Username TextField Class */

// ignore: must_be_immutable
class UsernameTextField extends StatelessWidget {
  UsernameTextField(this.controller, {Key? key}) : super(key: key);

  RegisterController controller;

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
          labelText: 'register_textField_username_label'.tr,
          hintText: 'register_textField_username_hint'.tr,
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
          return 'register_username_empty'.tr;
        }
        return null;
      },
    );
  }
}

/* PhoneNumber TextField Class */

// ignore: must_be_immutable
class PhoneNumberTextField extends StatelessWidget {
  PhoneNumberTextField(this.controller, {Key? key}) : super(key: key);

  RegisterController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: const [AutofillHints.telephoneNumber],
      controller: controller.phoneNumberController,
      onEditingComplete: () => TextInput.finishAutofillContext(),
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
          labelText: 'register_textField_phoneNumber_label'.tr,
          hintText: 'register_textField_phoneNumber_hint'.tr,
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

/* Job States Class */

// ignore: must_be_immutable
class JobsStates extends StatefulWidget {
  RegisterController controller;

  JobsStates({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _JobsStatesState();
}

class _JobsStatesState extends State<JobsStates> {
  /*
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: NeumorphicContainer(
            duration: const Duration(milliseconds: 500),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            borderRadius: BorderRadius.circular(16),
            onTab: () {
              if (widget.controller.isPressedEmployee) {
                widget.controller.isPressedEmployee = false;
                widget.controller.jobType = '';
                widget.controller.jobTypeId = -1;
              }
              //other jobs or empty
              else {
                widget.controller.isPressedEmployee = true;
                widget.controller.isPressedManager = false;
                widget.controller.isPressedViewer = false;
                widget.controller.jobType = 'register_job_employee'.tr;
                widget.controller.jobTypeId = 1;
              }

              setState(() {});
            },
            isInnerShadow: false,
            isEffective: true,
            backgroundColor: widget.controller.isPressedEmployee
                ? Theme.of(context).primaryColor
                : Theme.of(context).scaffoldBackgroundColor,
            child: Text(
              'register_job_employee'.tr,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: widget.controller.isPressedEmployee
                  ? Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.yellow)
                  : Theme.of(context).textTheme.bodyText2!,
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Flexible(
          child: NeumorphicContainer(
            duration: const Duration(milliseconds: 500),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            borderRadius: BorderRadius.circular(16),
            onTab: () {
              if (widget.controller.isPressedViewer) {
                widget.controller.isPressedViewer = false;
                widget.controller.jobType = '';
                widget.controller.jobTypeId = -1;
              }
              //other jobs or empty
              else {
                widget.controller.isPressedEmployee = false;
                widget.controller.isPressedManager = false;
                widget.controller.isPressedViewer = true;
                widget.controller.jobType = 'register_job_viewer'.tr;
                widget.controller.jobTypeId = 2;
              }

              setState(() {});
            },
            isInnerShadow: false,
            isEffective: true,
            backgroundColor: widget.controller.isPressedViewer
                ? Theme.of(context).primaryColor
                : Theme.of(context).scaffoldBackgroundColor,
            child: Text(
              'register_job_viewer'.tr,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: widget.controller.isPressedViewer
                  ? Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.yellow)
                  : Theme.of(context).textTheme.bodyText2!,
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Flexible(
          child: NeumorphicContainer(
            duration: const Duration(milliseconds: 500),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            borderRadius: BorderRadius.circular(16),
            onTab: () {
              if (widget.controller.isPressedManager) {
                widget.controller.isPressedManager = false;
                widget.controller.jobType = '';
                widget.controller.jobTypeId = -1;
              }
              //other jobs or empty
              else {
                widget.controller.isPressedEmployee = false;
                widget.controller.isPressedManager = true;
                widget.controller.isPressedViewer = false;
                widget.controller.jobType = 'register_job_manager'.tr;
                widget.controller.jobTypeId = 3;
              }

              setState(() {});
            },
            isInnerShadow: false,
            isEffective: true,
            backgroundColor: widget.controller.isPressedManager
                ? Theme.of(context).primaryColor
                : Theme.of(context).scaffoldBackgroundColor,
            child: Text(
              'register_job_manager'.tr,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: widget.controller.isPressedManager
                  ? Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.yellow)
                  : Theme.of(context).textTheme.bodyText2!,
            ),
          ),
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: GestureDetector(
            onTap: () {
              if (widget.controller.isPressedEmployee) {
                widget.controller.isPressedEmployee = false;
                widget.controller.jobType = '';
                widget.controller.jobTypeId = -1;
              }
              //other jobs or empty
              else {
                widget.controller.isPressedEmployee = true;
                widget.controller.isPressedManager = false;
                widget.controller.isPressedViewer = false;
                widget.controller.jobType = 'register_job_employee'.tr;
                widget.controller.jobTypeId = 1;
              }

              setState(() {});
            },
            child: AnimatedContainer(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: widget.controller.isPressedEmployee
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).scaffoldBackgroundColor,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 5),
                      color: Colors.black26,
                      blurRadius: 6,
                      spreadRadius: 0.5)
                ],
              ),
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Text(
                'register_job_employee'.tr,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: widget.controller.isPressedEmployee
                    ? Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.yellow)
                    : Theme.of(context).textTheme.bodyText2!,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              if (widget.controller.isPressedViewer) {
                widget.controller.isPressedViewer = false;
                widget.controller.jobType = '';
                widget.controller.jobTypeId = -1;
              }
              //other jobs or empty
              else {
                widget.controller.isPressedEmployee = false;
                widget.controller.isPressedManager = false;
                widget.controller.isPressedViewer = true;
                widget.controller.jobType = 'register_job_viewer'.tr;
                widget.controller.jobTypeId = 2;
              }

              setState(() {});
            },
            child: AnimatedContainer(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: widget.controller.isPressedViewer
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).scaffoldBackgroundColor,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 5),
                      color: Colors.black26,
                      blurRadius: 6,
                      spreadRadius: 0.5)
                ],
              ),
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Text(
                'register_job_viewer'.tr,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: widget.controller.isPressedViewer
                    ? Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.yellow)
                    : Theme.of(context).textTheme.bodyText2!,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              if (widget.controller.isPressedManager) {
                widget.controller.isPressedManager = false;
                widget.controller.jobType = '';
                widget.controller.jobTypeId = -1;
              }
              //other jobs or empty
              else {
                widget.controller.isPressedEmployee = false;
                widget.controller.isPressedManager = true;
                widget.controller.isPressedViewer = false;
                widget.controller.jobType = 'register_job_manager'.tr;
                widget.controller.jobTypeId = 3;
              }

              setState(() {});
            },
            child: AnimatedContainer(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: widget.controller.isPressedManager
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).scaffoldBackgroundColor,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 5),
                      color: Colors.black26,
                      blurRadius: 6,
                      spreadRadius: 0.5)
                ],
              ),
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              child: Text(
                'register_job_manager'.tr,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: widget.controller.isPressedManager
                    ? Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.yellow)
                    : Theme.of(context).textTheme.bodyText2!,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
      ],
    );
  }
}
