import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/get_current_uid_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/is_sign_in_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/sign_out_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
 final SignOutUsecase signOutUsecase;
final  IsSignInUsecase isSignInUsecase;
final GetCurrentUidUsecase getCurrentUidUsecase;

  AuthCubit({required this.getCurrentUidUsecase,required this.isSignInUsecase,required this.signOutUsecase}) : super(AuthInitial());
 Future<void> AppStarted(BuildContext context)async{
  try{
   bool isSignIn=await isSignInUsecase.call();
   if(isSignIn==true){
    final uid=await getCurrentUidUsecase.call();
    emit(Authenticated(uid: uid));
   }else{
    emit(UnAuthenticated()); 
   }
  }catch(e){
    emit(UnAuthenticated());
  }
 }
 Future<void> loggedIn()async{
  try{
    final uid=await getCurrentUidUsecase.call();
    emit(Authenticated(uid: uid));
  }catch(e){
   emit(UnAuthenticated());
  }
 }
 Future<void> loggedOut()async{
  try{
    await signOutUsecase.call();
    emit(UnAuthenticated());
  }catch(e){
   emit(UnAuthenticated());
  }
 }
}
