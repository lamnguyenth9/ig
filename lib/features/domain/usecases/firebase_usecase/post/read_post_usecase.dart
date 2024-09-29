import 'package:ig/features/domain/reposotories/firebase_repository.dart';

import '../../../entities/posts/post_entity.dart';

class ReadPostUsecase{
  final FirebaseRepository repository;

  ReadPostUsecase({required this.repository});
  Stream<List<PostEntity>> call(PostEntity post){
    return repository.readPosts(post);
  }
}