import 'package:ig/features/domain/entities/reply/replay_entity.dart';
import 'package:ig/features/domain/reposotories/firebase_repository.dart';

class ReadReplayUsecase{
  final FirebaseRepository repository;

  ReadReplayUsecase({required this.repository});
  Stream<List<ReplayEntity>> call(ReplayEntity replay){
    return repository.readReplays(replay);
  }
}