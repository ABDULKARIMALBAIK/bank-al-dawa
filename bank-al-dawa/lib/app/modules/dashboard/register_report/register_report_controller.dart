import 'package:bank_al_dawa/app/core/models/app_models/region_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/short_user_model.dart';
import 'package:bank_al_dawa/app/core/services/getx_storage_controller.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/models/report_models/priority_model.dart';
import '../../../core/models/report_models/type_model.dart';
import '../../../core/models/user_models/user_model.dart';
import '../../../core/widgets/toast.dart';

class RegisterReportController extends GetxStorageController {
  DashboardRepository dashboardRepository;

  ScrollController scrollController = ScrollController();
  bool isDark = false;
  String isArabic = 'arabic';

  TextEditingController usernameController = TextEditingController();
  TextEditingController actualAddressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController phoneNumber2Controller = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String selectedEmployee = '';
  String selectedAddress = '';
  int checkStatesSelected = 1; //مساعدة - جديد - اعادة
  int checkTypesSelected = 4; //مستعجل - ضروري - انتباه

  String regionsId = 'regionsId';
  String employeeId = 'employeeId';
  String statesId = 'statesId';
  String typesId = 'typesId';
  String titleId = 'titleId';

  dynamic argumentData = Get.arguments;
  bool isFromNonHome = false;

  bool isPressed1 = false;
  bool isPressed2 = false;
  bool isPressed3 = false;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() async {
    // isDark = await storageService.themeStorage.darkMode();
    // isArabic =
    //     (await storageService.languageStorage.getLanguage()).currentLanguage;

    //Very Important operation
    isFromNonHome = argumentData[0]['from_non_home'];
    if (isFromNonHome) {
      checkManageAccounts();
    }

    super.onInit();
  }

  RegisterReportController({required this.dashboardRepository});

  Future<void> registerNewReport() async {
    try {
      /*
      (usernameController.text.isEmpty ||
              actualAddressController.text.isEmpty ||
              phoneNumberController.text.isEmpty ||
              phoneNumber2Controller.text.isEmpty ||
              noteController.text.isEmpty ||
              selectedEmployee == '' ||
              selectedAddress == '') &&
          !isFromNonHome
       */

      if (!isFromNonHome) {
        if (!formKey.currentState!.validate()) {
          CustomToast.showDefault('register_report_fill_data'.tr);
          return;
        }
      }

      if ((usernameController.text.isEmpty ||
              phoneNumberController.text.isEmpty ||
              selectedEmployee == '' ||
              selectedAddress == '') &&
          !isFromNonHome) {
        CustomToast.showDefault('register_report_fill_data'.tr);
      } else {
        CustomToast.showLoading();

        //Get Region Id
        String regionId = '0';
        for (RegionModel region in DataHelper.regions) {
          if (region.name == selectedAddress) {
            regionId = region.id.toString();
          }
        }

        //Get User Id
        String userId = '1';
        for (User user in DataHelper.employees) {
          if (user.name == selectedEmployee) {
            userId = user.id.toString();
          }
        }

        //Home Screen
        if (isFromNonHome) {
          final Map<String, dynamic> queryParameters =
              setupQueryParameters(regionsId: regionId, userId: userId);

          final bool result = await dashboardRepository.updateReport(
              queryParameter: queryParameters,
              reportId: DataHelper.reportModel!.id.toString());

          CustomToast.closeLoading();

          if (result) {
            CustomToast.showDefault('edit_report_is_edited_successfully'.tr);

            //Start Now Mapping data with new changes

            DataHelper.reportModel!.optionalPhone = phoneNumber2Controller.text;
            DataHelper.reportModel!.details = noteController.text;
            DataHelper.reportModel!.name = usernameController.text;
            DataHelper.reportModel!.phone = phoneNumberController.text;
            DataHelper.reportModel!.addressDetails =
                actualAddressController.text;

            //Map Region
            final RegionModel regionModel = DataHelper.regions
                // ignore: unrelated_type_equality_checks
                [DataHelper.regions
                    .indexWhere((region) => region.id == int.parse(regionId))];
            final RegionModel region =
                RegionModel(id: regionModel.id, name: regionModel.name);

            DataHelper.reportModel!.region = region;

            //Map User
            final User user = DataHelper.employees
                // ignore: unrelated_type_equality_checks
                [DataHelper.employees.indexWhere(
                    (employee) => employee.id == int.parse(userId))];
            final ShortUser userReport =
                ShortUser(id: user.id, name: user.name);

            DataHelper.reportModel!.setShortUser = userReport;

            //Map Priority
            final PriorityModel? modelProperty = getPriorityWhenUpdate();
            final PriorityModel priority = PriorityModel(
                id: modelProperty!.id, color: modelProperty.color);
            DataHelper.reportModel!.priority = priority;

            //Map Type
            final TypeModel? typeModel = getTypeWhenUpdate();
            final TypeModel type =
                TypeModel(id: typeModel!.id, name: typeModel.name);
            DataHelper.reportModel!.type = type;

            Get.back(result: [
              {'isUpdated': true}
            ]);

            CustomToast.showDefault('نم تعديل الكشف بنجاح');
          } else {
            CustomToast.showDefault('مشكلة ما قد حدثت');
          }
        }
        //Featured Reports || All Reports || Non-Delivered Reports Screens
        else {
          final bool result = await dashboardRepository.registerNewReport(
              usernameController.text,
              setPriority(), //checkTypesSelected + 1
              setType(), //checkStatesSelected + 1
              phoneNumberController.text,
              int.parse(regionId),
              actualAddressController.text,
              int.parse(userId),
              phoneNumber2Controller.text,
              noteController.text);

          CustomToast.closeLoading();

          if (result) {
            Get.back(result: [
              {'isCreated': true}
            ]);

            CustomToast.showDefault(
                'register_report_is_entered_successfully'.tr);
          } else {
            Get.back(result: [
              {'isCreated': false}
            ]);

            CustomToast.showDefault('مشكلة ما قد حدثت');
          }
        }
      }
    } on CustomException catch (e) {
      CustomToast.closeLoading();
      CustomToast.showError(e.error);
    }
  }

