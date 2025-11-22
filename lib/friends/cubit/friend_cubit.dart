// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:locket_beta/friends/cubit/friend_state.dart';
// import 'package:locket_beta/model/friend_model.dart';
// import 'package:locket_beta/utils/local_storage.dart';
// import 'package:locket_beta/utils/friend_api.dart';

// class FriendCubit extends Cubit<FriendState> {
//   FriendCubit() : super(FriendInitial());

//   final List<Friend> _friends = [
//     Friend(
//       id: '1',
//       name: 'Jessica',
//       profileImage: 'assets/images/cat_img.jpg',
//       isActive: true,
//       lastSeen: DateTime.now().subtract(const Duration(minutes: 2)),
//     ),
//     Friend(
//       id: '2',
//       name: 'Chemistry Teacher',
//       profileImage: 'assets/images/cat_img.jpg',
//       isActive: true,
//       lastSeen: DateTime.now().subtract(const Duration(minutes: 15)),
//     ),
//     Friend(
//       id: '3',
//       name: 'Sango',
//       profileImage: 'assets/images/cat_img.jpg',
//       isActive: true,
//       lastSeen: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
//     ),
//     Friend(
//       id: '4',
//       name: 'Hishinuma',
//       profileImage: 'assets/images/cat_img.jpg',
//       isActive: true,
//       lastSeen: DateTime.now()
//           .subtract(const Duration(days: 5, hours: 5, minutes: 2)),
//     ),
//   ];

//   Future<void> loadFriends() async {
//     try {
//       emit(FriendLoading());
//       final userId = await LocalStorage.getUserId();
//       if (userId == null) throw Exception("User not logged in");

//       final friends = await FriendApi().getFriends(userId);
//       emit(FriendLoaded(friends));
//     } catch (e) {
//       emit(FriendError(e.toString()));
//     }
//   }

//   // Future<void> loadFriends() async {
//   //   try {
//   //     emit(FriendLoading());
//   //     await Future.delayed(
//   //         const Duration(seconds: 1)); // Simulate network delay
//   //     emit(FriendLoaded(_friends));
//   //   } catch (e) {
//   //     emit(FriendError(e.toString()));
//   //   }
//   // }

//   Future<void> addFriend(Friend friend) async {
//     try {
//       emit(FriendLoading());
//       _friends.add(friend);
//       emit(FriendLoaded(_friends));
//     } catch (e) {
//       emit(FriendError(e.toString()));
//     }
//   }

//   Future<void> removeFriend(String friendId) async {
//     try {
//       emit(FriendLoading());
//       _friends.removeWhere((friend) => friend.id == friendId);
//       emit(FriendLoaded(_friends));
//     } catch (e) {
//       emit(FriendError(e.toString()));
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/friends/cubit/friend_state.dart';
import 'package:locket_beta/model/friend_model.dart';
import 'package:locket_beta/model/friend_request_model.dart';
import 'package:locket_beta/utils/local_storage.dart';
import 'package:locket_beta/utils/friend_api.dart';

class FriendCubit extends Cubit<FriendState> {
  FriendCubit() : super(FriendInitial());

  final FriendApi _api = FriendApi();

  List<Friend> friends = [];
  List<FriendRequest> requests = [];
  List<Friend> recommendations = [];

  Future<void> loadFriends() async {
    try {
      final userId = await LocalStorage.getUserId();
      if (userId == null) throw Exception("User not logged in");
      friends = await _api.getFriends(userId);
      emit(FriendLoaded(friends));
    } catch (e) {
      emit(FriendError(e.toString()));
    }
  }

  Future<void> loadFriendRequests() async {
    try {
      final userId = await LocalStorage.getUserId();
      if (userId == null) throw Exception("User not logged in");
      requests = await _api.getFriendRequests(userId);
      emit(FriendRequestLoaded(requests));
    } catch (e) {
      emit(FriendError(e.toString()));
    }
  }

  Future<void> loadRecommendations() async {
    try {
      final userId = await LocalStorage.getUserId();
      if (userId == null) throw Exception("User not logged in");
      recommendations = await _api.getRecommendations(userId);
      emit(RecommendationLoaded(recommendations));
    } catch (e) {
      emit(FriendError(e.toString()));
    }
  }

  Future<void> addFriend(Friend friend) async {
    try {
      await _api.addFriend(friend);
      await loadFriends();
    } catch (e) {
      emit(FriendError(e.toString()));
    }
  }

  Future<void> removeFriend(String friendId) async {
    try {
      await _api.removeFriend(friendId);
      await loadFriends();
    } catch (e) {
      emit(FriendError(e.toString()));
    }
  }

  Future<void> acceptFriendRequest(String requestId) async {
    try {
      await _api.acceptFriendRequest(requestId);
      await loadFriendRequests();
      await loadFriends();
    } catch (e) {
      emit(FriendError(e.toString()));
    }
  }

  Future<void> rejectFriendRequest(String requestId) async {
    try {
      await _api.rejectFriendRequest(requestId);
      await loadFriendRequests();
    } catch (e) {
      emit(FriendError(e.toString()));
    }
  }
}
