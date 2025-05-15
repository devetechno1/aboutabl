import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';

import '../domain/models/post_model.dart';
import '../screens/post_details_screen.dart';

class PostWidget extends StatelessWidget {
  final PostModel postModel;
  const PostWidget({super.key, required this.postModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (context, a, a2) => PostDetailsScreen(post: postModel),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(9, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, boxConstraint) => ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radiusDefault),
                  topRight: Radius.circular(Dimensions.radiusDefault),
                ),
                child: CustomImageWidget(
                  image: postModel.thumbnailFullUrl.path,
                  fit: BoxFit.cover,
                  height: boxConstraint.maxWidth * 0.82,
                  width: boxConstraint.maxWidth,
                ),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: Dimensions.paddingSizeSmall),
                    child: Text(
                      postModel.name,
                      textAlign: TextAlign.center,
                      style: textMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
