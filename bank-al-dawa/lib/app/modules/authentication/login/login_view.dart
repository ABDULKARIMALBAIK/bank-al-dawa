import 'package:bank_al_dawa/app/core/constants/urls.dart';
import 'package:bank_al_dawa/app/core/widgets/custom_text_field.dart';
import 'package:bank_al_dawa/app/core/widgets/neumorphic_container.dart';
import 'package:bank_al_dawa/app/modules/authentication/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(
                  height: 30,
                ),
                _loginTitle(context),
                const SizedBox(
                  height: 0,
                ),
                _lottieAnimation(context),
                const SizedBox(
                  height: 2,
                ),
                _textFields(context),
                const SizedBox(
                  height: 5,
                ),
                _loginButton(context),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* Widget Methods */

  Text _loginTitle(BuildContext context) {
    return Text(
      'login_title'.tr,
      maxLines: 1,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.headline5!.copyWith(shadows: [
        Shadow(color: Theme.of(context).primaryColor, blurRadius: 4)
      ], color: Theme.of(context).primaryColor),
    );
  }

  Container _textFields(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      width: MediaQuery.of(context).size.width,
      child: AutofillGroup(
        child: Form(
          key: controller.formLoginKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _titleTextFields(context, 'login_username'.tr),
              NeumorphicContainer(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                borderRadius: BorderRadius.circular(16),
                onTab: () {},
                isInnerShadow: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: CustomTextField(
                  autofillHints: AutofillHints.username,
                  isPassword: false,
                  controller: controller.usernameController,
                  hintText: 'login_textField_username_hint'.tr,
                  labelText: 'login_textField_username_label'.tr,
                  icon: Icons.person,
                  validator: (name) {
                    if (name == null || name.isEmpty) {
                      return 'login_username_empty'.tr;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              _titleTextFields(context, 'login_password'.tr),
              NeumorphicContainer(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                borderRadius: BorderRadius.circular(16),
                onTab: () {},
                isInnerShadow: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: CustomTextField(
                  autofillHints: AutofillHints.password,
                  controller: controller.passwordController,
                  textInputAction: TextInputAction.done,
                  labelText: 'login_textField_password_label'.tr,
                  hintText: 'login_textField_password_hint'.tr,
                  icon: Icons.vpn_key_outlined,
                  isPassword: true,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return 'login_textField_password_empty'.tr;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 25,
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

  SizedBox _loginButton(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 50,
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
          onPressed: controller.login,
          child: Text(
            'login_button'.tr,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(),
          ),
        ),
      ),
    );
  }

  Container _lottieAnimation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      width: MediaQuery.of(context).size.width,
      height: 320,
      child: Center(
        child: Lottie.asset(
          ConstUrls.welcomeLottieUrl,
          width: 290,
          height: 290,
          fit: BoxFit.contain,
        ),
      ),
      // child: Center(
      //   child: Image.asset(
      //     ResourcesPath().signInImage,
      //     fit: BoxFit.cover,
      //     width: 250,
      //     height: 250,
      //   ),
      // ),
    );
  }
}
