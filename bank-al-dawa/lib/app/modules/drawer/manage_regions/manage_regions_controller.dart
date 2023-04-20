import 'package:bank_al_dawa/app/core/helper/data_helper.dart';
import 'package:bank_al_dawa/app/core/models/app_models/region_model.dart';
import 'package:bank_al_dawa/app/core/services/getx_storage_controller.dart';
import 'package:bank_al_dawa/app/core/services/request_manager.dart';
import 'package:bank_al_dawa/app/modules/drawer/shared/drawer_repository.dart';
import 'package:flutter/material.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/widgets/toast.dart';
import '../../../core/widgets/widget_state.dart';

class ManageRegionsController extends GetxStorageController {
  DrawerRepository drawerRepository;

  ScrollController scrollController = ScrollController();
  String locationSearchSelected = '';
  bool isDark = false;
  String isArabic = 'arabic';

  String listRegionBuild = 'listRegionBuild';
  TextEditingController addRegionController = TextEditingController();

  List<RegionModel> regions = [];
  FocusNode textFieldNode = FocusNode();

  @override
  void onInit() async {
    loadRegions();
    super.onInit();
  }

  void updateLocationSearchedItem(String newLocation) {
    locationSearchSelected = newLocation;
    update();
  }

  ManageRegionsController({required this.drawerRepository});

  Future<void> loadRegions({requestType = RequestType.getData}) async {
    try {
      updateState([listRegionBuild], WidgetState.loading);
      await Future.delayed(const Duration(milliseconds: 200));

      final List<RegionModel> loadedRegions =
          await drawerRepository.getRegions();

      if (loadedRegions.isEmpty) {
        updateState([listRegionBuild], WidgetState.noResults);
      } else {
        regions = loadedRegions;
        updateState([listRegionBuild], WidgetState.loaded);
      }
    } on CustomException catch (e) {
      updateState([listRegionBuild], WidgetState.error);
      CustomToast.showError(e.error);
    }
  }

  Future<void> deleteRegion(RegionModel regionModel) async {
    try {
      CustomToast.showLoading();
      await Future.delayed(const Duration(milliseconds: 100));

      final bool result =
          await drawerRepository.deleteRegion(regionModel.id.toString());

      if (result) {
        //Remove item in List
        regions.remove(regionModel);

        //Remove item in Local database
        storageService.constantBox.deleteRegion(regionModel.id);

        //Remove item in DataList in helper
        DataHelper.regions.remove(regionModel);

        CustomToast.closeLoading();
        updateState([listRegionBuild], WidgetState.loaded);

        Future.delayed(const Duration(milliseconds: 200))
            .then((value) => CustomToast.showDefault('تم حذف المنطقة بنجاح'));
      } else {
        CustomToast.closeLoading();
        CustomToast.showDefault('مشكلة ما حدثت');
      }
    } on CustomException catch (e) {
      CustomToast.closeLoading();
      Future.delayed(const Duration(milliseconds: 200))
          .then((value) => CustomToast.showError(e.error));
    }
  }

  Future<void> addRegion() async {
    try {
      if (addRegionController.text.trim().isEmpty) {
        Future.delayed(const Duration(milliseconds: 200)).then(
            (value) => CustomToast.showDefault('املئ حقل اسم المنطقة من فضلك'));
      } else {
        CustomToast.showLoading();
        await Future.delayed(const Duration(milliseconds: 100));

        final bool result =
            await drawerRepository.addRegion(addRegionController.text);

        if (result) {
          //Get last added region by id (SHould get by name not id !!!)
          final RegionModel region = await drawerRepository
              .getRegionById((regions.last.id + 1).toString());

          //Remove item in List
          regions.add(region);

          //Remove item in Local database
          storageService.constantBox.setRegion(region);

          //Remove item in DataList in helper
          DataHelper.regions.add(region);

          CustomToast.closeLoading();
          updateState([listRegionBuild], WidgetState.loaded);

          Future.delayed(const Duration(milliseconds: 200)).then(
              (value) => CustomToast.showDefault('تم اضافة المنطقة بنجاح'));
        } else {
          CustomToast.closeLoading();
          CustomToast.showDefault('مشكلة ما حدثت');
        }
      }
    } on CustomException catch (e) {
      CustomToast.closeLoading();
      Future.delayed(const Duration(milliseconds: 200))
          .then((value) => CustomToast.showError(e.error));
    }
  }

  Future<void> updateRegion(RegionModel regionModel) async {
    try {
      if (addRegionController.text.trim().isEmpty) {
        Future.delayed(const Duration(milliseconds: 200)).then(
            (value) => CustomToast.showDefault('املئ حقل اسم المنطقة من فضلك'));
      } else {
        CustomToast.showLoading();
        await Future.delayed(const Duration(milliseconds: 100));

        final bool result = await drawerRepository.updateRegion(
            regionId: regionModel.id.toString(),
            regionName: addRegionController.text);

        if (result) {
          final RegionModel updatedRegion =
              RegionModel(id: regionModel.id, name: addRegionController.text);

          //Remove item in List
          regions[regions.indexWhere((region) => region.id == regionModel.id)] =
              updatedRegion;

          //Remove item in Local database
          storageService.constantBox.setRegion(updatedRegion);

          //Remove item in DataList in helper
          DataHelper.regions[DataHelper.regions
                  .indexWhere((region) => region.id == regionModel.id)] =
              updatedRegion;

          CustomToast.closeLoading();
          updateState([listRegionBuild], WidgetState.loaded);

          Future.delayed(const Duration(milliseconds: 200)).then(
              (value) => CustomToast.showDefault('تم تعديل المنطقة بنجاح'));
        } else {
          CustomToast.closeLoading();
          CustomToast.showDefault('مشكلة ما حدثت');
        }
      }
    } on CustomException catch (e) {
      CustomToast.closeLoading();
      Future.delayed(const Duration(milliseconds: 200))
          .then((value) => CustomToast.showError(e.error));
    }
  }
}
