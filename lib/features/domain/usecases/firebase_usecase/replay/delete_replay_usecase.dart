import 'package:ig/features/domain/entities/reply/replay_entity.dart';
import 'package:ig/features/domain/reposotories/firebase_repository.dart';

class DeleteReplayUsecase{
  final FirebaseRepository repository;

  DeleteReplayUsecase({required this.repository});
  Future<void> call(ReplayEntity replay)async{
    return await repository.deleteReplay(replay);
  }
}