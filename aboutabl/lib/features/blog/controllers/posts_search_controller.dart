import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

import '../domain/models/post_model.dart';
import '../domain/service/posts_service_interface.dart';

class PostsSearchController extends ChangeNotifier {
  final PostsServiceInterface postsServiceInterface;
  PostsSearchController({required this.postsServiceInterface});

  int _currentOffset = 1;

  //* --------------category----------------------------------------------------------------------

  final List<PostModel> _postsList = [];
  List<PostModel> get postsList => _postsList;

  bool _hasData = true;
  bool get hasData => _hasData;

  int _totalProductLength = 0;
  int get totalProductLength => _totalProductLength;

  bool isLoadingPagination = false;

  Future<void> getPostsList(String blogId, String query) async {
    _hasData = true;
    _currentOffset = 1;
    _postsList.clear();

    ApiResponse apiResponse = await postsServiceInterface.getBlogPostsList(
      blogId,
      "$_currentOffset",
      query,
    );
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

  Future<void> getCategoryProductMore(String query, String blogId) async {
    if (_totalProductLength <= _postsList.length || isLoadingPagination) return;
    isLoadingPagination = true;
    notifyListeners();

    ApiResponse apiResponse = await postsServiceInterface.getBlogPostsList(
      blogId,
      "${++_currentOffset}",
      query,
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

  Future<void> refreshProducts(String query, String blogId) {
    return getPostsList(blogId, query);
  }

  void emptyPosts() {
    _hasData = false;
    _postsList.clear();
    notifyListeners();
  }
}
