import 'package:ig/features/domain/entities/posts/post_entity.dart';
import 'package:ig/features/domain/reposotories/firebase_repository.dart';

class GetPostSingleUsecase{
  final FirebaseRepository repository;

  GetPostSingleUsecase({required this.repository});
  Stream<List<PostEntity>> call(String postId){
    return repository.readSinglePost(postId);
  }
}