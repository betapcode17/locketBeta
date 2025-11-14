import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/messenger/message/cubit/message_state.dart';
import 'package:locket_beta/model/chat_model.dart';
import 'package:locket_beta/model/message_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageCubit extends Cubit<MessageState> {
  UserShort  currentFriend;
  String chatId;
  String currentUserId;
  WebSocketChannel? _channel;
  MessageCubit({
    required this.currentFriend,
    required this.chatId,
    required this. currentUserId,
  }):super(MessageInitialState()) {
    _connectWebSocket();
  }

    void _connectWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:8000?userId=$currentUserId'),
    );
    // Lắng nghe messages từ server
    _channel!.stream.listen((message) {
      print("Da stream voi server");
      // Parse message từ JSON
      final data = jsonDecode(message);
      if (data is! Map<String, dynamic>) return;
      if(data['event'] == 'message') {
        final payload = data['message'];
        final newMessage = MessageModel.fromJson(payload, currentUserId: currentUserId);
      
        // Emit state mới (thêm message vào list hiện tại)
        if (state is MessageLoadedState) {
          final current = (state as MessageLoadedState).messengers;
          emit(MessageLoadedState(messengers: [...current, newMessage]));
        }
      }
      
    }, onError: (error) {
      emit(MessageErrorState());
    });
  }

  void sendMessage(String content) {
    if (_channel != null) {
      final message = {
        'chatId': chatId,
        'senderId': currentUserId,
        'content': content,
        'type': 'text',
      };
      // final MessageModel newMessage = MessageModel(senderId: currentUserId, content: content, createdAt: DateTime.now(), isMe: true);
      // if (state is MessageLoadedState) {
      //   final current = (state as MessageLoadedState).messengers;
      //   emit(MessageLoadedState(messengers: [...current, newMessage]));
      // }
      _channel!.sink.add(jsonEncode(message)); // gửi qua WS
    }
  }

    Future<List<MessageModel>> loadMessage() async {
      Dio dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:8000"));
    try {
      final response = await dio.get('/api/messages/$chatId');

      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> items = [];
        //tại sao lại cần đoạn này
        if (data == null) {
          items = [];
        } else if (data is List) {
          items = data;
        } else if (data is Map) {
          if (data['messages'] is List) {
            items = List.from(data['messages']);
          } else if (data['data'] is List) {
            items = List.from(data['data']);
          } else {
            items = [data];
          }
        } else {
          try {
            items = List.from(data);
          } catch (_) {
            items = [];
          }
        }

        return items
            .where((e) => e != null)
            .map((e) => MessageModel.fromJson(Map<String, dynamic>.from(e as Map), currentUserId: currentUserId))
            .toList();
      }
    } catch (e) {
      print("Loi: "+ e.toString());
    }
    return [];
  }

  Future<void> loadData() async {
    emit(MessageLoadingState());
    try {
      final messages = await loadMessage();
      emit(MessageLoadedState(messengers: messages));
    } catch (e) {
      emit(MessageErrorState());
    }
  }

}