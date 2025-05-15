import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/blog/domain/models/blog_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/blog/screens/blog_posts_screen.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

import '../domain/models/post_model.dart';
import '../domain/service/posts_service_interface.dart';

class BlogPostsController extends ChangeNotifier {
  final PostsServiceInterface postsServiceInterface;
  BlogPostsController({required this.postsServiceInterface});

  void initBlog(BlogModel newBlog) {
    _blog = newBlog;
    _pressedBlog = _blog;
    _subBlogs = _blog.childes;
    _currentIndex = -100;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      pressViewAll();
    });
  }

  int _currentIndex = -1;
  int _currentOffset = 1;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    _currentOffset = 1;
    notifyListeners();
  }

  void pressViewAll() {
    if (_currentIndex == -1) return;
    _pressedBlog = _blog;
    setCurrentIndex(-1);
    getBlogPostsList("${_blog.id}");
  }

  void getPostsBlogsAndSub(
    BuildContext context,
    int index, {
    required BlogModel blog,
  }) {
    if (_currentIndex == index) return;

    if (blog.childes?.isNotEmpty == true || AppConstants.isSubCategoriesGrid) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BlogPostsScreen(blog: blog)),
      );
    } else {
      _pressedBlog = blog;
      setCurrentIndex(index);
      getBlogPostsList("${_pressedBlog.id}");
    }
  }

  //* --------------category----------------------------------------------------------------------
  late BlogModel _blog;
  late BlogModel _pressedBlog;
  late List<BlogModel>? _subBlogs;
  BlogModel get blog => _blog;
  List<BlogModel>? get subBlogs => _subBlogs;

  final List<PostModel> _postsList = [];
  List<PostModel> get postsList => _postsList;

  bool _hasData = true;
  bool get hasData => _hasData;

  int _totalProductLength = 0;
  int get totalProductLength => _totalProductLength;

  bool isLoadingPagination = false;

  Future<void> getBlogPostsList(String id) async {
    _hasData = true;
    _currentOffset = 1;
    ApiResponse apiResponse =
        await postsServiceInterface.getBlogPostsList(id, "$_currentOffset");
    _postsList.clear();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (apiResponse.response!.data is Map<String, dynamic>) {
        _totalProductLength = apiResponse.response!.data["total"] ?? 0;
        apiResponse.response!.data["data"]
            .forEach((post) => _postsList.add(PostModel.fromJson(post)));
      } else {
        apiResponse.response!.data
            .forEach((post) => _postsList.add(PostModel.fromJson(post)));
        _totalProductLength = _postsList.length;
      }
      _hasData = _postsList.length > 1;
      List<PostModel> posts = [];
      posts.addAll(_postsList);
      _postsList.clear();
      _postsList.addAll(posts);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getCategoryProductMore() async {
    if (_totalProductLength <= _postsList.length || isLoadingPagination) return;
    isLoadingPagination = true;
    notifyListeners();

    ApiResponse apiResponse = await postsServiceInterface.getBlogPostsList(
      "${_pressedBlog.id}",
      "${++_currentOffset}",
    );

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _totalProductLength = apiResponse.response!.data["total"] ?? 0;
      apiResponse.response!.data["data"]
          .forEach((post) => _postsList.add(PostModel.fromJson(post)));
      List<PostModel> posts = [];
      posts.addAll(_postsList);
      _postsList.clear();
      _postsList.addAll(posts);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    isLoadingPagination = false;
    notifyListeners();
  }

  Future<void> refreshProducts() {
    return getBlogPostsList("${_pressedBlog.id}");
  }
}
