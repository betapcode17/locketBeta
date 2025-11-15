import 'package:dio/dio.dart';
import 'package:locket_beta/model/friend_model.dart';

class FriendApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:5000'));

  Future<List<Friend>> getFriends(String userId) async {
    try {
      final response = await _dio.get('/api/friends/$userId');
      return (response.data as List)
          .map((json) => Friend.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load friends: $e');
    }
  }

  Future<Friend> addFriend(Friend friend) async {
    try {
      final response = await _dio.post('/api/friends', data: friend.toJson());
      return Friend.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add friend: $e');
    }
  }

  Future<void> removeFriend(String friendId) async {
    try {
      await _dio.delete('/api/friends/$friendId');
    } catch (e) {
      throw Exception('Failed to remove friend: $e');
    }
  }
}
