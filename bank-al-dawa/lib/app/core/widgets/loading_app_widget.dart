import 'package:bank_al_dawa/app/core/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class LoadingAppWidget extends StatelessWidget {
  const LoadingAppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          ConstUrls.appIconUrl,
          width: 220,
          height: 170,
          filterQuality: FilterQuality.high,
          fit: BoxFit.cover,
        ),
        // Icon(
        //   Icons.star,
        //   size: 80,
        //   color: Theme.of(context).primaryColor,
        // ),
        const SizedBox(
          height: 80,
        ),
        SizedBox(
          width: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(750),
            child: GradientProgressIndicator(
              gradient: Gradients.rainbowBlue,
            ),
          ),
        )
      ],
    );
  }
}
