import 'package:bank_al_dawa/app/modules/dashboard/non_delivered_reports/non_delivered_reports_controller.dart';
import 'package:bank_al_dawa/app/modules/dashboard/rating_report/rating_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../modules/dashboard/all_reports/all_reports_controller.dart';

class PhoneBottomSheet {
  static Future<void> showPickerDialog(BuildContext context, String phoneNumber,
      {NonDeliveredReportsController? nonDeliveredController,
      AllReportsController? controller,
      RatingReportController? ratingReportController}) async {
    await showModalBottomSheet(
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
          animationController: nonDeliveredController != null
              ? nonDeliveredController.bottomSheetAnimationController
              : ratingReportController != null
                  ? ratingReportController.bottomSheetAnimationController
                  : controller!.bottomSheetAnimationController,
          onClosing: () {},
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 10,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          clipBehavior: Clip.antiAlias,
          builder: (context) {
            return SingleChildScrollView(
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
                  _phoneTitle(context),
                  const SizedBox(
                    height: 20,
                  ),

                  ////////////////////////////// * Buttons * //////////////////////////////
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _phoneCall(context, controller, nonDeliveredController,
                          ratingReportController, phoneNumber),
                      const SizedBox(
                        width: 10,
                      ),
                      _phoneMessage(context, controller, nonDeliveredController,
                          ratingReportController, phoneNumber),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            );
          }),
    );
  }

  static Padding _phoneTitle(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 12, left: 24, right: 24),
        child: Text('all_reports__title_bottom_sheet'.tr,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline6!));
  }

  static SizedBox _phoneCall(
      BuildContext context,
      AllReportsController? controller,
      NonDeliveredReportsController? nonDeliveredController,
      RatingReportController? ratingReportController,
      String phoneNumber) {
    return SizedBox(
      width: 150,
      height: 60,
      child: OutlinedButton.icon(
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
        label: Text(
          'all_reports__call_bottom_sheet'.tr,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Theme.of(context)
                  .primaryColor), //color: Theme.of(context).primaryColor
        ),
        icon: Icon(
          Icons.phone,
          color: Theme.of(context).primaryColor,
          size: 30,
        ),
        onPressed: () async {
          if (nonDeliveredController != null) {
            nonDeliveredController.callOperation(phoneNumber);
          } else if (ratingReportController != null) {
            ratingReportController.callOperation(phoneNumber);
          } else {
            controller!.callOperation(phoneNumber);
          }
        },
      ),
    );
  }

  static SizedBox _phoneMessage(
      BuildContext context,
      AllReportsController? controller,
      NonDeliveredReportsController? nonDeliveredController,
      RatingReportController? ratingReportController,
      String phoneNumber) {
    return SizedBox(
      width: 150,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(4),
          elevation: 0,
          side: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(300),
          ),
          shadowColor: Colors.transparent,
        ),
        label: Text(
          'all_reports__message_bottom_sheet'.tr,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.white,
              ), //color: Theme.of(context).primaryColor
        ),
        icon: const Icon(
          Icons.message,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () async {
          if (nonDeliveredController != null) {
            nonDeliveredController.messageOperation(phoneNumber);
          } else if (ratingReportController != null) {
            ratingReportController.messageOperation(phoneNumber);
          } else {
            controller!.messageOperation(phoneNumber);
          }
        },
      ),
    );
  }
}
