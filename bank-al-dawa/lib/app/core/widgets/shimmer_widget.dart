import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../services/size_configration.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    required this.width,
    required this.height,
    required this.shapeBorder,
    Key? key,
  }) : super(key: key);
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangle(
      {required this.height, required this.width, Key? key})
      : shapeBorder = const RoundedRectangleBorder(),
        super(key: key);

  const ShimmerWidget.circular(
      {required this.height,
      required this.width,
      this.shapeBorder = const CircleBorder(),
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenSizer(
      builder: (CustomSize customSize) {
        return Shimmer.fromColors(
            baseColor: Colors.black54,
            highlightColor: Colors.grey[500]!,
            child: Container(
              width: width,
              height: height,
              decoration:
                  ShapeDecoration(color: Colors.grey[400], shape: shapeBorder),
            ));
      },
    );
  }
}
