import 'package:ig/features/domain/entities/reply/replay_entity.dart';
import 'package:ig/features/domain/reposotories/firebase_repository.dart';

class UpdateReplayUsecase{
  final FirebaseRepository repository;

  UpdateReplayUsecase({required this.repository});
  Future<void> call(ReplayEntity replay)async{
    return await repository.updateReplay(replay);
  }
}