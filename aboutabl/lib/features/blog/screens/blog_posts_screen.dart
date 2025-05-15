import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../di_container.dart';
import '../../../localization/language_constrants.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../product/screens/category_product_screen.dart';
import '../controllers/blog_posts_controller.dart';
import '../domain/models/blog_model.dart';
import '../widgets/post_widget.dart';
import 'posts_search_screen.dart';

class BlogPostsScreen extends StatelessWidget {
  const BlogPostsScreen({super.key, required this.blog});
  final BlogModel blog;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => sl<BlogPostsController>(),
      builder: (_, c) => _BlogPostsScreen(blog: blog),
    );
  }
}

class _BlogPostsScreen extends StatefulWidget {
  final BlogModel blog;
  const _BlogPostsScreen({
    required this.blog,
  });

  @override
  State<_BlogPostsScreen> createState() => _BlogPostsScreenState();
}

class _BlogPostsScreenState extends State<_BlogPostsScreen> {
  late final BlogPostsController c =
      Provider.of<BlogPostsController>(context, listen: false);

  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    c.initBlog(widget.blog);

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
      appBar: CustomAppBar(
        title: widget.blog.name,
        showResetIcon: true,
        reset: IconButton(
          onPressed: () => showSearch<String>(
            context: context,
            delegate: PostsSearchDelegate(context, blog: widget.blog),
          ),
          icon: const Icon(Icons.search),
        ),
      ),
      body: Consumer<BlogPostsController>(
        builder: (context, controller, child) {
          if (AppConstants.isSubCategoriesGrid) {
            return dataInGrid(controller);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              if (controller.subBlogs?.isNotEmpty == true)
                categoryRow(controller),

              // Products
              Expanded(child: getPosts(controller)),
            ],
          );
        },
      ),
    );
  }

  Widget getPosts(BlogPostsController controller) {
    if (controller.postsList.isNotEmpty) {
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
                itemCount: controller.postsList.length,
                shrinkWrap: true,
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
  }

  Widget dataInGrid(BlogPostsController controller) {
    final List<BlogModel> childes = controller.blog.childes ?? [];
    if (childes.isEmpty) {
      return getPosts(controller);
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
          final BlogModel cat = childes[index];
          return CatWidget(
            isSelected: controller.currentIndex == index,
            name: cat.name ?? '',
            fullURL: '${cat.imageFullUrl?.path}',
            index: index,
            length: childes.length,
            onTap: () => controller.getPostsBlogsAndSub(
              context,
              index,
              blog: cat,
            ),
          );
        },
      ),
    );
  }

  Container categoryRow(BlogPostsController controller) {
    final List<BlogModel> subCategories = controller.subBlogs ?? [];
    return Container(
      height: 54 + MediaQuery.sizeOf(context).width / 6.5,
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
            child: OutlinedButton(
              onPressed: controller.pressViewAll,
              style: OutlinedButton.styleFrom(
                backgroundColor: controller.currentIndex == -1
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : null,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                fixedSize: Size.square(MediaQuery.sizeOf(context).width / 6),
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
            ),
          ),
          ...List.generate(
            subCategories.length,
            (index) {
              final BlogModel subCat = subCategories[index];
              return CatWidget(
                isSelected: controller.currentIndex == index,
                name: subCat.name ?? '',
                fullURL: '${subCat.imageFullUrl?.path}',
                index: index,
                length: subCategories.length,
                onTap: () => controller.getPostsBlogsAndSub(
                  context,
                  index,
                  blog: subCat,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
