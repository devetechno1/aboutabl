import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/screens/category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/widgets/category_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

import '../../product/screens/category_product_screen.dart';
import '../domain/models/category_model.dart';
import 'category_shimmer_widget.dart';

class CategoryListWidget extends StatelessWidget {
  final bool isHomePage;
  const CategoryListWidget({super.key, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {
        return Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeExtraExtraSmall),
            child: TitleRowWidget(
              title: getTranslated('CATEGORY', context),
              onTap: () {
                if (categoryProvider.categoryList.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CategoryScreen(),
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          categoryProvider.categoryList.isNotEmpty
              ? categoryProvider.isCategoriesGrid
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categoryProvider.categoryList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        return categoryBuilder(
                          categoryProvider.categoryList,
                          index,
                        );
                      },
                    )
                  : SizedBox(
                      height: Provider.of<LocalizationController>(context,
                                  listen: false)
                              .isLtr
                          ? MediaQuery.of(context).size.width / 3.7
                          : MediaQuery.of(context).size.width / 3,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryProvider.categoryList.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return categoryBuilder(
                            categoryProvider.categoryList,
                            index,
                          );
                        },
                      ),
                    )
              : const CategoryShimmerWidget(),
        ]);
      },
    );
  }

  Widget categoryBuilder(List<CategoryModel> categories, int index) {
    final CategoryModel category = categories[index];
    return Builder(builder: (context) {
      return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryProductScreen(category: category),
            ),
          );
        },
        child: CategoryWidget(
          category: category,
          index: index,
          length: categories.length,
        ),
      );
    });
  }
}
