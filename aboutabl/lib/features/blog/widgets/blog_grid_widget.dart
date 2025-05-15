import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

import '../controllers/blog_controller.dart';
import '../domain/models/blog_model.dart';
import '../screens/blog_posts_screen.dart';
import 'blog_shimmer_widget.dart';
import 'blog_widget.dart';

class BlogGridWidget extends StatelessWidget {
  const BlogGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BlogController>(
      builder: (context, blogProvider, child) {
        if (blogProvider.blogs.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () async => await blogProvider.getBlogs(true),
            child: GridView.builder(
              padding: const EdgeInsets.all(Dimensions.homePagePadding),
              itemCount: blogProvider.blogs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.sizeOf(context).width > 480 ? 4 : 3,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                return blogBuilder(
                  blogProvider.blogs,
                  index,
                );
              },
            ),
          );
        } else {
          return const BlogShimmerWidget();
        }
      },
    );
  }

  Widget blogBuilder(List<BlogModel> blogs, int index) {
    final BlogModel blog = blogs[index];
    return Builder(
      builder: (context) {
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlogPostsScreen(blog: blog),
              ),
            );
          },
          child: BlogWidget(
            blog: blog,
            index: index,
            length: blogs.length,
          ),
        );
      },
    );
  }
}
