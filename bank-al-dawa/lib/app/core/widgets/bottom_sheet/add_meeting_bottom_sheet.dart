import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../modules/dashboard/calendar/calendar_controller.dart';
import '../neumorphic_container.dart';

class AddMeetingBottomSheet {
  static Future<void> showAddMeetingDialog(
      BuildContext context, CalendarController controller) async {
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
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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

                  ////////////////////////////// * Title Add Meeting * //////////////////////////////
                  _addMeetingTitle(context),
                  const SizedBox(
                    height: 15,
                  ),

                  ////////////////////////////// * Meeting At text * //////////////////////////////
                  _meetingDateTitle(context, controller),
                  const SizedBox(
                    height: 20,
                  ),

                  ////////////////////////////// * Address TextField  * //////////////////////////////
                  _addressTextField(context, controller),
                  const SizedBox(
                    height: 15,
                  ),

                  ////////////////////////////// * Details TextField  * //////////////////////////////
                  _detailsTextField(context, controller),
                  const SizedBox(
                    height: 15,
                  ),

                  ////////////////////////////// * Add Meeting Button  * //////////////////////////////
                  _addMeetingButton(context, controller),
                  const SizedBox(
                    height: 10,
                  ),

                  ////////////////////////////// * Caption Text  * //////////////////////////////
                  _captionText(context),
                  const SizedBox(
                    height: 180,
                  ),
                ],
              ),
            );
          }),
    );
  }

  static Padding _addressTextField(
      BuildContext context, CalendarController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
      child: NeumorphicContainer(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        borderRadius: BorderRadius.circular(16),
        onTab: () {},
        isInnerShadow: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: TextFormField(
          controller: controller.titleController,
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
              labelText:
                  'calendar_add_meeting_address_textField_ensure_password_label'
                      .tr,
              hintText:
                  'calendar_add_meeting_address_textField_ensure_password_hint'
                      .tr,
              floatingLabelBehavior: FloatingLabelBehavior.never, //always
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
          // inputFormatters: <TextInputFormatter>[
          //   FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
          // ],
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'calendar_add_meeting_address_textField_empty'.tr;
            }
            return null;
          },
        ),
      ),
    );
  }

  static Padding _addMeetingTitle(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 12, left: 24, right: 24),
        child: Text('calendar_title_bottom_sheet'.tr,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle1!));
  }

  static Padding _meetingDateTitle(
      BuildContext context, CalendarController controller) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 12, left: 24, right: 24),
        child: Text(
            '${'calendar_meeting_at_bottom_sheet'.tr}: ${DateFormat('yyyy-MM-dd').format(controller.selectedDateTime)}',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline6!));
  }

  static Padding _detailsTextField(
      BuildContext context, CalendarController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
      child: NeumorphicContainer(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        borderRadius: BorderRadius.circular(16),
        onTab: () {},
        isInnerShadow: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: TextFormField(
          controller: controller.descriptionController,
          enableSuggestions: true,
          readOnly: false,
          maxLines: 2,
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
              labelText:
                  'calendar_add_meeting_details_textField_ensure_password_label'
                      .tr,
              hintText:
                  'calendar_add_meeting_details_textField_ensure_password_hint'
                      .tr,
              floatingLabelBehavior: FloatingLabelBehavior.never, //always
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Icon(
                    Icons.details,
                    color: Theme.of(context).primaryColor,
                  ))),
          keyboardType: TextInputType.text,
          // inputFormatters: <TextInputFormatter>[
          //   FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
          // ],
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'calendar_add_meeting_details_textField_empty'.tr;
            }
            return null;
          },
        ),
      ),
    );
  }

  static Padding _addMeetingButton(
      BuildContext context, CalendarController controller) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: NeumorphicContainer(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        borderRadius: BorderRadius.circular(16),
        onTab: () {
          //Create new meeting
          controller.createMeeting(context);
        },
        isInnerShadow: false,
        isEffective: true,
        duration: const Duration(milliseconds: 300),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Text(
          'calendar_bottom_sheet_button'.tr,
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
    );
  }

  static Padding _captionText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        'calendar_bottom_sheet_caption'.tr,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
