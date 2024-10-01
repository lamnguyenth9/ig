import 'package:ig/features/domain/entities/comment/comment_entity.dart';
import 'package:ig/features/domain/reposotories/firebase_repository.dart';

class CreateCommentUsercase {
  final FirebaseRepository repository;

  CreateCommentUsercase({required this.repository});
  Future<void> call(CommentEntity comment)async{
    return await repository.createComment(comment);
  }
}