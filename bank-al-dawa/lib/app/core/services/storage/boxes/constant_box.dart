part of '../storage_service.dart';

class ConstantBox {
  ConstantBox._internal() {
    final StorageService storageService = StorageService.instance;
    _region = storageService.store.box<RegionModel>();
    _permission = storageService.store.box<PermissionModel>();
    _priority = storageService.store.box<PriorityModel>();
    _result = storageService.store.box<ResultModel>();
    _type = storageService.store.box<TypeModel>();
  }

  late Box<PermissionModel> _permission;
  late Box<PriorityModel> _priority;
  late Box<RegionModel> _region;
  late Box<ResultModel> _result;
  late Box<TypeModel> _type;

  void clearConstantBox() {
    _permission.removeAll();
    _priority.removeAll();
    _region.removeAll();
    _result.removeAll();
    _type.removeAll();
  }

  List<PermissionModel> getPermissions() => _permission.getAll();

  List<PriorityModel> getPriorities() => _priority.getAll();

  List<RegionModel> getRegions() => _region.getAll();

  List<RegionModel> getRegionsRelatedToUser(int userId) {
    final List<RegionModel> regions = _region.getAll();
    final List<RegionModel> regionsRelated = [];
    for (RegionModel region in regions) {
      for (User user in region.users) {
        if (user.id == userId) {
          regionsRelated.add(region);
        }
      }
    }
    return regionsRelated;
  }

  List<ResultModel> getResults() => _result.getAll();

  List<TypeModel> getTypes() => _type.getAll();

  PermissionModel? getUserPermission(int userId) {
    final List<PermissionModel> permissions = _permission.getAll();
    for (PermissionModel permission in permissions) {
      for (User user in permission.users) {
        if (user.id == userId) {
          return permission;
        }
      }
    }
    return null;
  }

  void setConstants(ConstantModel constant) {
    if (constant.priorities.isNotEmpty) {
      setPriorities(constant.priorities);
    }
    if (constant.regions.isNotEmpty) {
      setRegions(constant.regions);
    }
    if (constant.results.isNotEmpty) {
      setResults(constant.results);
    }
    if (constant.types.isNotEmpty) {
      setTypes(constant.types);
    }
    if (constant.users.isNotEmpty) {
      StorageService.instance.userBox.setUsers(constant.users);
    }
  }

  void setPermission(PermissionModel permission) => _permission.put(permission);

  void setPermissions(List<PermissionModel> permissions) =>
      _permission.putMany(permissions);

  void setPriorities(List<PriorityModel> prioritys) =>
      _priority.putMany(prioritys);

  void setPriority(PriorityModel priority) => _priority.put(priority);

  void setRegion(RegionModel region) => _region.put(region);

  void setRegions(List<RegionModel> regions) => _region.putMany(regions);

  void setResult(ResultModel result) => _result.put(result);

  void setResults(List<ResultModel> results) => _result.putMany(results);

  void setType(TypeModel type) => _type.put(type);

  void setTypes(List<TypeModel> types) => _type.putMany(types);
  ResultModel? getResultRelatedToReportModel(int reportModelId) {
    final List<ResultModel> results = _result.getAll();
    for (ResultModel result in results) {
      for (ReportLog reportModel in result.reportModels) {
        if (reportModel.id == reportModelId) {
          return result;
        }
      }
    }
    return null;
  }

  RegionModel? getRegionRelatedToReport(int reportId) {
    final List<RegionModel> regions = _region.getAll();
    for (RegionModel region in regions) {
      for (Report report in region.reports) {
        if (report.id == reportId) {
          return region;
        }
      }
    }
    return null;
  }

  TypeModel? getTypeRelatedToReport(int reportId) {
    final List<TypeModel> types = _type.getAll();
    for (TypeModel type in types) {
      for (Report report in type.reports) {
        if (report.id == reportId) {
          return type;
        }
      }
    }
    return null;
  }

  PriorityModel? getPriorityRelatedToReport(int reportId) {
    final List<PriorityModel> prioritys = _priority.getAll();
    for (PriorityModel priority in prioritys) {
      for (Report report in priority.reports) {
        if (report.id == reportId) {
          return priority;
        }
      }
    }
    return null;
  }

  bool deleteRegion(int regionId) {
    final bool result = _region.remove(regionId);
    return result;
  }
}
