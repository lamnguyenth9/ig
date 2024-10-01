import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ig/features/domain/entities/posts/post_entity.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/post/get_post_single_usecase.dart';

part 'get_post_single_state.dart';

class GetPostSingleCubit extends Cubit<GetPostSingleState> {
  final GetPostSingleUsecase getPostSingleUsecase;
  GetPostSingleCubit({required this.getPostSingleUsecase}) : super(GetPostSingleInitial());
  Future<void> getSinglePost({required String postId})async{
    emit(GetPostSingleLoaing());
    try{
       final streamResponse= await getPostSingleUsecase.call(postId);
       streamResponse.listen((post){
        emit(GetPostSingleLoaded(post: post.first));
       });
    }on SocketException catch(_){
      emit(GetPostSingleFailure());
    }catch(e){
      emit(GetPostSingleFailure());
    }
  }
}
