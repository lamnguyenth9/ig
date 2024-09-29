part of 'credential_cubit.dart';

sealed class CredentialState extends Equatable {
  const CredentialState();
}

final class CredentialInitial extends CredentialState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class CredentialSuccess extends CredentialState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class CredentialLoading extends CredentialState {
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}
final class CredentialFailure extends CredentialState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
