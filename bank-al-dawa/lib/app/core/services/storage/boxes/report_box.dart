part of '../storage_service.dart';

class ReportBox {
  ReportBox._internal() {
    final StorageService storageService = StorageService.instance;
    _reportLog = storageService.store.box<ReportLog>();
    _report = storageService.store.box<Report>();
    _shortUser = storageService.store.box<ShortUser>();
  }

  late Box<Report> _report;
  late Box<ReportLog> _reportLog;
  late Box<ShortUser> _shortUser;

  bool get isEmptyReportBox => _report.isEmpty();

  void clearReportBox() {
    _report.removeAll();
    _reportLog.removeAll();
    _shortUser.removeAll();
  }

  List<Report> getAllReports({
    required int page,
    int limit = 30,
    List<int>? byEmployeeIds,
    List<int>? typeIds,
    List<int>? priorityIds,
    List<int>? resultIds,
    String? byPatientName,
    List<int>? byRegionIds,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Condition<Report> condition = Report_.id.notNull();
    if (byPatientName != null && byPatientName.isNotEmpty) {
      condition = condition
          .and(Report_.name.contains(byPatientName, caseSensitive: false));
    }
    if (byEmployeeIds != null && byEmployeeIds.isNotEmpty) {
      Condition<Report> conditionByRegionIds =
          Report_.shortUserRelationReport.equals(byEmployeeIds[0]);
      for (var i = 1; i < byEmployeeIds.length; i++) {
        conditionByRegionIds = conditionByRegionIds
            .or(Report_.shortUserRelationReport.equals(byEmployeeIds[i]));
      }

      condition = condition.and(conditionByRegionIds);
    }
    if (byRegionIds != null && byRegionIds.isNotEmpty) {
      Condition<Report> conditionByRegionIds =
          Report_.regionModelRelation.equals(byRegionIds[0]);
      for (var i = 1; i < byRegionIds.length; i++) {
        conditionByRegionIds = conditionByRegionIds
            .or(Report_.regionModelRelation.equals(byRegionIds[i]));
      }

      condition = condition.and(conditionByRegionIds);
    }
    if (typeIds != null && typeIds.isNotEmpty) {
      Condition<Report> conditionByRegionIds =
          Report_.typeModelRelation.equals(typeIds[0]);
      for (var i = 1; i < typeIds.length; i++) {
        conditionByRegionIds = conditionByRegionIds
            .or(Report_.typeModelRelation.equals(typeIds[i]));
      }

      condition = condition.and(conditionByRegionIds);
    }
    if (priorityIds != null && priorityIds.isNotEmpty) {
      Condition<Report> conditionByRegionIds =
          Report_.priorityModelRelation.equals(priorityIds[0]);
      for (var i = 1; i < priorityIds.length; i++) {
        conditionByRegionIds = conditionByRegionIds
            .or(Report_.priorityModelRelation.equals(priorityIds[i]));
      }

      condition = condition.and(conditionByRegionIds);
    }
    if (startDate != null && endDate != null) {
      condition = condition.and(Report_.createdAt.between(
          startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch));
    } else if (startDate != null) {
      condition = condition.and(
          Report_.createdAt.greaterOrEqual(startDate.millisecondsSinceEpoch));
    } else if (endDate != null) {
      condition = condition
          .and(Report_.createdAt.lessOrEqual(endDate.millisecondsSinceEpoch));
    }
    final QueryBuilder<Report> builder = _report.query(condition);
    final Query<Report> query = builder.build();
    query
      ..offset = page * limit
      ..limit = limit;
    final List<Report> reports = query.find();
    final List<Report> finalReports = [];
    query.close();
    for (var i = 0; i < reports.length; i++) {
      reports[i].region = StorageService.instance.constantBox
          .getRegionRelatedToReport(reports[i].id);
      reports[i].priority = StorageService.instance.constantBox
          .getPriorityRelatedToReport(reports[i].id);
      reports[i].type = StorageService.instance.constantBox
          .getTypeRelatedToReport(reports[i].id);
      final ShortUser? shortUser = _getShortUserRelatedToReport(reports[i].id);
      if (shortUser != null) {
        reports[i].setShortUser = shortUser;
      }
      reports[i].reportlogs = _getReportLogRelatedToReport(reports[i].id);

      finalReports.add(reports[i]);
      if (resultIds != null &&
          reports[i].reportlogs != null &&
          resultIds.isNotEmpty) {
        //
        if (reports[i].reportlogs!.isNotEmpty) {
          if (!resultIds.contains(reports[i]
              .reportlogs![reports[i].reportlogs!.length - 1]
              .result!
              .id)) {
            finalReports.remove(reports[i]);
          }
        } else {
          // لم يتم الكشف
          if (!resultIds.contains(9)) {
            finalReports.remove(reports[i]);
          }
        }

        // bool kept = false;
        // print('kkk_${reports[i].reportlogs!.length}');
        // print('yyy_${reports[i]}');
        // for (var j = 0; j < reports[i].reportlogs!.length; j++) {
        //   print('pass1');
        //   if (resultIds.contains(reports[i].reportlogs![j].result!.id)) {
        //     print('pass2');
        //     kept = true;
        //   }
        // }
        // if (!kept) {
        //   print('pass3');
        //   reports.removeAt(i);
        // }
      }
    }

    return finalReports;
  }

  int getNumberReports({
    // required int page,
    // int limit = 20,
    List<int>? byEmployeeIds,
    List<int>? typeIds,
    List<int>? priorityIds,
    List<int>? resultIds,
    String? byPatientName,
    List<int>? byRegionIds,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Condition<Report> condition = Report_.id.notNull();
    if (byPatientName != null && byPatientName.isNotEmpty) {
      condition = condition
          .and(Report_.name.equals(byPatientName, caseSensitive: false));
    }
    if (byEmployeeIds != null && byEmployeeIds.isNotEmpty) {
      Condition<Report> conditionByRegionIds =
          Report_.shortUserRelationReport.equals(byEmployeeIds[0]);
      for (var i = 1; i < byEmployeeIds.length; i++) {
        conditionByRegionIds = conditionByRegionIds
            .or(Report_.shortUserRelationReport.equals(byEmployeeIds[i]));
      }

      condition = condition.and(conditionByRegionIds);
    }
    if (byRegionIds != null && byRegionIds.isNotEmpty) {
      Condition<Report> conditionByRegionIds =
          Report_.regionModelRelation.equals(byRegionIds[0]);
      for (var i = 1; i < byRegionIds.length; i++) {
        conditionByRegionIds = conditionByRegionIds
            .or(Report_.regionModelRelation.equals(byRegionIds[i]));
      }

      condition = condition.and(conditionByRegionIds);
    }
    if (typeIds != null && typeIds.isNotEmpty) {
      Condition<Report> conditionByRegionIds =
          Report_.typeModelRelation.equals(typeIds[0]);
      for (var i = 1; i < typeIds.length; i++) {
        conditionByRegionIds = conditionByRegionIds
            .or(Report_.typeModelRelation.equals(typeIds[i]));
      }

      condition = condition.and(conditionByRegionIds);
    }
    if (priorityIds != null && priorityIds.isNotEmpty) {
      Condition<Report> conditionByRegionIds =
          Report_.priorityModelRelation.equals(priorityIds[0]);
      for (var i = 1; i < priorityIds.length; i++) {
        conditionByRegionIds = conditionByRegionIds
            .or(Report_.priorityModelRelation.equals(priorityIds[i]));
      }

      condition = condition.and(conditionByRegionIds);
    }
    if (startDate != null && endDate != null) {
      condition = condition.and(Report_.createdAt.between(
          startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch));
    } else if (startDate != null) {
      condition = condition.and(
          Report_.createdAt.greaterOrEqual(startDate.millisecondsSinceEpoch));
    } else if (endDate != null) {
      condition = condition
          .and(Report_.createdAt.lessOrEqual(endDate.millisecondsSinceEpoch));
    }
    final QueryBuilder<Report> builder = _report.query(condition);
    final Query<Report> query = builder.build();
    // query
    //   ..offset = page * limit
    //   ..limit = limit;
    final List<Report> reports = query.find();
    final List<Report> finalReports = [];
    query.close();

    for (var i = 0; i < reports.length; i++) {
      // final Report report = reports[i];
      reports[i].region = StorageService.instance.constantBox
          .getRegionRelatedToReport(reports[i].id);
      reports[i].priority = StorageService.instance.constantBox
          .getPriorityRelatedToReport(reports[i].id);
      reports[i].type = StorageService.instance.constantBox
          .getTypeRelatedToReport(reports[i].id);
      final ShortUser? shortUser = _getShortUserRelatedToReport(reports[i].id);
      if (shortUser != null) {
        reports[i].setShortUser = shortUser;
      }
      reports[i].reportlogs = _getReportLogRelatedToReport(reports[i].id);

      finalReports.add(reports[i]);
      if (resultIds != null &&
          reports[i].reportlogs != null &&
          resultIds.isNotEmpty) {
        //
        if (reports[i].reportlogs!.isNotEmpty) {
          if (!resultIds.contains(reports[i]
              .reportlogs![reports[i].reportlogs!.length - 1]
              .result!
              .id)) {
            finalReports.remove(reports[i]);
          }
        } else {
          // لم يتم الكشف
          if (!resultIds.contains(9)) {
            finalReports.remove(reports[i]);
          }
          // finalReports.remove(reports[i]);
        }

        // bool kept = false;
        // for (var j = 0; j < reports[i].reportlogs!.length; j++) {
        //   if (resultIds.contains(reports[i].reportlogs![j].result!.id)) {
        //     kept = true;
        //   }
        // }
        // if (!kept) {
        //   reports.removeAt(i);
        // }
      }
    }
    return finalReports.length;
  }

  void setReport(Report report) {
    _report.put(report);
    if (report.priority != null) {
      report.priority!.reports.add(report);
      StorageService.instance.constantBox.setPriority(report.priority!);
    }
    if (report.region != null) {
      report.region!.reports.add(report);
      StorageService.instance.constantBox.setRegion(report.region!);
    }
    if (report.type != null) {
      report.type!.reports.add(report);
      StorageService.instance.constantBox.setType(report.type!);
    }
    if (report.shortUser != null) {
      report.shortUser!.reports.add(report);
      _setShortUser(report.shortUser!);
    }
    if (report.reportlogs != null) {
      for (ReportLog reportlog in report.reportlogs!) {
        _setReportLog(reportlog);
      }
    }
  }

  List<ReportLog> _getReportLogRelatedToReport(int reportId) {
    final QueryBuilder<ReportLog> builder = _reportLog.query();
    builder.link(ReportLog_.report, Report_.id.equals(reportId));
    final Query<ReportLog> query = builder.build();
    final List<ReportLog> reportLogs = query.find();
    query.close();
    for (var i = 0; i < reportLogs.length; i++) {
      // reports[i].setShortUser = _getShortUserRelatedToReportLog(reports[i].id)!;

      reportLogs[i].result = StorageService.instance.constantBox
          .getResultRelatedToReportModel(reportLogs[i].id);
    }

    return reportLogs;
  }

  ShortUser? _getShortUserRelatedToReport(int reportId) {
    final List<ShortUser> shortUsers = _shortUser.getAll();

    for (ShortUser shortUser in shortUsers) {
      for (Report report in shortUser.reports) {
        if (report.id == reportId) {
          return shortUser;
        }
      }
    }
    return null;
  }

  // ignore: unused_element
  ShortUser? _getShortUserRelatedToReportLog(int reportLogId) {
    final List<ShortUser> shortUsers = _shortUser.getAll();

    for (ShortUser shortUser in shortUsers) {
      for (ReportLog reportLog in shortUser.reportLogs) {
        if (reportLog.id == reportLogId) {
          return shortUser;
        }
      }
    }
    return null;
  }

  void _setReportLog(ReportLog reportlog) {
    _reportLog.put(reportlog);
    if (reportlog.result != null) {
      reportlog.result!.reportModels.add(reportlog);
      StorageService.instance.constantBox.setResult(reportlog.result!);
    }
    if (reportlog.shortUser != null) {
      reportlog.shortUser!.reportLogs.add(reportlog);
      _setShortUser(reportlog.shortUser!);
    }
  }

  void _setShortUser(ShortUser shortUser) => _shortUser.put(shortUser);
  void updateReports(UpdateReport updateReport) {
    setReports(updateReport.newRows);
    _deletedReports(updateReport.deletedIds);
    _updatedReports(updateReport.updatedRows);
  }

  void _deletedReports(List<int> reportIds) {
    for (int reportId in reportIds) {
      _deletedReport(reportId);
    }
  }

  void _updatedReports(List<Report> reports) {
    for (Report report in reports) {
      _deletedReport(report.id);

      //Report is حجة or حجة+ or نم التسليم or تم المراجعة => don't add new database
      if (report.reportlogs != null) {
        if (report.reportlogs!.isNotEmpty) {
          ReportLog reportLog = report.reportlogs![0];
          for (ReportLog log in report.reportlogs!) {
            if (reportLog.id <= log.id) {
              reportLog = log;
            }
          }

          if (reportLog.result!.name == 'حجة' ||
              reportLog.result!.name == '+حجة') {
            continue;
          }

          if (report.userIsReceived == true || report.patientIsCame == true) {
            continue;
          }
        }
      }
      setReport(report);
    }
  }

  void setReports(List<Report> reports) {
    for (Report report in reports) {
      setReport(report);
    }
  }

  void _deletedReport(int reportId) {
    final Report? report = _report.get(reportId);
    if (report != null) {
      _deletedReportLogsRelatedToReport(reportId);
      final RegionModel? region = StorageService.instance.constantBox
          .getRegionRelatedToReport(report.id);
      if (region != null) {
        region.reports.removeWhere((report) => report.id == reportId);
      }
      final PriorityModel? priority = StorageService.instance.constantBox
          .getPriorityRelatedToReport(report.id);
      if (priority != null) {
        priority.reports.removeWhere((report) => report.id == reportId);
      }
      final TypeModel? type =
          StorageService.instance.constantBox.getTypeRelatedToReport(report.id);
      if (type != null) {
        type.reports.removeWhere((report) => report.id == reportId);
      }
      final ShortUser? shortUser = _getShortUserRelatedToReport(report.id);
      if (shortUser != null) {
        shortUser.reports.removeWhere((report) => report.id == reportId);
      }
      _report.remove(reportId);
    }
  }

  void _deletedReportLogsRelatedToReport(int reportId) {
    final QueryBuilder<ReportLog> builder = _reportLog.query();
    builder.link(ReportLog_.report, Report_.id.equals(reportId));
    final Query<ReportLog> query = builder.build();
    final List<ReportLog> reportLogs = query.find();
    query.close();
    for (ReportLog reportLog in reportLogs) {
      _deletedReportLog(reportLog.id);
    }
  }

  void _deletedReportLog(int reportLogId) {
    final ResultModel? result = StorageService.instance.constantBox
        .getResultRelatedToReportModel(reportLogId);
    if (result != null) {
      result.reportModels.removeWhere((report) => report.id == reportLogId);
    }
    _reportLog.remove(reportLogId);
  }
}
