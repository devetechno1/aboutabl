import '../repositories/posts_repository_interface.dart';
import 'posts_service_interface.dart';

class PostsService implements PostsServiceInterface {
  PostsRepositoryInterface postsRepositoryInterface;

  PostsService({required this.postsRepositoryInterface});

  @override
  Future getBlogPostsList(
    String blogId,
    String offset, [
    String query = '',
  ]) async {
    return await postsRepositoryInterface.getBlogPostsList(
      blogId,
      offset,
      query,
    );
  }
}
