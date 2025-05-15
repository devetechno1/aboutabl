import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/product_shimmer_widget.dart';
import '../controllers/posts_search_controller.dart';
import '../domain/models/blog_model.dart';
import '../widgets/post_widget.dart';

class PostsSearchDelegate extends SearchDelegate<String> {
  final BlogModel blog;
  final BuildContext context;
  PostsSearchDelegate(this.context, {required this.blog})
      : super(
          searchFieldStyle: textMedium.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ) {
    c.emptyPosts();
    scrollController.addListener(controllerListener);
  }

  late final PostsSearchController c =
      Provider.of<PostsSearchController>(context, listen: false);

  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(controllerListener);
    scrollController.dispose();
  }

  void controllerListener() {
    if (scrollController.offset >=
        scrollController.position.maxScrollExtent - 10) {
      c.getCategoryProductMore(query, "${blog.id}");
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          c.getPostsList("${blog.id}", query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 18,
        color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(.75),
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    c.getPostsList("${blog.id}", query);
    return Consumer<PostsSearchController>(
      builder: (context, controller, child) {
        if (controller.postsList.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () => controller.refreshProducts(query, "${blog.id}"),
            child: Column(
              children: [
                Expanded(
                  child: MasonryGridView.count(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: Dimensions.paddingSizeSmall,
                    ),
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount:
                        MediaQuery.sizeOf(context).width > 480 ? 3 : 2,
                    itemCount: controller.postsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PostWidget(postModel: controller.postsList[index]);
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
                  isEnabled: controller.postsList.isEmpty,
                )
              : const NoInternetOrDataScreenWidget(
                  isNoInternet: false,
                  icon: Images.noProduct,
                  message: 'no_posts_found',
                );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => const SizedBox.shrink();
}
