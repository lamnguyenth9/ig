import 'package:ig/features/domain/entities/reply/replay_entity.dart';
import 'package:ig/features/domain/reposotories/firebase_repository.dart';

class CreateReplayUsecase{
  final FirebaseRepository repository;

  CreateReplayUsecase({required this.repository});
  Future<void> call(ReplayEntity replay)async{
    return await repository.createReplay(replay);
  }
}