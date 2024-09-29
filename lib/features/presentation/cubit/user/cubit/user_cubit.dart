import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/get_current_uid_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/get_user_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/update_user_usecase.dart';

import '../../../../domain/entities/user/user_entity.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUserUsecase updateUserUsecase;
  final GetUserUsecase getUserUsecase;
  UserCubit({required this.updateUserUsecase,required this.getUserUsecase}) : super(UserInitial());
  Future<void> getUsers({required UserEntity user})async{
    emit(UserLoading());
    try{
     final streamResponse=getUserUsecase.call(user);
     streamResponse.listen((users){
      emit(UserLoaded(user: users));
     });
    }on SocketException{
      emit(UserFailure());
    } catch(e){
      emit(UserFailure());
    }
  }
  Future<void>  updateUser({required UserEntity user} )async{
    emit(UserLoading());
    try{
      await updateUserUsecase.call(user);
      
    }on SocketException{
      emit(UserFailure());
    } catch(e){
      emit(UserFailure());
    }
  }
}
