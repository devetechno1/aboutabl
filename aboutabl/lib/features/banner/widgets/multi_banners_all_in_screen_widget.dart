import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/domain/models/banner_model.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';

class MultiBannersAllInScreenWidget extends StatelessWidget {
  final List<BannerModel>? banners;
  final double? height;
  final bool noRadius;
  const MultiBannersAllInScreenWidget({
    super.key,
    this.banners,
    this.height,
    this.noRadius = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerController>(
      builder: (context, bannerProvider, child) {
        if (!(banners?.isEmpty == false)) return const SizedBox();

        return Row(
          children: List.generate(
            banners!.length,
            (index) {
              final bannerModel = banners![index];
              return Expanded(
                child: InkWell(
                  onTap: () {
                    bannerProvider.clickBannerRedirect(
                      context,
                      bannerModel.resourceId,
                      bannerModel.resourceType == 'product'
                          ? bannerModel.product
                          : null,
                      bannerModel.resourceType,
                      bannerModel.url,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Container(
                      // width: MediaQuery.of(context).size.width,
                      // height: height ?? MediaQuery.of(context).size.width / 2.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(noRadius
                              ? const Radius.circular(0)
                              : const Radius.circular(5))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(noRadius ? 0 : 5),
                        ),
                        child: CustomImageWidget(
                          image: '${bannerModel.photoFullUrl?.path}',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
