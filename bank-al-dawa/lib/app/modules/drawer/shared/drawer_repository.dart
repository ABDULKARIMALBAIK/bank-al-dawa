import 'package:bank_al_dawa/app/core/models/app_models/region_model.dart';
import 'package:dio/dio.dart';

import '../../../core/constants/urls.dart';
import '../../../core/exceptions/exceptions.dart';
import '../../../core/models/app_models/meetings_model.dart';
import '../../../core/models/user_models/user_model.dart';

class DrawerRepository {
  Dio dio;

  DrawerRepository({required this.dio});

  Future<List<MeetingModel>> getMeetings() async {
    try {
      final Response response = await dio.get(ConstUrls.meetingsEndPoint);
      return MeetingModel.meetingsFromJson(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<User>> getAccounts(int id, [int limit = 30]) async {
    try {
      final Response response =
          await dio.get(ConstUrls.manageAccountsEndPoint, queryParameters: {
        'id': id,
        'limit': limit,
      });

      return User.userList(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<RegionModel>> getRegions() async {
    try {
      final Response response = await dio.get('region');

      final List<RegionModel> regionsList = (response.data as List)
          .map((region) => RegionModel.fromMap(region))
          .toList();

      return regionsList;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<bool> deleteRegion(String id) async {
    try {
      // ignore: unused_local_variable
      final Response response =
          await dio.delete('${ConstUrls.baseUrl}region/$id');

      return true;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<bool> updateRegion(
      {required String regionId, required String regionName}) async {
    try {
      // ignore: unused_local_variable
      final Response response = await dio.patch(
          '${ConstUrls.baseUrl}region/$regionId',
          data: {"name": regionName});

      return true;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<bool> addRegion(String regionName) async {
    try {
      // ignore: unused_local_variable
      final Response response =
          await dio.post('region', data: {"name": regionName});

      return true;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<RegionModel> getRegionById(String id) async {
    try {
      // ignore: unused_local_variable
      final Response response = await dio.get("${ConstUrls.baseUrl}region/$id");

      final RegionModel regionModel = RegionModel.fromMap(response.data);
      return regionModel;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> deleteAccount(String id) async {
    try {
      await dio.delete(
          "${ConstUrls.baseUrl}${ConstUrls.deleteAccountEndPoint}/$id",
          data: {});
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }
}
