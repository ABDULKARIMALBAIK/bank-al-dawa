import 'package:bank_al_dawa/app/core/constants/colors.dart';
import 'package:bank_al_dawa/app/core/models/app_models/meetings_model.dart';
import 'package:bank_al_dawa/app/core/widgets/no_resulte.dart';
import 'package:bank_al_dawa/app/core/widgets/widget_state.dart';
import 'package:bank_al_dawa/app/modules/drawer/meetings/meetings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/size_configration.dart';

class MeetingsView extends GetView<MeetingsController> {
  const MeetingsView({Key? key}) : super(key: key);

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
                      _headerText(
                          context, customSize.screenWidth, 'meetings_title'.tr)
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
      child: StateBuilder<MeetingsController>(
        key: UniqueKey(),
        id: controller.idState,
        disableState: false,
        onRetryFunction: () {
          controller.getMeetings();
        },
        noResultView: const NoResults(),
        // loadingView: ,
        // errorView: ,
        initialWidgetState: WidgetState.loading,
        builder: (WidgetState widgetState, controllers) {
          if (controller.meetings.isEmpty) {
            return const NoResults();
          } else {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: controller.meetings.length,
              itemBuilder: (context, index) =>
                  _meetingItem(context, controller.meetings[index]),
            );
          }
        },
      ),
      // child: ListView.builder(
      //   itemCount: 10,
      //   itemBuilder: (context, index) => _meetingItem(context),
      // ),
    );
  }

  Padding _meetingItem(BuildContext context, MeetingModel meetingModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.orange,
                  Colors.orangeAccent,
                ])),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ////////////////////////////////// * title * //////////////////////////////////
            _meetingDetails(context, 'meetings_title_meeting'.tr,
                ': ${meetingModel.title}'), // ': مقابلة المنظمون'
            const SizedBox(
              height: 4,
            ),

            ////////////////////////////////// * description * //////////////////////////////////
            _meetingDetails(context, 'meetings_subtitle_meeting'.tr,
                ': ${meetingModel.description}'), //': مناقشة حلول العمليات التخزين'
            const SizedBox(
              height: 4,
            ),

            ////////////////////////////////// * date * //////////////////////////////////
            _meetingDetails(context, 'meetings_date_meeting'.tr,
                ': ${meetingModel.date.toString().substring(0, 10)}'), //': 2/3/2022'
            const SizedBox(
              height: 2,
            ),
          ],
        ),
      ),
    );
  }

  RichText _meetingDetails(
      BuildContext context, String title, String description) {
    return RichText(
      text: TextSpan(
          text: title,
          style: Theme.of(context).textTheme.bodyText2,
          children: [
            TextSpan(
              text: description,
            )
          ]),
    );
  }
}
