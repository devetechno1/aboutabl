import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

import '../../../product/screens/category_product_screen.dart';
import '../../domain/models/category_model.dart';
import '../category_shimmer_widget.dart';
import 'sub_category_widget.dart';

class SubCategoryListWidget extends StatelessWidget {
  const SubCategoryListWidget({super.key, required this.categoryModel});
  final CategoryModel categoryModel;

  @override
  Widget build(BuildContext context) {
    if (categoryModel.showSubInHome != true) return SizedBox.fromSize();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraExtraSmall,
          ),
          child: TitleRowWidget(title: categoryModel.name),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        categoryModel.childes?.isNotEmpty == true
            ? SizedBox(
                height: Provider.of<LocalizationController>(
                  context,
                  listen: false,
                ).isLtr
                    ? MediaQuery.of(context).size.width / 3.7
                    : MediaQuery.of(context).size.width / 3,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryModel.childes!.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryProductScreen(
                              category: categoryModel.childes![index],
                            ),
                          ),
                        );
                      },
                      child: SubCategoryWidget(
                        subCategory: categoryModel.childes![index],
                        index: index,
                        length: categoryModel.childes!.length,
                      ),
                    );
                  },
                ),
              )
            : const CategoryShimmerWidget(),
      ],
    );
  }
}
