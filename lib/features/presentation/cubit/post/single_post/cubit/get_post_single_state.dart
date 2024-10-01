part of 'get_post_single_cubit.dart';

sealed class GetPostSingleState extends Equatable {
  const GetPostSingleState();

  
}

final class GetPostSingleInitial extends GetPostSingleState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class GetPostSingleLoaing extends GetPostSingleState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class GetPostSingleLoaded extends GetPostSingleState {
  final PostEntity post;
  GetPostSingleLoaded({required this.post});
  @override
  // TODO: implement props
  List<Object?> get props => [post];
}

final class GetPostSingleFailure extends GetPostSingleState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
