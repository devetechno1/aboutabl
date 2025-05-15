import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/custom_image_widget.dart';
import '../../../di_container.dart';
import '../../../localization/language_constrants.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../category/domain/models/category_model.dart';
import '../controllers/category_product_controller.dart';

class CategoryProductScreen extends StatelessWidget {
  const CategoryProductScreen({
    super.key,
    required this.category,
  });
  final Category category;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => sl<CategoryProductController>(),
      builder: (_, c) => _CategoryProductScreen(category: category),
    );
  }
}

class _CategoryProductScreen extends StatefulWidget {
  final Category category;
  const _CategoryProductScreen({
    required this.category,
  });

  @override
  State<_CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<_CategoryProductScreen> {
  late final CategoryProductController c =
      Provider.of<CategoryProductController>(context, listen: false);

  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.initCat(widget.category);
    });

    scrollController.addListener(controllerListener);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(controllerListener);
    scrollController.dispose();
  }

  void controllerListener() {
    if (scrollController.offset >=
        scrollController.position.maxScrollExtent - 10) {
      c.getCategoryProductMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.category.name),
      body: Consumer<CategoryProductController>(
        builder: (context, controller, child) {
          if (AppConstants.isSubCategoriesGrid) {
            return dataInGrid(controller);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              if (controller.subCategories?.isNotEmpty == true)
                categoryRow(controller),

              // Products
              Expanded(child: getProducts(controller)),
            ],
          );
        },
      ),
    );
  }

  Widget getProducts(CategoryProductController controller) {
    if (controller.categoryProductList.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: controller.refreshProducts,
        child: Column(
          children: [
            Expanded(
              child: MasonryGridView.count(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: Dimensions.paddingSizeSmall),
                physics: const BouncingScrollPhysics(),
                crossAxisCount: MediaQuery.sizeOf(context).width > 480 ? 3 : 2,
                itemCount: controller.categoryProductList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ProductWidget(
                      productModel: controller.categoryProductList[index]);
                },
              ),
            ),
            if (controller.isLoadingPagination)
              const Align(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 5),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      );
    } else {
      return controller.hasData
          ? ProductShimmer(
              padding: const EdgeInsets.symmetric(vertical: 12),
              isHomePage: false,
              isEnabled: controller.categoryProductList.isEmpty,
            )
          : const NoInternetOrDataScreenWidget(
              isNoInternet: false,
              icon: Images.noProduct,
              message: 'no_product_found',
            );
    }
  }

  Widget dataInGrid(CategoryProductController controller) {
    final List<Category> childes = controller.category.childes ?? [];
    if (childes.isEmpty) {
      return getProducts(controller);
    }
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.sizeOf(context).width > 480 ? 4 : 3,
        childAspectRatio: 1,
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      children: List.generate(
        childes.length,
        (index) {
          final Category cat = childes[index];
          return CatWidget(
            isSelected: controller.currentIndex == index,
            name: cat.name ?? '',
            fullURL: '${cat.imageFullUrl?.path}',
            index: index,
            length: childes.length,
            onTap: () => controller.getProductsCatAndSubIndex(
              context,
              index,
              category: cat,
            ),
          );
        },
      ),
    );
  }

  Container categoryRow(CategoryProductController controller) {
    final List<Category> subCategories = controller.subCategories ?? [];
    final bool catWithImage = !widget.category.allChildesWithoutImage;
    return Container(
      height: catWithImage ? (54 + MediaQuery.sizeOf(context).width / 6.5) : 54,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey)),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
        ),
        children: [
          Align(
            child: catWithImage
                ? OutlinedButton(
                    onPressed: controller.pressViewAll,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: controller.currentIndex == -1
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : null,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      fixedSize:
                          Size.square(MediaQuery.sizeOf(context).width / 6),
                      alignment: Alignment.center,
                      side: controller.currentIndex == -1
                          ? BorderSide(color: Theme.of(context).primaryColor)
                          : const BorderSide(width: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(500),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        getTranslated("VIEW_ALL", context) ?? 'All',
                        style: controller.currentIndex == -1
                            ? null
                            : textRegular.copyWith(
                                color: ColorResources.getTextTitle(
                                  context,
                                ),
                              ),
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: controller.pressViewAll,
                    style: controller.currentIndex == -1
                        ? TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                          )
                        : null,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        getTranslated("VIEW_ALL", context) ?? 'All',
                        style: controller.currentIndex == -1
                            ? null
                            : textRegular.copyWith(
                                color: ColorResources.getTextTitle(
                                  context,
                                ),
                              ),
                      ),
                    ),
                  ),
          ),
          ...List.generate(
            subCategories.length,
            (index) {
              final Category subCat = subCategories[index];
              return CatWidget(
                isSelected: controller.currentIndex == index,
                name: subCat.name ?? '',
                catWithImage: catWithImage,
                fullURL: subCat.imageFullUrl?.path,
                index: index,
                length: subCategories.length,
                onTap: () => controller.getProductsCatAndSubIndex(
                  context,
                  index,
                  category: subCat,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class CatWidget extends StatelessWidget {
  final String name;
  final String? fullURL;
  final int index;
  final int length;
  final bool catWithImage;
  final bool isSelected;
  final void Function() onTap;
  const CatWidget({
    super.key,
    required this.name,
    required this.index,
    required this.fullURL,
    required this.length,
    this.catWithImage = true,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: Dimensions.homePagePadding,
        ),
        child: catWithImage && fullURL?.isNotEmpty == true
            ? InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width / 6.5,
                      width: MediaQuery.of(context).size.width / 6.5,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.125),
                              width: isSelected ? 1 : .25),
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeSmall),
                          color:
                              Theme.of(context).primaryColor.withOpacity(.125)),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimensions.paddingSizeSmall),
                        child: CustomImageWidget(image: fullURL!),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 6.5,
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: isSelected
                              ? textRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).primaryColor,
                                )
                              : textRegular.copyWith(
                                  fontSize: isSelected
                                      ? Dimensions.fontSizeDefault
                                      : Dimensions.fontSizeSmall,
                                  color: ColorResources.getTextTitle(context),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : TextButton(
                onPressed: onTap,
                style: isSelected
                    ? TextButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                      )
                    : null,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    name,
                    style: isSelected
                        ? null
                        : textRegular.copyWith(
                            color: ColorResources.getTextTitle(
                              context,
                            ),
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}
