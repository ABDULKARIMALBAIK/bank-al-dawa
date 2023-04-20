import 'package:bank_al_dawa/app/core/constants/colors.dart';
import 'package:bank_al_dawa/app/core/widgets/neumorphic_container.dart';
import 'package:bank_al_dawa/app/core/widgets/pagination.dart';
import 'package:bank_al_dawa/app/modules/dashboard/notification/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/models/app_models/notification_model.dart';
import '../../../core/services/request_manager.dart';
import '../../../core/services/size_configration.dart';
import '../../../core/widgets/widget_state.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: ScreenSizer(
          builder: (customSize) {
            return Container(
              width: customSize.screenWidth,
              height: customSize.screenHeight,
              decoration: _gradientColors(),
              child: NestedScrollView(
                  controller: controller.scrollController,
                  headerSliverBuilder: (context, boolean) {
                    return [
                      _headerText(context, customSize.screenWidth,
                          'notification_title'.tr)
                    ];
                  },
                  body: _body(context, customSize.screenWidth,
                      customSize.screenHeight)),
            );
          },
        ),
      ),
    );
  }

  /* Widget Methods */

  BoxDecoration _gradientColors() {
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
          ConstColors().primaryColorLight(),
          ConstColors().primaryColorDark(),
        ]));
  }

  SliverToBoxAdapter _headerText(
      BuildContext context, double screenWidth, String text) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: screenWidth,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Container _body(
      BuildContext context, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: StateBuilder<NotificationController>(
        id: controller.builderId,
        disableState: false,
        onRetryFunction: () =>
            controller.getNotifications(requestType: RequestType.refresh),
        // noResultView: ,
        // loadingView: ,
        // errorView: ,
        initialWidgetState: WidgetState.loading, //loading
        builder: (widgetState, controllers) {
          return PaginationBuilder<NotificationController>(
            id: controller.builderPaginationId,
            onRefresh: () =>
                controller.getNotifications(requestType: RequestType.refresh),
            onLoadingMore: () => controller.getNotifications(
                requestType: RequestType.loadingMore),
            builder: (scrollController) {
              return ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.dataList.length,
                itemBuilder: (context, index) {
                  return _notificationItem(
                      context, screenWidth, controller.dataList[index]);
                },
              );
            },
          );
        },
      ),
    );
  }

  Padding _notificationItem(
      BuildContext context, double screenWidth, NotificationModel model) {
    const spacerWidget = SizedBox(height: 5);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      child: SizedBox(
        width: screenWidth,
        child: NeumorphicContainer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          isEffective: false,
          isInnerShadow: false,
          duration: Duration.zero,
          borderRadius: BorderRadius.circular(12),
          onTab: () {
            if (model.reportId != null) {
              controller.getNotificationDetails(model.reportId!);
            }
          },
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ////////////////////////////////// * title * //////////////////////////////////
                  _notificationTitle(
                      context, model.title), //'تغيير منطقة العمل'
                  spacerWidget,

                  ////////////////////////////////// * description * //////////////////////////////////
                  _notificationDescription(
                      context, model.body), //'قام عمر الحاج بتغير منطقة عمله'
                  spacerWidget,

                  ////////////////////////////////// * date * //////////////////////////////////
                  _notificationDate(context, model.date), //'02-9-2021'
                  spacerWidget
                ],
              ),
              if (model.reportId != null)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.info),
                )
            ],
          ),
        ),
      ),
    );
  }

  Flexible _notificationTitle(BuildContext context, String title) {
    return Flexible(
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontWeight: FontWeight.bold),
        textAlign: TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Flexible _notificationDescription(BuildContext context, String description) {
    return Flexible(
      child: Text(
        description,
        style: Theme.of(context).textTheme.subtitle2,
        textAlign: TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Flexible _notificationDate(BuildContext context, DateTime date) {
    return Flexible(
      child: Text(
        DateFormat('yyyy-MM-dd').format(date),
        style: Theme.of(context)
            .textTheme
            .caption!
            .copyWith(fontStyle: FontStyle.italic),
        textAlign: TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
