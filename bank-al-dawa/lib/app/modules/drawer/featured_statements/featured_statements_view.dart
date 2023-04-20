import 'package:bank_al_dawa/app/core/constants/colors.dart';
import 'package:bank_al_dawa/app/core/services/size_configration.dart';
import 'package:bank_al_dawa/app/modules/drawer/featured_statements/featured_statements_controller.dart';
import 'package:bank_al_dawa/app/core/widgets/neumorphic_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeaturedStatementsView extends GetView<FeaturedStatementsController> {
  const FeaturedStatementsView({Key? key}) : super(key: key);

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
                            'featured_statements_title'.tr)
                      ];
                    },
                    body: _body(context, customSize.screenWidth,
                        customSize.screenHeight)),
              );
            },
          )),
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
      BuildContext context, double width, String text) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: width,
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

  Container _body(BuildContext context, double widget, double height) {
    return Container(
      width: widget,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => _featuredStatementItem(context),
      ),
    );
  }

  Padding _featuredStatementItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      child: NeumorphicContainer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
        isEffective: false,
        isInnerShadow: false,
        duration: const Duration(milliseconds: 300),
        borderRadius: BorderRadius.circular(10),
        onTab: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            ////////////////////////////// * User Data * //////////////////////////////
            _userData(context),

            ////////////////////////////// * Editing buttons * //////////////////////////////
            _cardButtons(context),
          ],
        ),
      ),
    );
  }

  Flexible _cardButtons(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ////////////////////////////// * Edit button * //////////////////////////////
            NeumorphicContainer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(16),
              isEffective: true,
              isInnerShadow: false,
              duration: const Duration(milliseconds: 300),
              borderRadius: BorderRadius.circular(18),
              onTab: () {},
              child: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(
              height: 14,
            ),

            ////////////////////////////// * Delete button * //////////////////////////////
            NeumorphicContainer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(16),
              isEffective: true,
              isInnerShadow: false,
              duration: const Duration(milliseconds: 300),
              borderRadius: BorderRadius.circular(18),
              onTab: () {},
              child: Icon(
                Icons.delete,
                color: controller.isDark ? Colors.redAccent : Colors.red,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _userData(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ////////////////////////////// * Line Status * //////////////////////////////
        Container(
          width: 4,
          height: 120,
          color: Colors.yellow,
        ),
        const SizedBox(
          width: 9,
        ),

        ////////////////////////////// * Statement Data * //////////////////////////////
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ////////////////////////////// * Name Data * //////////////////////////////
              _userDataItem(context, 'يسرى قامشلي', Icons.person),
              const SizedBox(
                height: 2,
              ),

              ////////////////////////////// * Location Data * //////////////////////////////
              _userDataItem(context, 'الاكرمية', Icons.location_on_rounded),
              const SizedBox(
                height: 2,
              ),

              ////////////////////////////// * Date Data * //////////////////////////////
              _userDataItem(
                  context, '21-5-2022', Icons.calendar_today_outlined),
              const SizedBox(
                height: 2,
              ),

              ////////////////////////////// * states Data * //////////////////////////////
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.star,
                      color: Colors.green,
                      size: 22,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Flexible _userDataItem(BuildContext context, String text, IconData icon) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 18,
          ),
          const SizedBox(
            width: 4,
          ),
          Flexible(
            child: Text(text,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2!),
          ),
        ],
      ),
    );
  }
}
