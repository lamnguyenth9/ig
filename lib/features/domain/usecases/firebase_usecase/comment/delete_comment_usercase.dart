import 'package:ig/features/domain/entities/comment/comment_entity.dart';
import 'package:ig/features/domain/reposotories/firebase_repository.dart';

class DeleteCommentUsercase{
  final FirebaseRepository repository;

  DeleteCommentUsercase({required this.repository});
  Future<void> call(CommentEntity comment)async{
    return await repository.deleteComment(comment);
  }
}