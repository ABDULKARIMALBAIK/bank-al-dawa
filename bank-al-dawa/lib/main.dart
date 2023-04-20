import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bank_al_dawa/app/core/localization/getx_translator.dart';
import 'package:bank_al_dawa/app/core/theme/theme.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'app/core/constants/urls.dart';
import 'app/core/services/storage/storage_service.dart';
import 'app/modules/authentication/auth_module.dart';
import 'app_initial_binding.dart';
import 'app_pages.dart';

part 'app_initialize.dart';

void main() async {
  await _preInitializations();

  runApp(GetMaterialApp(
    showPerformanceOverlay: false,
    defaultTransition: Transition.fade, //NEW
    title: ConstUrls.appName,
    initialRoute: AuthModule.authInitialRoute,
    getPages: AppPages.appRoutes,
    initialBinding: AppInitialBindings(),
    debugShowCheckedModeBanner: false,
    builder: BotToastInit(),
    navigatorObservers: [BotToastNavigatorObserver()],
    themeMode: ThemeMode.system,
    theme: AppTheme.themeLight,
    translations: GetxTranslator(),
    locale: const Locale('ar'),
    fallbackLocale: const Locale('ar'),
  ));
}
