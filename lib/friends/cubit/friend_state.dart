import 'package:locket_beta/model/friend_model.dart';
import 'package:locket_beta/model/friend_request_model.dart';

abstract class FriendState {}

class FriendInitial extends FriendState {}

class FriendLoading extends FriendState {}

class FriendLoaded extends FriendState {
  final List<Friend> friends;
  FriendLoaded(this.friends);
}

class FriendRequestLoaded extends FriendState {
  final List<FriendRequest> requests;
  FriendRequestLoaded(this.requests);
}

class RecommendationLoaded extends FriendState {
  final List<Friend> recommendations;
  RecommendationLoaded(this.recommendations);
}

class FriendError extends FriendState {
  final String message;
  FriendError(this.message);
}
