abstract class PostsServiceInterface {
  Future<dynamic> getBlogPostsList(
    String blogId,
    String offset, [
    String query = '',
  ]);
}
