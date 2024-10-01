import 'package:ig/features/domain/entities/comment/comment_entity.dart';
import 'package:ig/features/domain/reposotories/firebase_repository.dart';

class ReadCommentUsercase{
  final FirebaseRepository repository;

  ReadCommentUsercase({required this.repository});
  Stream<List<CommentEntity>> call(String postId){
    return repository.readComments(postId);
  }
}