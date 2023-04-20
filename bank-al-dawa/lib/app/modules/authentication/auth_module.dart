import 'package:bank_al_dawa/app/modules/authentication/login/login_binding.dart';
import 'package:bank_al_dawa/app/modules/authentication/login/login_view.dart';
import 'package:bank_al_dawa/app/modules/authentication/register/register_binding.dart';
import 'package:bank_al_dawa/app/modules/authentication/register/register_view.dart';
import 'package:bank_al_dawa/app/modules/authentication/shared/constant/auth_routes.dart';
import 'package:bank_al_dawa/app/modules/authentication/wrapper/wrapper_binding.dart';
import 'package:bank_al_dawa/app/modules/authentication/wrapper/wrapper_view.dart';
import 'package:get/get.dart';

part 'shared/auth_pages.dart';

class AuthModule {
  static String get authInitialRoute => AuthRoutes.wrapperRoute;
  static List<GetPage> get authPages => _AuthPages.authPages;
}
