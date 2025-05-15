import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/blog/domain/models/post_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_image_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';

import '../controllers/post_details_controller.dart';

class PostImageWidget extends StatefulWidget {
  final PostModel? postModel;
  const PostImageWidget({super.key, required this.postModel});

  @override
  State<PostImageWidget> createState() => _PostImageWidgetState();
}

class _PostImageWidgetState extends State<PostImageWidget> {
  final PageController _controller = PageController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<PostDetailsController>(context, listen: false)
            .setImageSliderSelectedIndex(0);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.postModel != null
        ? Consumer<PostDetailsController>(builder: (context, controller, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ProductImageScreen(
                              title: getTranslated('product_image', context),
                              imageList: widget.postModel!.imagesFullUrl,
                            ),
                          ),
                        ),
                    child: (widget.postModel != null)
                        ? Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.homePagePadding),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeSmall),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        border: Border.all(
                                            color: Provider.of<ThemeController>(
                                                        context,
                                                        listen: false)
                                                    .darkTheme
                                                ? Theme.of(context)
                                                    .hintColor
                                                    .withOpacity(.25)
                                                : Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(.25)),
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.paddingSizeSmall)),
                                    child: Stack(children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: PageView.builder(
                                          controller: _controller,
                                          itemCount: widget
                                              .postModel!.imagesFullUrl.length,
                                          itemBuilder: (context, index) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions
                                                          .paddingSizeSmall),
                                              child: CustomImageWidget(
                                                  height: 100,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  image:
                                                      '${widget.postModel!.imagesFullUrl[index].path}'),
                                            );
                                          },
                                          onPageChanged: (index) => controller
                                              .setImageSliderSelectedIndex(
                                                  index),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 10,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(),
                                            const Spacer(),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: _indicators(context)),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: Dimensions
                                                      .paddingSizeDefault,
                                                  bottom: Dimensions
                                                      .paddingSizeDefault),
                                              child: Text(
                                                  '${controller.imageSliderIndex + 1}/${widget.postModel?.imagesFullUrl.length}'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]))))
                        : const SizedBox()),
                Padding(
                  padding: EdgeInsets.only(
                      left: Provider.of<LocalizationController>(context,
                                  listen: false)
                              .isLtr
                          ? Dimensions.homePagePadding
                          : 0,
                      right: Provider.of<LocalizationController>(context,
                                  listen: false)
                              .isLtr
                          ? 0
                          : Dimensions.homePagePadding,
                      bottom: Dimensions.paddingSizeLarge),
                  child: SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                      itemCount: widget.postModel!.imagesFullUrl.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              controller.setImageSliderSelectedIndex(index);
                              _controller.animateToPage(index,
                                  duration: const Duration(microseconds: 50),
                                  curve: Curves.ease);
                            },
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    right: Dimensions.paddingSizeSmall),
                                child: Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: index ==
                                                        controller
                                                            .imageSliderIndex
                                                    ? 2
                                                    : 0,
                                                color: (index ==
                                                            controller
                                                                .imageSliderIndex &&
                                                        Provider.of<ThemeController>(
                                                                context,
                                                                listen: false)
                                                            .darkTheme)
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : (index == controller.imageSliderIndex &&
                                                            !Provider.of<ThemeController>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .darkTheme)
                                                        ? Theme.of(context).primaryColor
                                                        : const Color(0x00FFFFFF)),
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.paddingSizeExtraSmall),
                                          child: CustomImageWidget(
                                              height: 50,
                                              width: 50,
                                              image:
                                                  '${widget.postModel!.imagesFullUrl[index].path}'),
                                        )))));
                      },
                    ),
                  ),
                )
              ],
            );
          })
        : const SizedBox();
  }

  List<Widget> _indicators(BuildContext context) {
    List<Widget> indicators = [];
    for (int index = 0;
        index < widget.postModel!.imagesFullUrl.length;
        index++) {
      indicators.add(Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraExtraSmall),
        child: Container(
          width: index ==
                  Provider.of<PostDetailsController>(context).imageSliderIndex
              ? 20
              : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: index ==
                    Provider.of<PostDetailsController>(context).imageSliderIndex
                ? Theme.of(context).primaryColor
                : Theme.of(context).hintColor,
          ),
        ),
      ));
    }
    return indicators;
  }
}
