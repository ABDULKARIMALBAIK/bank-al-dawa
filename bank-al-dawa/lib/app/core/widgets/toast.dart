import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../exceptions/exceptions.dart';

class CustomToast {
  CustomToast.showDefault(String message) {
    BotToast.closeAllLoading();
    showToast(message, false);
  }

  CustomToast.showError(CustomError error) {
    BotToast.closeAllLoading();
    String message = "";
    switch (error) {
      case CustomError.noInternet:
        message = "لا يوجد اتصال بالانترنت"; //noInternet
        break;
      case CustomError.notExists:
        message = "الحساب غير موجود ، عدل البيانات"; //account is not exists
        break;
      case CustomError.unKnown:
        message = "خطأ غير معروف"; //unKnown
        break;
      case CustomError.formatException:
        message = "خطأ غير معروف"; //formatException
        break;
      case CustomError.alreadyExists:
        message = "ًالمستخدم موجود مسبقا ،عدل البيانات"; //already Exists
        break;
      case CustomError.fieldsEmpty:
        message = "املئ جميع الحقول"; //Fill all the fields
        break;
      case CustomError.weakPassword:
        message =
            "كلمة السر ضعيفة ، ادخل 6 محارف على الأقل"; //Password is wak (leangth >= 6)
        break;
      case CustomError.ensurePasswordCorrect:
        message =
            "تأكد من ادخال كلمة المرور بشكل صحيح"; //Please type correct password inside Ensure Password Field
        break;
      case CustomError.imageNotPicked:
        message =
            "من فضلك اخنر صورة"; //Please type correct password inside Ensure Password Field
        break;
      case CustomError.chooseJobType:
        message = "اختر مستوى التوظيف"; //Select job type
        break;
      case CustomError.chooseLocation:
        message = "اختر موقع ما"; //Please choose location
        break;
      case CustomError.moreThan10:
        message = 'لا يمكن تحديد مواعيد مراجعة إضافية في هذا اليوم';
    }

    showToast(message, true);
  }

  CustomToast.showLoading() {
    showLoading();
  }

  void showToast(String message, bool isError) {
    BotToast.showText(
      text: message,
      textStyle: GoogleFonts.notoKufiArabic(color: Colors.white),
      contentColor: isError ? Colors.red : Colors.green,
      borderRadius: BorderRadius.circular(16),
      // contentColor: ,
      // contentPadding: ,
      crossPage: false,
      clickClose: true,
      duration: const Duration(seconds: 5),
    );
  }

  void showLoading() {
    BotToast.showLoading();
  }

  CustomToast.closeLoading() {
    closeLoading();
  }

  void closeLoading() {
    BotToast.closeAllLoading();
  }
}
