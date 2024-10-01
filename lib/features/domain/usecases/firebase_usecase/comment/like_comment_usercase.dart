import 'package:ig/features/domain/entities/comment/comment_entity.dart';
import 'package:ig/features/domain/reposotories/firebase_repository.dart';

class LikeCommentUsercase {
  final FirebaseRepository repository;

  LikeCommentUsercase({required this.repository});
  Future<void> call(CommentEntity comment)async{
    return await repository.likeComment(comment);
  }
}