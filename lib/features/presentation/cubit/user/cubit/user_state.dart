part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();
}

final class UserInitial extends UserState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class UserLoading extends UserState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class UserLoaded extends UserState {
  final List<UserEntity> user;
  UserLoaded({required this.user});
  @override
  // TODO: implement props
  List<Object?> get props =>[user];
}
final class UserFailure extends UserState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
