import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:provider/provider.dart';

import 'sub_category_list_widget.dart';

class AllSubCategoriesWidget extends StatelessWidget {
  const AllSubCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.categoryList.isEmpty) return const SizedBox();
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categoryProvider.categoryList.length,
          itemBuilder: (context, index) {
            return SubCategoryListWidget(
              categoryModel: categoryProvider.categoryList[index],
            );
          },
        );
      },
    );
  }
}
