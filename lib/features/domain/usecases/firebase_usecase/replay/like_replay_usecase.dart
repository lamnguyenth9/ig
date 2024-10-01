import 'package:ig/features/domain/entities/reply/replay_entity.dart';
import 'package:ig/features/domain/reposotories/firebase_repository.dart';

class LikeReplayUsecase{
  final FirebaseRepository repository;

  LikeReplayUsecase({required this.repository});
  Future<void> call(ReplayEntity replay)async{
    return await repository.likeReplay(replay);
  }
}