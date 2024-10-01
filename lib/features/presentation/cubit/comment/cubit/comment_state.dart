part of 'comment_cubit.dart';

sealed class CommentState extends Equatable {
  const CommentState();

 
}

final class CommentInitial extends CommentState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class CommentLoading extends CommentState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class CommentLoad extends CommentState {
  final List<CommentEntity> comments;
  CommentLoad({required this.comments});
  @override
  // TODO: implement props
  List<Object?> get props => [comments];
}

final class CommentFailure extends CommentState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
