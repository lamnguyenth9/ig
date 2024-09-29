import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/post/create_post_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/post/delete_post_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/post/like_post_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/post/read_post_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/post/update_post_usecase.dart';

import '../../../../domain/entities/posts/post_entity.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final CreatePostUsecase createPostUsecase;
  final ReadPostUsecase readPostUsecase;
  final LikePostUsecase likePostUsecase;
  final UpdatePostUsecase updatePostUsecase;
  final DeletePostUsecase deletePostUsecase;
  PostCubit(
      {required this.createPostUsecase,
      required this.readPostUsecase,
      required this.likePostUsecase,
      required this.updatePostUsecase,
      required this.deletePostUsecase})
      : super(PostInitial());

  Future<void> getPosts(PostEntity post)async{
    emit(PostLoading());
    try{
       final streamResponse = readPostUsecase.call(post);
       streamResponse.listen((posts){
        emit(PostLoaded(posts: posts));
       });
    } on SocketException catch(_){
      emit(PostFailure());
    } catch(e){
      emit(PostFailure());
    }
  }
  Future<void> updatePost({required PostEntity post})async{
    emit(PostLoading());
    try{
       await updatePostUsecase.call(post);
    } on SocketException catch(_){
      emit(PostFailure());
    } catch(e){
      emit(PostFailure());
    }
  }
  Future<void> likePost({required PostEntity post})async{
    emit(PostLoading());
    try{
     await likePostUsecase.call(post);
    } on SocketException catch(_){

    }catch(e){
      emit(PostFailure());
    }
  }
  Future<void> createPost({required PostEntity post})async{
    emit(PostLoading());
    try{
     await createPostUsecase.call(post);
    } on SocketException catch(_){

    }catch(e){
      emit(PostFailure());
    }
  }
  Future<void> deletePost({required PostEntity post})async{
    emit(PostLoading());
    try{
     await deletePostUsecase.call(post);
    } on SocketException catch(_){

    }catch(e){
      emit(PostFailure());
    }
  }
}
