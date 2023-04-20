// ignore_for_file: unused_import

import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:bank_al_dawa/app/core/helper/data_helper.dart';
import 'package:bank_al_dawa/app/core/models/app_models/permission_model.dart';
import 'package:bank_al_dawa/app/core/models/app_models/region_model.dart';
import 'package:bank_al_dawa/app/core/services/getx_storage_controller.dart';
import 'package:bank_al_dawa/app/core/widgets/widget_state.dart';
import 'package:bank_al_dawa/app/modules/authentication/shared/auth_repository.dart';
import 'package:bank_al_dawa/objectbox.g.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/models/app_models/constant_model.dart';
import '../../../core/models/user_models/user_model.dart';
import '../../../core/widgets/toast.dart';

class RegisterController extends GetxStorageController
    with GetSingleTickerProviderStateMixin {
  AuthRepository authRepository;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ensurePasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  late AnimationController bottomSheetAnimationController;

  File? imagePath;
  String locationSearchSelected = '';

  bool isPressedEmployee = false;
  bool isPressedManager = false;
  bool isPressedViewer = false;
  int jobTypeId = -1;
  String jobType = '';
  String selectedEmployee = '';

  String imageBuilderId = 'imageBuilderId';
  String jobStateId = 'jobStateId';
  String regionsId = 'regionsId';
  String titleId = 'titleId';
  String employeeId = 'employeeId';
  String regionBottomSheetId = 'regionBottomSheetId';

  final formRegisterKey = GlobalKey<FormState>();

  dynamic argumentData = Get.arguments;
  bool isFromManageAccounts = false;

  bool isDark = false;
  String isArabic = 'arabic';

  String changeRegionId = '';

  RegisterController({required this.authRepository});

  @override
  void onInit() async {
    bottomSheetAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    // isDark = await storageService.themeStorage.darkMode();
    // isArabic =
    //     (await storageService.languageStorage.getLanguage()).currentLanguage;

    //Very Important operation
    isFromManageAccounts = argumentData[0]['from_manage_accounts'];
    if (isFromManageAccounts) {
      checkManageAccounts();
    }

    super.onInit();
  }

  Future<void> register() async {
    try {
      if (!isFromManageAccounts) {
        if (!formRegisterKey.currentState!.validate()) {
          CustomToast.showError(CustomError.fieldsEmpty);
          return;
        }
      }

      if (validateTextFields() || (isFromManageAccounts)) {
        //validateTextFields() || (isFromManageAccounts)

        if (passwordController.text.length >= 6 || (isFromManageAccounts)) {
          //6
          if (passwordController.text == ensurePasswordController.text) {
            if (imagePath != null || isFromManageAccounts) {
              if (jobTypeId != -1) {
                if (true) {
                  //locationSearchSelected.isNotEmpty (old code)
                  CustomToast.showLoading();

                  String uploadedImageUrl =
                      'random_image_${Random().nextInt(100000)}';
                  if (imagePath != null) {
                    uploadedImageUrl = await authRepository.uploadImage(
                        imagePath!.path,
                        'imageUser_${Random().nextInt(10000)}');

                    await Future.delayed(const Duration(milliseconds: 300));
                  }

                  //Get Region Id
                  String regionId = '0';
                  for (RegionModel region in DataHelper.regions) {
                    if (region.name == locationSearchSelected) {
                      regionId = region.id.toString();
                    }
                  }

                  //Send data to server
                  if (isFromManageAccounts) {
                    final bool result = await authRepository.updateAccountData(
                        DataHelper.accountUser!.id.toString(),
                        usernameController.text,
                        passwordController.text,
                        // "fcm Token here",
                        imagePath == null
                            ? (isFromManageAccounts
                                ? DataHelper.accountUser!.imageUrl
                                : 'No Image')
                            : uploadedImageUrl,
                        phoneNumberController.text,
                        regionId == '0'
                            ? null
                            : [
                                {"id": regionId, "name": locationSearchSelected}
                              ],
                        getPermissionId());

                    CustomToast.closeLoading();

                    // Go to Manage Account Check
                    if (result) {
                      //Update Model Data
                      DataHelper.accountUser!.name =
                          usernameController.text.isNotEmpty
                              ? usernameController.text
                              : DataHelper.accountUser!.name;
                      DataHelper.accountUser!.phone =
                          phoneNumberController.text.isNotEmpty
                              ? phoneNumberController.text
                              : DataHelper.accountUser!.phone;
                      DataHelper.accountUser!.imageUrl = imagePath != null
                          ? uploadedImageUrl
                          : DataHelper.accountUser!.imageUrl;
                      DataHelper.accountUser!.regions = [];

                      for (RegionModel region in DataHelper.regions) {
                        if (region.name == locationSearchSelected) {
                          DataHelper.accountUser!.regions!.add(
                              RegionModel(id: region.id, name: region.name));
                        }
                      }

                      if (jobType == 'مدير') {
                        DataHelper.accountUser!.permission =
                            PermissionModel(id: 1, name: 'مدير');
                      } else if (jobType == 'مشرف') {
                        DataHelper.accountUser!.permission =
                            PermissionModel(id: 2, name: 'مشرف');
                      } else {
                        DataHelper.accountUser!.permission =
                            PermissionModel(id: 3, name: 'موظف');
                      }

                      Get.back(result: [
                        {'isUpdated': true}
                      ]);

                      //Show Toast
                      Future.delayed(const Duration(milliseconds: 200))
                          .then((value) {
                        CustomToast.showDefault(
                            'تم تعديل بيانات المستخدم بنجاح');
                      });
                    }
                  } else {
                    final bool result = await authRepository.registerUser(
                        usernameController.text,
                        passwordController.text,
                        imagePath == null
                            ? (isFromManageAccounts
                                ? DataHelper.accountUser!.imageUrl
                                : 'random_image_${Random().nextInt(100000)}')
                            : uploadedImageUrl,
                        phoneNumberController.text,
                        regionId == '0'
                            ? null
                            : [
                                {"id": regionId, "name": locationSearchSelected}
                              ],
                        getPermissionId());

                    developer.log('Register Result: $result');

                    await getConstants();

                    CustomToast.closeLoading();

                    Get.back();

                    //Show Toast
                    Future.delayed(const Duration(milliseconds: 100))
                        .then((value) {
                      CustomToast.showDefault(
                          '${'register_user_is_registered_successfully'.tr} (${usernameController.text})');
                    });
                  }
                  // ignore: dead_code
                } else {
                  CustomToast.showError(CustomError.chooseLocation);
                }
              } else {
                CustomToast.showError(CustomError.chooseJobType);
              }
            } else {
              CustomToast.showError(CustomError.imageNotPicked);
            }
          } else {
            CustomToast.showError(CustomError.ensurePasswordCorrect);
          }
        } else {
          CustomToast.showError(CustomError.weakPassword);
        }
      } else {
        CustomToast.showError(CustomError.fieldsEmpty);
      }
    } on CustomException catch (e) {
      CustomToast.closeLoading();
      CustomToast.showError(e.error);
    }
  }

  Future<void> pickImage(ImageSource imageSource) async {
    final XFile? currentFile =
        await ImagePicker().pickImage(source: imageSource);

    if (currentFile != null) {
      imagePath = File(currentFile.path);
      updateState([imageBuilderId], WidgetState.loaded);
    }
  }

  void checkManageAccounts() {
    usernameController.text =
        isFromManageAccounts ? DataHelper.accountUser!.name : '';
    phoneNumberController.text =
        isFromManageAccounts ? DataHelper.accountUser!.phone : '';

    jobTypeId =
        isFromManageAccounts ? DataHelper.accountUser!.permission!.id : -1;
    jobType =
        isFromManageAccounts ? DataHelper.accountUser!.permission!.name : '';

    switch (jobType) {
      case 'مدير':
        {
          isPressedEmployee = false;
          isPressedManager = true;
          isPressedViewer = false;
          break;
        }
      case 'مشرف':
        {
          isPressedEmployee = false;
          isPressedManager = false;
          isPressedViewer = true;
          break;
        }
      case 'موظف':
        {
          isPressedEmployee = true;
          isPressedManager = false;
          isPressedViewer = false;
          break;
        }
      default:
        {
          isPressedEmployee = false;
          isPressedManager = false;
          isPressedViewer = false;
          break;
        }
    }
    update([jobStateId]);

    locationSearchSelected = (DataHelper.accountUser!.regions == null ||
            DataHelper.accountUser!.regions!.isEmpty)
        ? ''
        : DataHelper.accountUser!.regions![0].name;
    update([regionsId]);

    updateState([imageBuilderId], WidgetState.loaded);
    update([titleId]);
  }

  int getPermissionId() {
    final List<PermissionModel> permissions =
        storageService.constantBox.getPermissions();

    for (PermissionModel permission in permissions) {
      if (permission.name == jobType) {
        return permission.id;
      }
    }
    //Employee
    return 3;
  }

  Future<CustomException?> getConstants([bool isNeeded = false]) async {
    try {
      final ConstantModel constant = await authRepository.getConstants();
      DataHelper.setConstants(constant);
      storageService.constantBox.setConstants(constant);
      return null;
    } on CustomException {
      //Offline Mode setup local variables by local storage
      final ConstantModel constantOffline = ConstantModel(
          priorities: storageService.constantBox.getPriorities(),
          regions: storageService.constantBox.getRegions(),
          results: storageService.constantBox.getResults(),
          types: storageService.constantBox.getTypes(),
          users: storageService.userBox.getAllUsers());
      DataHelper.setConstants(constantOffline);

      if (isNeeded) {
        rethrow;
      } else {
        return null;
      }
    }
  }

  bool validateTextFields() {
    if (isFromManageAccounts) {
      return true;
    } else {
      if (usernameController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          ensurePasswordController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> transferReports(BuildContext context) async {
    if (selectedEmployee.isEmpty) {
      Future.delayed(const Duration(milliseconds: 200))
          .then((value) => CustomToast.showDefault('رجاء اختر الموظف المناسب'));
    } else if (checkSameUser()) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) =>
          CustomToast.showDefault('لا تختر نفس الموظف ، حاول مرة اخرى'));
    } else {
      try {
        CustomToast.showLoading();
        await Future.delayed(const Duration(milliseconds: 100));

        //Get User Id
        String userId = '1';
        for (User user in DataHelper.employees) {
          if (user.name == selectedEmployee) {
            userId = user.id.toString();
          }
        }

        //Get region Id (changeRegionId)
        String selectedRegion = '';
        if (changeRegionId.isNotEmpty) {
          for (RegionModel region in DataHelper.regions) {
            if (region.name == changeRegionId) {
              selectedRegion = region.id.toString();
            }
          }
        }

        final bool result = await authRepository.transferReports(
            oldUser: DataHelper.accountUser!.id,
            newUser: int.parse(userId),
            regionId: selectedRegion);

        if (result) {
          CustomToast.closeLoading();

          // ignore: use_build_context_synchronously
          Navigator.pop(context);

          Future.delayed(const Duration(milliseconds: 200)).then((value) =>
              CustomToast.showDefault(
                  'تم نقل الكشوفات إلى $selectedEmployee بنجاح'));
        } else {
          CustomToast.closeLoading();
          CustomToast.showDefault('مشكلة ما حدثت');
        }
      } on CustomException catch (e) {
        CustomToast.closeLoading();
        CustomToast.showError(e.error);
      }
    }
  }

  bool checkSameUser() {
    if (selectedEmployee == DataHelper.accountUser!.name) {
      return true;
    } else {
      return false;
    }
  }
}
