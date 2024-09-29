import 'package:ig/features/domain/reposotories/firebase_repository.dart';

import '../../../entities/user/user_entity.dart';

class GetSingleUserUsecase{
  final FirebaseRepository repository;
  GetSingleUserUsecase({required this.repository});
  Stream<List<UserEntity>> call(String uid){
    return repository.getSingleUser(uid);
  }
}