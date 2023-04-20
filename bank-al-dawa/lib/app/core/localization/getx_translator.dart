import 'package:bank_al_dawa/app/core/localization/lang_ar.dart';
import 'package:bank_al_dawa/app/core/localization/lang_en.dart';
import 'package:get/get.dart';

class GetxTranslator implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        //English
        'en': EnglishLanguage().getLanguage(),

        //Arabic
        'ar': ArabicLanguage().getLanguage()
      };
}
