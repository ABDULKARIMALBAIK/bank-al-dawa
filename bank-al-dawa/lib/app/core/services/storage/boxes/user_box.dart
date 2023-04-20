part of '../storage_service.dart';

class UserBox {
  UserBox._internal() {
    final StorageService storageService = StorageService.instance;
    _user = storageService.store.box<User>();
  }

  late Box<User> _user;

  User? getUser() {
    final User? user;
    final Query<User> query =
        _user.query(User_.isOtherUser.equals(false)).build();
    final List<User> users = query.find();
    if (users.isNotEmpty) {
      user = users.first;
    } else {
      user = null;
    }
    query.close();
    if (user != null) {
      final List<RegionModel> userRegions =
          StorageService.instance.constantBox.getRegionsRelatedToUser(user.id);
      user.regions = userRegions;
      user.permission =
          StorageService.instance.constantBox.getUserPermission(user.id);
    }
    return user;
  }

  void setUser(User user) async {
    _user.put(user);
    for (RegionModel region in user.regions!) {
      region.users.add(user);
      StorageService.instance.constantBox.setRegion(region);
    }
    user.permission!.users.add(user);
    StorageService.instance.constantBox.setPermission(user.permission!);
  }

  void setUsers(List<User> users) async {
    for (User user in users) {
      if (user.id != DataHelper.user!.id) {
        setUser(user);
      }
    }
  }

  List<User> getAllUsers() {
    return _user.getAll();
  }

  void clearUserBox() {
    _user.removeAll();
  }
}
