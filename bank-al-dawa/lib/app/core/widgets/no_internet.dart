import 'package:flutter/material.dart';

import '../services/size_configration.dart';

class NoInternetConnection extends StatelessWidget {
  final Function? onRetryFunction;
  const NoInternetConnection({
    required this.onRetryFunction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenSizer(builder: (customSize) {
      return SizedBox(
        width: customSize.screenWidth,
        height: customSize.screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            onRetryFunction == null
                ? const SizedBox()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                    onPressed: () => onRetryFunction!(),
                    child: const Text("إعادة المحاولة"),
                  ),
          ],
        ),
      );
    });
  }
}
