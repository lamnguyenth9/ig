import 'package:ig/features/domain/entities/user/user_entity.dart';
import 'package:ig/features/domain/reposotories/firebase_repository.dart';

class GetUserUsecase{
  final FirebaseRepository repository;
  GetUserUsecase({required this.repository});
  Stream<List<UserEntity>> call(UserEntity user){
    return repository.getUsers(user);
  }
}