  void checkManageAccounts() {
    usernameController.text = isFromNonHome ? DataHelper.reportModel!.name : '';
    phoneNumberController.text =
        isFromNonHome ? DataHelper.reportModel!.phone : '';
    actualAddressController.text =
        isFromNonHome ? DataHelper.reportModel!.addressDetails ?? '' : '';

    phoneNumber2Controller.text =
        isFromNonHome ? DataHelper.reportModel!.optionalPhone : '';
    noteController.text = isFromNonHome ? DataHelper.reportModel!.details : '';

    switch (DataHelper.reportModel!.priority!.color.toString()) {
      //checkTypesSelected
      case 'ضروري':
        {
          isPressed1 = false;
          isPressed2 = false;
          isPressed3 = true;
          checkTypesSelected = 2;
          break;
        }
      case 'مستعجل':
        {
          isPressed1 = false;
          isPressed2 = true;
          isPressed3 = false;
          checkTypesSelected = 1;
          break;
        }
      case 'انتباه':
        {
          isPressed1 = true;
          isPressed2 = false;
          isPressed3 = false;
          checkTypesSelected = 0;
          break;
        }
      default:
        {
          isPressed1 = false;
          isPressed2 = false;
          isPressed3 = false;
          break;
        }
    }
    update([typesId]);

    checkStatesSelected = isFromNonHome
        ? int.parse(DataHelper.reportModel!.type!.id.toString()) - 1 //?? '1'
        : 1;
    update([statesId]);

    //Update Text
    update([titleId]);

    selectedAddress = DataHelper.reportModel!.region == null
        ? ''
        : DataHelper.reportModel!.region!.name;
    update([regionsId]);

    selectedEmployee = DataHelper.reportModel!.shortUser!.name; // ?? ''
    update([employeeId]);
  }

