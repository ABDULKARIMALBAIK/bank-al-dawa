import 'package:bank_al_dawa/app/modules/drawer/featured_statements/featured_statements_binding.dart';
import 'package:bank_al_dawa/app/modules/drawer/featured_statements/featured_statements_view.dart';
import 'package:bank_al_dawa/app/modules/drawer/manage_accounts/manage_accounts_binding.dart';
import 'package:bank_al_dawa/app/modules/drawer/manage_regions/manage_regions_binding.dart';
import 'package:bank_al_dawa/app/modules/drawer/manage_regions/manage_regions_view.dart';
import 'package:bank_al_dawa/app/modules/drawer/meetings/meetings_binding.dart';
import 'package:bank_al_dawa/app/modules/drawer/shared/constant/drawer_routes.dart';
import 'package:get/get.dart';

import 'manage_accounts/manage_accounts_view.dart';
import 'meetings/meetings_view.dart';

part 'shared/drawer_pages.dart';

class DrawerModule {
  static List<GetPage> get drawerPages => _DrawerPages.drawerPages;
}
