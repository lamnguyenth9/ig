import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/comment/create_comment_usercase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/comment/delete_comment_usercase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/comment/like_comment_usercase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/comment/read_comment_usercase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/comment/update_comment_usecase.dart';

import '../../../../domain/entities/comment/comment_entity.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CreateCommentUsercase createCommentUsercase;
  final DeleteCommentUsercase deleteCommentUsercase;
  final LikeCommentUsercase likeCommentUsercase;
  final ReadCommentUsercase readCommentUsercase;
  final UpdateCommentUsecase updateCommentUsecase;
  CommentCubit(
      {required this.createCommentUsercase,
      required this.deleteCommentUsercase,
      required this.likeCommentUsercase,
      required this.readCommentUsercase,
      required this.updateCommentUsecase})
      : super(CommentInitial());
  Future<void> getComments({required String postId}) async {
    emit(CommentLoading());
    try {
      final streamResponse = await readCommentUsercase.call(postId);
      streamResponse.listen((comments) {
        emit(CommentLoad(comments: comments));
      });
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (e) {
      emit(CommentFailure());
    }
  }
  Future<void> updateComment({required CommentEntity comment})async{
    emit(CommentLoading());
    try{
       await updateCommentUsecase.call(comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (e) {
      emit(CommentFailure());
    }
  }
  Future<void> likeComment({required CommentEntity comment})async{
    emit(CommentLoading());
    try{
       await likeCommentUsercase.call(comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (e) {
      emit(CommentFailure());
    }
  }
  Future<void> createComment({required CommentEntity comment})async{
    emit(CommentLoading());
    try{
      await createCommentUsercase.call(comment);
    }on SocketException catch(_){
      emit(CommentFailure());
    }catch(e){
      emit(CommentFailure());
    }
  }
  Future<void> deleteComment({required CommentEntity comment})async{
    emit(CommentLoading());
    try{
        await deleteCommentUsercase.call(comment);
    }on SocketException catch(_){
      emit(CommentFailure());
    }catch(e){
      emit(CommentFailure());
    }
  }
}
