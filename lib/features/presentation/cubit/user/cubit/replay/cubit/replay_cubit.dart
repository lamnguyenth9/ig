import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/replay/create_replay_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/replay/delete_replay_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/replay/like_replay_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/replay/read_replay_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/replay/update_replay_usecase.dart';

import '../../../../../../domain/entities/reply/replay_entity.dart';

part 'replay_state.dart';

class ReplayCubit extends Cubit<ReplayState> {
  final LikeReplayUsecase likeReplayUsecase;
  final DeleteReplayUsecase deleteReplayUsecase;
  final CreateReplayUsecase createReplayUsecase;
  final UpdateReplayUsecase updateReplayUsecase;
  final ReadReplayUsecase readReplayUsecase;
  ReplayCubit(
      {required this.likeReplayUsecase,
      required this.deleteReplayUsecase,
      required this.createReplayUsecase,
      required this.updateReplayUsecase,
      required this.readReplayUsecase})
      : super(ReplayInitial());
    Future<void> getReplay({required ReplayEntity replay})async{
      emit(ReplayLoading());
      try{
        final streamResponse=await readReplayUsecase.call(replay);
      streamResponse.listen((replays){
        emit(ReplayLoaded(replays: replays));
      });
      }on SocketException catch(_){
        emit(ReplayFailure());
      }catch(e){
        emit(ReplayFailure());
      }
    }
    Future<void> likeReplay({required ReplayEntity replay})async{
      emit(ReplayLoading());
      try{
         await likeReplayUsecase.call(replay);
         
      }on SocketException catch(_){
         emit(ReplayFailure());
      }catch(e){
        emit(ReplayFailure());
      }
    }
    Future<void> deleteReplay({required ReplayEntity replay})async{
      emit(ReplayLoading());
      try{
         await deleteReplayUsecase.call(replay);
         
      }on SocketException catch(_){
         emit(ReplayFailure());
      }catch(e){
        emit(ReplayFailure());
      }
    }
    Future<void> updateReplay({required ReplayEntity replay})async{
      emit(ReplayLoading());
      try{
         await updateReplayUsecase.call(replay);
         
      }on SocketException catch(_){
         emit(ReplayFailure());
      }catch(e){
        emit(ReplayFailure());
      }
    }
    Future<void> createReplay({required ReplayEntity replay})async{
      emit(ReplayLoading());
      try{
         await createReplayUsecase.call(replay);
         
      }on SocketException catch(_){
         emit(ReplayFailure());
      }catch(e){
        emit(ReplayFailure());
      }
    }
}
