import 'package:bank_al_dawa/app/core/constants/colors.dart';
import 'package:bank_al_dawa/app/core/helper/data_helper.dart';
import 'package:bank_al_dawa/app/core/models/user_models/user_model.dart';
import 'package:bank_al_dawa/app/core/services/size_configration.dart';
import 'package:bank_al_dawa/app/core/widgets/neumorphic_container.dart';
import 'package:bank_al_dawa/app/core/widgets/pagination.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';

import '../../../core/services/request_manager.dart';
import '../../../core/widgets/widget_state.dart';
import 'manage_accounts_controller.dart';

// ignore: must_be_immutable
class ManageAccountsView extends GetView<ManageAccountsController> {
  const ManageAccountsView({Key? key}) : super(key: key);

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
                      _headerText(context, customSize.screenWidth,
                          'manage_accounts_title'.tr)
                    ];
                  },
                  body: _body(context, customSize.screenWidth,
                      customSize.screenHeight)),
            );
          },
        ),
      ),
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

  SliverToBoxAdapter _headerText(
      BuildContext context, double screenWidth, String text) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: screenWidth,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Container _body(
      BuildContext context, double screenWidth, double screenHeight) {
    return Container(
        width: screenWidth,
        height: screenHeight,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: StateBuilder<ManageAccountsController>(
          id: controller.stateId,
          onRetryFunction: () {
            controller.getAccounts(requestType: RequestType.refresh);
          },
          builder: (widgetState, controllers) {
            return PaginationBuilder<ManageAccountsController>(
                id: controller.statePaginationId,
                onRefresh: () =>
                    controller.getAccounts(requestType: RequestType.refresh),
                onLoadingMore: () => controller.getAccounts(
                    requestType: RequestType.loadingMore),
                builder: (scrollController) {
                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.only(top: 20),
                    physics: const BouncingScrollPhysics(),
                    // itemCount: controller.accounts.length,
                    itemCount: controller.dataList.length,
                    itemBuilder: (context, index) => _accountItem(
                        context,
                        controller
                            .dataList[index]), // controller.accounts[index]
                  );
                });
          },
        ));
  }

  Padding _accountItem(BuildContext context, User model) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            //////////////////////// * Card data * ////////////////////////
            NeumorphicContainer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.only(
                  top: 32, left: 16, right: 16, bottom: 12),
              isEffective: true,
              isInnerShadow: false,
              duration: const Duration(milliseconds: 250),
              borderRadius: BorderRadius.circular(18),
              onTab: () {
                //Go to Edit Account (Register Account)
                DataHelper.accountUser = model;
                controller.goToRegisterAccount();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),

                  ////////////////////// * Username * //////////////////////////
                  _userText(context, '${'manage_accounts_username'.tr}: ',
                      model.name), //': يسرى دمشقي'
                  const SizedBox(
                    height: 4,
                  ),

                  //////////////////////////////// * PhoneNumber * /////////////////////////////////
                  _userText(context, '${'manage_accounts_phoneNumber'.tr}: ',
                      model.phone), //'094235123 :  '
                  const SizedBox(
                    height: 4,
                  ),

                  ////////////////////////////////// * accessibility * //////////////////////////////////
                  _userText(
                      context,
                      '${'manage_accounts_accessibility'.tr}: ',
                      model.permission!
                          .name), //': مدير'   getPermissionState(model.permission.name)
                  const SizedBox(
                    height: 4,
                  ),

                  ////////////////////////////////// * region * //////////////////////////////////
                  _userText(
                      context,
                      '${'manage_accounts_region'.tr}: ',
                      (model.regions == null || model.regions!.isEmpty)
                          ? ''
                          : model.regions![0]
                              .name), //': الفرقان'  ?????????????????????????????????????????????????
                  const SizedBox(
                    height: 1,
                  ),

                  ////////////////////////////////// * delete account button * ///////////////////////////////////
                  _deleteButton(context, model)
                ],
              ),
            ),

            ////////////////////////////////// * Photo * ///////////////////////////////////
            _userPhoto(context, model)
          ],
        ));
  }

  Positioned _userPhoto(BuildContext context, User model) {
    return Positioned(
      top: -55,
      child: NeumorphicContainer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(2),
          isEffective: false,
          isInnerShadow: false,
          duration: const Duration(milliseconds: 300),
          borderRadius: BorderRadius.circular(300),
          onTab: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(300),
            child: OctoImage(
              height: 100,
              width: 100,
              image: CachedNetworkImageProvider(model.imageUrl),
              placeholderBuilder: (context) {
                return Container(
                  color: Theme.of(context).backgroundColor,
                  height: 60,
                  width: 60,
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 55,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              },
              errorBuilder: OctoError.icon(color: Colors.red),
              fit: BoxFit.cover,
              fadeInCurve: Curves.easeIn,
              fadeOutCurve: Curves.easeOut,
              fadeInDuration: const Duration(milliseconds: 300),
              fadeOutDuration: const Duration(milliseconds: 300),
              placeholderFadeInDuration: const Duration(milliseconds: 300),
            ),
          )),
    );
  }

  RichText _userText(context, String title, String description) {
    return RichText(
      text: TextSpan(
          text: title,
          style: Theme.of(context).textTheme.bodyText2,
          children: [
            TextSpan(
              text: description,
            )
          ]),
    );
  }

  SizedBox _deleteButton(BuildContext context, User model) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: Stack(
        children: [
          Positioned(
            left: 15,
            child: NeumorphicContainer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(16),
              isEffective: true,
              isInnerShadow: false,
              duration: const Duration(milliseconds: 300),
              borderRadius: BorderRadius.circular(18),
              onTab: () {
                _showDialogDelete(context, model);
              },
              child: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getPermissionState(String permissionId) {
    String state = 'register_job_employee'.tr;
    switch (permissionId) {
      case '1':
        {
          state = 'register_job_employee'.tr;
          break;
        }
      case '2':
        {
          state = 'register_job_viewer'.tr;
          break;
        }
      case '3':
        {
          state = 'register_job_manager'.tr;
          break;
        }
    }

    return state;
  }

  void _showDialogDelete(BuildContext context, User model) {
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
            'manage_accounts_dialog_delete_description'.tr,
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
                Navigator.pop(context);
                controller.deleteAccount(model);
              },
            ),
            // NeumorphicContainer(
            //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //   padding: const EdgeInsets.all(9),
            //   isEffective: true,
            //   isInnerShadow: false,
            //   duration: const Duration(milliseconds: 200),
            //   borderRadius: BorderRadius.circular(18),
            //   onTab: () {
            //     //Delete the report and refresh the list and scroll to previews report
            //     Navigator.pop(context);
            //     controller.deleteAccount(model);
            //   },
            //   child: Text(
            //     'dialog_yes'.tr,
            //     style: Theme.of(context).textTheme.button,
            //     maxLines: 1,
            //     textAlign: TextAlign.center,
            //   ),
            // ),

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
            // NeumorphicContainer(
            //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //   padding: const EdgeInsets.all(9),
            //   isEffective: true,
            //   isInnerShadow: false,
            //   duration: const Duration(milliseconds: 300),
            //   borderRadius: BorderRadius.circular(18),
            //   onTab: () {
            //     //Close Dialog
            //     Navigator.pop(context);
            //   },
            //   child: Text(
            //     'dialog_cancel'.tr,
            //     style: Theme.of(context).textTheme.button,
            //     maxLines: 1,
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
