import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ig/features/domain/entities/user/user_entity.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/get_single_user_usecase.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUsecase getSingleUserUsecase;
  GetSingleUserCubit({required this.getSingleUserUsecase}) : super(GetSingleUserInitial());
  Future<void> getUsers({required String uid})async{
    emit(GetSingleUserLoading());
    try{
     final streamResponse=getSingleUserUsecase.call(uid);
     streamResponse.listen((users){
      emit(GetSingleUserLoaded(user: users.first));
     });
    }on SocketException{
      emit(GetSingleUserFailure());
    } catch(e){
      emit(GetSingleUserFailure());
    }
  }
}
