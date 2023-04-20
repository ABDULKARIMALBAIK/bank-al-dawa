import 'package:bank_al_dawa/app/core/models/app_models/permission_model.dart';
import 'package:bank_al_dawa/app/core/models/app_models/region_model.dart';
import 'package:bank_al_dawa/app/core/services/data_list.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class User extends PaginationId {
  User({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.phone,
    required this.refreshToken,
    required this.accessTokenExpiryDate,
    required this.accessToken,
    required this.isOtherUser,
    this.regions,
    this.permission,
  }) {
    lastId = id;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final User model = User(
      id: int.parse(json["id"]),
      name: json["name"],
      accessTokenExpiryDate: DateTime.now().add(const Duration(seconds: 0)),
      imageUrl: json["image_url"],
      phone: json["phone"],
      isOtherUser: true,
      refreshToken: "",
      accessToken: "",
    );
    model.regions = List<RegionModel>.from(
        json["regions"].map((x) => RegionModel.fromMap(x)));
    model.permission = PermissionModel.fromMap(json["permission"]);
    return model;
  }
  factory User.appUserfromJson(Map<String, dynamic> json) {
    final User model = User(
      isOtherUser: false,
      id: int.parse(json["id"]),
      name: json["name"],
      accessTokenExpiryDate:
          DateTime.now().add(Duration(seconds: json["expireTime"])),
      imageUrl: json["image_url"],
      phone: json["phone"],
      refreshToken: json["refresh_token"],
      accessToken: json["accessToken"],
    );
    model.regions = List<RegionModel>.from(
        json["regions"].map((x) => RegionModel.fromMap(x)));
    model.permission = PermissionModel.fromMap(json["permission"]);
    return model;
  }
  static List<User> userList(List data) =>
      data.map((report) => User.fromJson(report)).toList();

  String imageUrl;
  String name;
  String phone;
  final String refreshToken;
  final bool isOtherUser;

  String accessToken;
  @Property(type: PropertyType.date)
  DateTime accessTokenExpiryDate;
  @Id(assignable: true)
  final int id;

  @Transient()
  PermissionModel? permission;

  @Transient()
  List<RegionModel>? regions;
  final ToOne<PermissionModel> permissionRelation = ToOne<PermissionModel>();

  @override
  String toString() {
    return '''
    id:$id,
    permission:$permission,
    isOtherUser:$isOtherUser,
    regions:$regions,
    regions:$refreshToken,
    regions:$accessToken,
    ''';
  }
}

// import 'package:bank_al_dawa/app/core/models/app_models/permission_model.dart';
// import 'package:bank_al_dawa/app/core/models/app_models/region_model.dart';
// import 'package:objectbox/objectbox.dart';

// @Entity()
// class User {
//   User._({
//     required this.id,
//     required this.name,
//     required this.imageUrl,
//     required this.phone,
//     required this.refreshToken,
//     required this.accessTokenExpiryDate,
//     required this.accessToken,
//     required this.isOtherUser,
//     PermissionModel? permission,
//     List<RegionModel>? regions,
//   }) {
//     _permission = permission;
//     _regions = regions;
//   }

//   factory User.appUserfromJson(Map<String, dynamic> json) {
//     final User model = User._(
//       isOtherUser: false,
//       id: int.parse(json["id"]),
//       name: json["name"],
//       accessTokenExpiryDate:
//           DateTime.now().add(Duration(seconds: json["expireTime"])),
//       imageUrl: json["image_url"],
//       phone: json["phone"],
//       refreshToken: json["refresh_token"],
//       accessToken: json["accessToken"],
//     );
//     model._regions = json["regions"] == null
//         ? []
//         : List<RegionModel>.from(
//             json["regions"].map((x) => RegionModel.fromMap(x)));
//     model._permission = PermissionModel.fromMap(json["permission"]);
//     return model;
//   }

//   factory User.fromJson(Map<String, dynamic> json) {
//     final User model = User._(
//       id: int.parse(json["id"]),
//       name: json["name"],
//       accessTokenExpiryDate: DateTime.now().add(const Duration(seconds: 0)),
//       imageUrl: json["image_url"],
//       phone: json["phone"],
//       isOtherUser: true,
//       refreshToken: "",
//       accessToken: "",
//     );
//     model._regions = json["regions"] == null
//         ? []
//         : List<RegionModel>.from(
//             json["regions"].map((x) => RegionModel.fromMap(x)));
//     model._permission = PermissionModel.fromMap(json["permission"]);
//     return model;
//   }

//   final String imageUrl;
//   final bool isOtherUser;
//   final String name;
//   final ToOne<PermissionModel> permissionRelation = ToOne<PermissionModel>();
//   final String phone;
//   final String refreshToken;

//   String accessToken;
//   @Property(type: PropertyType.date)
//   DateTime accessTokenExpiryDate;

//   @Id(assignable: true)
//   final int id;

//   @Transient()
//   PermissionModel? _permission;

//   @Transient()
//   List<RegionModel>? _regions;

//   @override
//   String toString() {
//     return '''
//     id:$id,
//     permission:$_permission,
//     isOtherUser:$isOtherUser,
//     regions:$_regions,
//     regions:$refreshToken,
//     regions:$accessToken,
//     ''';
//   }

//   @Transient()
//   PermissionModel get permission => _permission!;
//   @Transient()
//   List<RegionModel> get regions => _regions!;

//   set permission(PermissionModel permission) => _permission = permission;

//   set regions(List<RegionModel> regions) => _regions = regions;
// }
