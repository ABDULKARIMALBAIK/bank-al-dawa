import 'package:bank_al_dawa/app/core/widgets/neumorphic_container.dart';
import 'package:bank_al_dawa/app/core/widgets/widget_state.dart';
import 'package:bank_al_dawa/app/modules/authentication/wrapper/wrapper_controller.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/loading_app_widget.dart';

class WrapperView extends StatelessWidget {
  const WrapperView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: StateBuilder<WrapperController>(
              id: "WrapperView",
              disableState: true,
              builder: (widgetState, controller) {
                if (widgetState == WidgetState.error) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 80,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        SizedBox(
                          width: 130,
                          height: 50,
                          child: NeumorphicContainer(
                            duration: const Duration(milliseconds: 500),
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            borderRadius: BorderRadius.circular(120),
                            onTab: () {},
                            isInnerShadow: false,
                            isEffective: true,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                padding: const EdgeInsets.all(4),
                                elevation: 0,
                                side: BorderSide(
                                    width: 1.0,
                                    color: Theme.of(context).primaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(300),
                                ),
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: controller.getStatus,
                              child: Text(
                                "إعادة المحاولة",
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: LoadingAppWidget(),
                    ),
                  );
                }
              })),
    );
  }
}
