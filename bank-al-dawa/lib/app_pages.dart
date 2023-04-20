import 'package:bank_al_dawa/app/modules/authentication/auth_module.dart';
import 'package:bank_al_dawa/app/modules/drawer/drawer_module.dart';
import 'app/modules/dashboard/dashboard_module.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();
  static final List<GetPage<dynamic>> appRoutes = [
    ...AuthModule.authPages,
    ...DrawerModule.drawerPages,
    ...DashboardModule.dashboardPages
  ];
}