  int setPriority() {
    int id = -1;
    if (checkTypesSelected == 0) {
      for (var priority in DataHelper.priorities) {
        if (priority.color == 'انتباه') {
          id = priority.id;
        }
      }
      return id;
    } else if (checkTypesSelected == 1) {
      for (var priority in DataHelper.priorities) {
        if (priority.color == 'مستعجل') {
          id = priority.id;
        }
      }
      return id;
    } else if (checkTypesSelected == 2) {
      for (var priority in DataHelper.priorities) {
        if (priority.color == 'ضروري') {
          id = priority.id;
        }
      }
      return id;
    } else {
      for (var priority in DataHelper.priorities) {
        if (priority.color == 'عادي') {
          id = priority.id;
        }
      }
      return id;
    }
  }

  int setType() {
    int id = -1;
    if (checkStatesSelected == 0) {
      for (var type in DataHelper.types) {
        if (type.name == 'مساعدة') {
          id = type.id;
        }
      }
      return id;
    } else if (checkStatesSelected == 1) {
      for (var type in DataHelper.types) {
        if (type.name == 'جديد') {
          id = type.id;
        }
      }
      return id;
    } else if (checkStatesSelected == 2) {
      for (var type in DataHelper.types) {
        if (type.name == 'إعادة') {
          id = type.id;
        }
      }
      return id;
    } else {
      return id;
    }
  }

  PriorityModel? getPriorityWhenUpdate() {
    PriorityModel? priorityData;
    if (checkTypesSelected == 0) {
      for (var priority in DataHelper.priorities) {
        if (priority.color == 'انتباه') {
          priorityData = priority;
        }
      }
      return priorityData;
    } else if (checkTypesSelected == 1) {
      for (var priority in DataHelper.priorities) {
        if (priority.color == 'مستعجل') {
          priorityData = priority;
        }
      }
      return priorityData;
    } else if (checkTypesSelected == 2) {
      for (var priority in DataHelper.priorities) {
        if (priority.color == 'ضروري') {
          priorityData = priority;
        }
      }
      return priorityData;
    } else {
      for (var priority in DataHelper.priorities) {
        if (priority.color == 'عادي') {
          priorityData = priority;
        }
      }
      return priorityData;
    }
  }

  TypeModel? getTypeWhenUpdate() {
    TypeModel? typeData;
    if (checkStatesSelected == 0) {
      for (var type in DataHelper.types) {
        if (type.name == 'مساعدة') {
          typeData = type;
        }
      }
      return typeData;
    } else if (checkStatesSelected == 1) {
      for (var type in DataHelper.types) {
        if (type.name == 'جديد') {
          typeData = type;
        }
      }
      return typeData;
    } else if (checkStatesSelected == 2) {
      for (var type in DataHelper.types) {
        if (type.name == 'إعادة') {
          typeData = type;
        }
      }
      return typeData;
    } else {
      return typeData;
    }
  }

  Map<String, dynamic> setupQueryParameters(
      {required String regionsId, required String userId}) {
    /*
                "name": name,
            "priority_id": priorityId,
            "type_id": typeId,
            "phone": phone,
            "region_id": regionId,
            "address_details": addressDetails,
            "user_id": userId,
     */
    final Map<String, dynamic> queryParameters = {};

    final int priority = setPriority();
    final int type = setType();

    if (usernameController.text.isNotEmpty) {
      queryParameters["name"] = usernameController.text;
    }

    if (priority != -1) {
      queryParameters["priority_id"] = priority;
    }

    if (type != -1) {
      queryParameters["type_id"] = type;
    }

    if (phoneNumberController.text.isNotEmpty) {
      queryParameters["phone"] = phoneNumberController.text;
    }

    if (regionsId != '-1') {
      queryParameters["region_id"] = int.parse(regionsId);
    }

    if (actualAddressController.text.isNotEmpty) {
      queryParameters["address_details"] = actualAddressController.text;
    }

    if (userId != '-1') {
      queryParameters["user_id"] = int.parse(userId);
    }

    if (phoneNumber2Controller.text.isNotEmpty) {
      queryParameters["optionalPhone"] = phoneNumber2Controller.text;
    }

    if (noteController.text.isNotEmpty) {
      queryParameters["details"] = noteController.text;
    }

    return queryParameters;
  }
}
