import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../modules/authentication/register/register_controller.dart';

class PickImageBottomSheet {
  static Future<void> showImagePickerDialog(
      BuildContext context, RegisterController controller) async {
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
                  _pickImageTitle(context),
                  const SizedBox(
                    height: 20,
                  ),

                  ////////////////////////////// * Buttons * //////////////////////////////
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _imageGallery(context, controller),
                      const SizedBox(
                        width: 10,
                      ),
                      _imageCamera(context, controller),
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

  static Padding _pickImageTitle(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 12, left: 24, right: 24),
        child: Text('register_title_bottom_sheet'.tr,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline6!));
  }

  static SizedBox _imageGallery(
      BuildContext context, RegisterController controller) {
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
          'register_button_gallery_bottom_sheet'.tr,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Theme.of(context)
                  .primaryColor), //color: Theme.of(context).primaryColor
        ),
        icon: Icon(
          Icons.broken_image_sharp,
          color: Theme.of(context).primaryColor,
          size: 30,
        ),
        onPressed: () async {
          controller.pickImage(ImageSource.gallery);
        },
      ),
    );
  }

  static SizedBox _imageCamera(
      BuildContext context, RegisterController controller) {
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
          'register_button_camera_bottom_sheet'.tr,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.white,
              ), //color: Theme.of(context).primaryColor
        ),
        icon: const Icon(
          Icons.camera,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () async {
          controller.pickImage(ImageSource.camera);
        },
      ),
    );
  }
}
