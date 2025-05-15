import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import '../domain/models/blog_model.dart';
import '../domain/repositories/blog_repo.dart';

class BlogController extends ChangeNotifier {
  final BlogRepository blogService;
  BlogController({required this.blogService});

  List<BlogModel> _blogs = [];

  List<BlogModel> get blogs => _blogs;

  Future<void> getBlogs(bool reload) async {
    if (_blogs.isEmpty || reload) {
      ApiResponse apiResponse = await blogService.getList();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _blogs.clear();
        apiResponse.response!.data
            .forEach((category) => _blogs.add(BlogModel.fromJson(category)));
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();
    }
  }

  void emptyBlog() {
    _blogs = [];
    notifyListeners();
  }
}
