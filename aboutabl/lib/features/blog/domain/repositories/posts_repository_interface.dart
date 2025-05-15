import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class PostsRepositoryInterface<T> extends RepositoryInterface {
  Future<dynamic> getBlogPostsList(
    String blogId,
    String offset, [
    String query = '',
  ]);
}
