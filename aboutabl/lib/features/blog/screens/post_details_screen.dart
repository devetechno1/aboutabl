import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/custom_app_bar_widget.dart';
import '../../../di_container.dart';
import '../../../localization/language_constrants.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../product_details/widgets/product_specification_widget.dart';
import '../controllers/post_details_controller.dart';
import '../domain/models/post_model.dart';
import '../widgets/post_image_widget.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key, required this.post});
  final PostModel post;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          PostDetailsController(productDetailsServiceInterface: sl.get()),
      child: _PostDetailsScreen(post: post),
    );
  }
}

class _PostDetailsScreen extends StatelessWidget {
  const _PostDetailsScreen({required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('post_details', context)),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            PostImageWidget(postModel: post),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.homePagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    post.name,
                    style: titleHeader.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  ProductSpecificationWidget(
                    productSpecification: post.details,
                    title: getTranslated('description', context) ?? '',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
