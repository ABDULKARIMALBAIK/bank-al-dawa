import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/urls.dart';

class NoResults extends StatelessWidget {
  const NoResults({
    Key? key,
    this.onRefresh,
  }) : super(key: key);

  final Function? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          SizedBox(
              width: 200,
              height: 200,
              child: SvgPicture.asset(ConstUrls
                  .noResultsImageUrl) //Image(image: AssetImage("assets/images/no_results.png")),
              ),
          const SizedBox(
            height: 30,
          ),
          Text('لا يوجد بيانات لعرضها',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
