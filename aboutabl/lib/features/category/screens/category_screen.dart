import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:provider/provider.dart';

import '../../product/screens/category_product_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    Provider.of<ProductController>(context, listen: false)
        .initBrandOrCategoryProductList(
      false,
      Provider.of<CategoryController>(context, listen: false)
          .categoryList[0]
          .id
          .toString(),
      context,
    );
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
      Provider.of<ProductController>(context, listen: false)
          .initBrandOrCategoryProductList(
        false,
        Provider.of<CategoryController>(context, listen: false)
            .categoryList[0]
            .id
            .toString(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('CATEGORY', context)),
      body: Consumer<CategoryController>(
        builder: (context, categoryProvider, child) {
          return categoryProvider.categoryList.isNotEmpty
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                      width: 100,
                      margin: const EdgeInsets.only(top: 3),
                      height: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[
                                    Provider.of<ThemeController>(context)
                                            .darkTheme
                                        ? 700
                                        : 200]!,
                                spreadRadius: 1,
                                blurRadius: 1)
                          ]),
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: categoryProvider.categoryList.length,
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            CategoryModel category =
                                categoryProvider.categoryList[index];
                            return InkWell(
                                onTap: () {
                                  categoryProvider.changeSelectedIndex(index);
                                  Provider.of<ProductController>(context,
                                          listen: false)
                                      .initBrandOrCategoryProductList(
                                    false,
                                    categoryProvider.categoryList[index].id
                                        .toString(),
                                    context,
                                  );
                                },
                                child: CategoryItem(
                                    title: category.name,
                                    icon: category.imageFullUrl?.path,
                                    isSelected: categoryProvider
                                            .categorySelectedIndex ==
                                        index));
                          })),
                  Expanded(
                      child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          itemCount: categoryProvider
                                  .categoryList[
                                      categoryProvider.categorySelectedIndex!]
                                  .childes!
                                  .length +
                              1,
                          itemBuilder: (context, index) {
                            late Category subCategory;
                            if (index != 0) {
                              subCategory = categoryProvider
                                  .categoryList[
                                      categoryProvider.categorySelectedIndex!]
                                  .childes![index - 1];
                            }
                            if (index == 0) {
                              return Ink(
                                color: Theme.of(context).highlightColor,
                                child: ListTile(
                                  title: Text(
                                      getTranslated('all_products', context)!,
                                      style: textRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  trailing: const Icon(Icons.navigate_next),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                CategoryProductScreen(
                                                  category: categoryProvider
                                                          .categoryList[
                                                      categoryProvider
                                                          .categorySelectedIndex!],
                                                )));
                                  },
                                ),
                              );
                            } else if (subCategory.childes!.isNotEmpty) {
                              return Ink(
                                  color: Theme.of(context).highlightColor,
                                  child: Theme(
                                      data:
                                          Provider.of<ThemeController>(context)
                                                  .darkTheme
                                              ? ThemeData.dark()
                                              : ThemeData.light(),
                                      child: ExpansionTile(
                                          key: Key(
                                              '${Provider.of<CategoryController>(context).categorySelectedIndex}$index'),
                                          title: Text(subCategory.name!,
                                              style: textRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color,
                                                  fontSize: Dimensions
                                                      .fontSizeDefault),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                          children: _getSubSubCategories(
                                              context, subCategory))));
                            } else {
                              return Ink(
                                color: Theme.of(context).highlightColor,
                                child: ListTile(
                                  title: Text(subCategory.name!,
                                      style: textRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  trailing: Icon(Icons.navigate_next,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                CategoryProductScreen(
                                                    category: subCategory)));
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  )),
                ])
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)));
        },
      ),
    );
  }

  List<Widget> _getSubSubCategories(
      BuildContext context, Category subCategory) {
    List<Widget> subSubCategories = [];
    subSubCategories.add(Container(
      color: ColorResources.getIconBg(context),
      margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeExtraSmall),
      child: ListTile(
        title: Row(children: [
          Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                  color: ColorResources.getPrimary(context),
                  shape: BoxShape.circle)),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Flexible(
              child: Text(getTranslated('all_products', context)!,
                  style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: ColorResources.getTextTitle(context),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis)),
        ]),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      CategoryProductScreen(category: subCategory)));
        },
      ),
    ));
    for (int index = 0; index < subCategory.childes!.length; index++) {
      subSubCategories.add(Container(
        color: ColorResources.getIconBg(context),
        margin: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraSmall),
        child: ListTile(
          title: Row(children: [
            Container(
                height: 7,
                width: 7,
                decoration: BoxDecoration(
                    color: ColorResources.getPrimary(context),
                    shape: BoxShape.circle)),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Flexible(
              child: Text(subCategory.childes![index].name!,
                  style: textRegular.copyWith(
                    color: ColorResources.getTextTitle(context),
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
          ]),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CategoryProductScreen(
                        category: subCategory.childes![index])));
          },
        ),
      ));
    }
    return subSubCategories;
  }
}

class CategoryItem extends StatelessWidget {
  final String? title;
  final String? icon;
  final bool isSelected;
  const CategoryItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall, horizontal: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? ColorResources.getPrimary(context) : null),
      child: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: isSelected
                          ? Theme.of(context).highlightColor
                          : Theme.of(context).hintColor),
                  borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomImageWidget(fit: BoxFit.cover, image: '$icon'))),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeExtraSmall),
            child: Text(title!,
                maxLines: 2,
                style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: isSelected
                      ? Theme.of(context).highlightColor
                      : ColorResources.getTextTitle(context),
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center),
          ),
        ]),
      ),
    );
  }
}
