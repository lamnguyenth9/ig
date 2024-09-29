import 'package:ig/features/domain/entities/posts/post_entity.dart';
import 'package:ig/features/domain/reposotories/firebase_repository.dart';

class UpdatePostUsecase{
  final FirebaseRepository repository;

  UpdatePostUsecase({required this.repository});
  Future<void> call(PostEntity post)async{
    return await repository.updatePost(post);
  }
}