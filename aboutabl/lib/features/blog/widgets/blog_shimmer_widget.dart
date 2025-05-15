import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:shimmer/shimmer.dart';

class BlogShimmerWidget extends StatelessWidget {
  const BlogShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(Dimensions.homePagePadding),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 15,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.sizeOf(context).width > 480 ? 4 : 3,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorResources.iconBg(),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5)
              ]),
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).cardColor,
            highlightColor: Colors.grey[300]!,
            enabled: true,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: ColorResources.iconBg(),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          Container(
                              height: 5, color: Theme.of(context).cardColor)
                        ]),
                  ),
                ]),
          ),
        );
      },
    );
  }
}
