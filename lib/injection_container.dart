import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:ig/features/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:ig/features/data/data_source/remote_data_source/remote_data_source_impl.dart';
import 'package:ig/features/data/repositories/firebase_repository_impl.dart';
import 'package:ig/features/domain/reposotories/firebase_repository.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/comment/create_comment_usercase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/comment/delete_comment_usercase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/comment/like_comment_usercase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/comment/read_comment_usercase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/comment/update_comment_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/post/create_post_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/post/delete_post_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/post/get_post_single_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/post/like_post_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/post/read_post_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/post/update_post_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/replay/create_replay_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/replay/delete_replay_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/replay/like_replay_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/replay/read_replay_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/upload_image_to_storage.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/create_user_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/get_current_uid_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/get_single_user_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/get_user_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/is_sign_in_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/sign_in_user_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/sign_out_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/sign_up_user_usecase.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/update_user_usecase.dart';
import 'package:ig/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:ig/features/presentation/cubit/comment/cubit/comment_cubit.dart';
import 'package:ig/features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:ig/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:ig/features/presentation/cubit/post/single_post/cubit/get_post_single_cubit.dart';
import 'package:ig/features/presentation/cubit/user/cubit/replay/cubit/replay_cubit.dart';
import 'package:ig/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:ig/features/presentation/cubit/user/get_single_user/cubit/get_single_user_cubit.dart';

import 'features/domain/usecases/firebase_usecase/replay/update_replay_usecase.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //CUBIT
  sl.registerFactory<AuthCubit>(() => AuthCubit(
      getCurrentUidUsecase: sl.call(),
      isSignInUsecase: sl.call(),
      signOutUsecase: sl.call()));
  sl.registerFactory<UserCubit>(
      () => UserCubit(updateUserUsecase: sl.call(), getUserUsecase: sl.call()));
  sl.registerFactory<CredentialCubit>(() => CredentialCubit(
      signInUserUsecase: sl.call(), signUpUserUsecase: sl.call()));
  sl.registerFactory<GetSingleUserCubit>(
      () => GetSingleUserCubit(getSingleUserUsecase: sl.call()));
  sl.registerFactory<PostCubit>(() => PostCubit(
      createPostUsecase: sl.call(),
      readPostUsecase: sl.call(),
      likePostUsecase: sl.call(),
      updatePostUsecase: sl.call(),
      deletePostUsecase: sl.call()));
  sl.registerFactory<CommentCubit>(()=>CommentCubit(
    createCommentUsercase: sl.call(), 
    deleteCommentUsercase: sl.call(), 
    likeCommentUsercase: sl.call(), readCommentUsercase: sl.call(), 
    updateCommentUsecase: sl.call()));
  sl.registerFactory<GetPostSingleCubit>(()=>GetPostSingleCubit(getPostSingleUsecase: sl.call()));
  sl.registerFactory<ReplayCubit>(()=>ReplayCubit(
    likeReplayUsecase: sl.call(), 
    deleteReplayUsecase: sl.call(), 
    createReplayUsecase: sl.call(), 
    updateReplayUsecase: sl.call(), 
    readReplayUsecase: sl.call()));
  //USECASE
  sl.registerLazySingleton<CreateUserUsecase>(
      () => CreateUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUidUsecase>(
      () => GetCurrentUidUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetSingleUserUsecase>(
      () => GetSingleUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetUserUsecase>(
      () => GetUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<IsSignInUsecase>(
      () => IsSignInUsecase(repository: sl.call()));
  sl.registerLazySingleton<SignInUserUsecase>(
      () => SignInUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<SignOutUsecase>(
      () => SignOutUsecase(repository: sl.call()));
  sl.registerLazySingleton<SignUpUserUsecase>(
      () => SignUpUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<UpdateUserUsecase>(
      () => UpdateUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<UploadImageToStorage>(
      () => UploadImageToStorage(repository: sl.call()));
  //PostUsecase
  sl.registerLazySingleton<CreatePostUsecase>(()=>CreatePostUsecase(repository: sl.call()));
  sl.registerLazySingleton<DeletePostUsecase>(()=>DeletePostUsecase(repository: sl.call()));
  sl.registerLazySingleton<LikePostUsecase>(()=>LikePostUsecase(repository: sl.call()));
  sl.registerLazySingleton<ReadPostUsecase>(()=>ReadPostUsecase(repository: sl.call()));
  sl.registerLazySingleton<UpdatePostUsecase>(()=>UpdatePostUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetPostSingleUsecase>(()=>GetPostSingleUsecase(repository: sl.call()));
  //CommentUsecase
  sl.registerLazySingleton<CreateCommentUsercase>(()=>CreateCommentUsercase(repository: sl.call()));
  sl.registerLazySingleton<DeleteCommentUsercase>(()=>DeleteCommentUsercase(repository: sl.call()));
  sl.registerLazySingleton<LikeCommentUsercase>(()=>LikeCommentUsercase(repository: sl.call()));
  sl.registerLazySingleton<ReadCommentUsercase>(()=>ReadCommentUsercase(repository: sl.call()));
  sl.registerLazySingleton<UpdateCommentUsecase>(()=>UpdateCommentUsecase(repository: sl.call()));
  //ReplayUsecase
  sl.registerLazySingleton<CreateReplayUsecase>(()=>CreateReplayUsecase(repository: sl.call()));
  sl.registerLazySingleton<DeleteReplayUsecase>(()=>DeleteReplayUsecase(repository: sl.call()));
  sl.registerLazySingleton<LikeReplayUsecase>(()=>LikeReplayUsecase(repository: sl.call()));
  sl.registerLazySingleton<UpdateReplayUsecase>(()=>UpdateReplayUsecase(repository: sl.call()));
  sl.registerLazySingleton<ReadReplayUsecase>(()=>ReadReplayUsecase(repository: sl.call()));
  //REPOSITORY
  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));
  //DATA SOURCE
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() => RemoteDataSourceImpl(
      firebaseAuth: sl.call(),
      firebaseFirestore: sl.call(),
      firebaseStorage: sl.call()));
  //External
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  sl.registerLazySingleton(() => firestore);
  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => storage);
}
