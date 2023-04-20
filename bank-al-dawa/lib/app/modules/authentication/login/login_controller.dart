import 'dart:developer';

import 'package:bank_al_dawa/app/core/models/user_models/user_model.dart';
import 'package:bank_al_dawa/app/core/services/getx_storage_controller.dart';
import 'package:bank_al_dawa/app/modules/authentication/shared/auth_repository.dart';
import 'package:bank_al_dawa/app/modules/authentication/shared/constant/auth_routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/widgets/toast.dart';

class LoginController extends GetxStorageController {
  AuthRepository authRepository;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formLoginKey = GlobalKey<FormState>();

  LoginController({required this.authRepository});

  Future<String> getToken() async {
    try {
      return (await FirebaseMessaging.instance.getToken()).toString();
    } catch (e) {
      log('e_${e.toString()}');
      return 'string';
    }
  }

  Future<void> login() async {
    try {
      if (validateData()) {
        CustomToast.showLoading();

        final User user = await authRepository.loginUser(
            username: usernameController.text,
            password: passwordController.text,
            fcmToken: await getToken());

        storageService.userBox.setUser(user);

        CustomToast.closeLoading();
        await Get.offAllNamed(AuthRoutes.wrapperRoute);
      }
    } on CustomException catch (e) {
      CustomToast.showError(e.error);
    }
  }

  bool validateData() {
    if (formLoginKey.currentState!.validate()) {
      if (passwordController.text.length >= 3) {
        return true;
      } else {
        CustomToast.showError(CustomError.weakPassword);
      }
    } else {
      CustomToast.showError(CustomError.fieldsEmpty);
    }
    return false;
  }
}
