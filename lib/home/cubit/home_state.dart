import 'package:equatable/equatable.dart';
import 'package:locket_beta/model/friend_model.dart';

abstract class FriendState extends Equatable {
  const FriendState();

  @override
  List<Object> get props => [];
}

class FriendInitial extends FriendState {}

class FriendLoading extends FriendState {}

class FriendLoaded extends FriendState {
  final List<Friend> friends;

  const FriendLoaded(this.friends);

  @override
  List<Object> get props => [friends];
}

class FriendError extends FriendState {
  final String message;

  const FriendError(this.message);

  @override
  List<Object> get props => [message];
}
