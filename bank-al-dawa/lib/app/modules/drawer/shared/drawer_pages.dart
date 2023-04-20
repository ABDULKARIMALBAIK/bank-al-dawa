part of '../drawer_module.dart';

class _DrawerPages {
  _DrawerPages._();

  static List<GetPage> drawerPages = [
    GetPage(
      name: DrawerRoutes.meetingsRoute,
      page: () => const MeetingsView(),
      binding: MeetingsBinding(),
    ),
    GetPage(
      name: DrawerRoutes.featuredStatementsRoute,
      page: () => const FeaturedStatementsView(),
      binding: FeatureStatementsBinding(),
    ),
    GetPage(
      name: DrawerRoutes.manageRegionsRoute,
      page: () => const ManageRegionsView(),
      binding: ManageRegionsBinding(),
    ),
    GetPage(
      name: DrawerRoutes.manageAccountsRoute,
      page: () => const ManageAccountsView(),
      binding: ManageAccountsBinding(),
    ),
  ];
}
