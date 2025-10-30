import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/messenger/chat/cubit/chat_state.dart';
import 'package:locket_beta/model/message_model.dart';
import 'package:locket_beta/model/user_model.dart';

class ChatCubit extends Cubit<ChatState> {
  UserModel currentFriend;
  ChatCubit({
    required this.currentFriend
  }):super(ChatInitialState());

  void addMessage(String message, bool isMe, DateTime time) {
    if (state is ChatLoadedState) {
      final current = List<MessageModel>.from((state as ChatLoadedState).messengers);
      current.add(MessageModel(text: message, isMe: isMe, time: time));
      emit(ChatLoadedState(messengers: current));
    } else {
      // nếu chưa có dữ liệu, khởi tạo danh sách mới
      emit(ChatLoadedState(messengers: [MessageModel(text: message, isMe: isMe, time: time)]));
    }
  }

  void loadData() {
    emit(ChatLoadingState());
    try {
      List<MessageModel> messages = [
        MessageModel(text: 'Hi! How are you?', isMe: false, time: DateTime.now().subtract(const Duration(minutes: 5))),
        MessageModel(text: 'I\'m good, you?', isMe: true, time: DateTime.now().subtract(const Duration(minutes: 4))),
        MessageModel(text: 'Doing great. Are we meeting later?', isMe: false, time: DateTime.now().subtract(const Duration(minutes: 3))),
        MessageModel(text: 'Yes, 7pm works for me.', isMe: true, time: DateTime.now().subtract(const Duration(minutes: 1))),
        MessageModel(text: 'Hi! How are you?', isMe: false, time: DateTime.now().subtract(const Duration(minutes: 5))),
        MessageModel(text: 'I\'m good, you?', isMe: true, time: DateTime.now().subtract(const Duration(minutes: 4))),
        MessageModel(text: 'Doing great. Are we meeting later?', isMe: false, time: DateTime.now().subtract(const Duration(minutes: 3))),
        MessageModel(text: 'Yes, 7pm works for me.', isMe: true, time: DateTime.now().subtract(const Duration(minutes: 1))),
        MessageModel(text: 'Hi! How are you?', isMe: false, time: DateTime.now().subtract(const Duration(minutes: 5))),
        MessageModel(text: 'I\'m good, you?', isMe: true, time: DateTime.now().subtract(const Duration(minutes: 4))),
        MessageModel(text: 'Doing great. Are we meeting later?', isMe: false, time: DateTime.now().subtract(const Duration(minutes: 3))),
        MessageModel(text: 'Yes, 7pm works for me.', isMe: true, time: DateTime.now().subtract(const Duration(minutes: 1))),
        MessageModel(text: 'Hi! How are you?', isMe: false, time: DateTime.now().subtract(const Duration(minutes: 5))),
        MessageModel(text: 'I\'m good, you?', isMe: true, time: DateTime.now().subtract(const Duration(minutes: 4))),
        MessageModel(text: 'Doing great. Are we meeting later?', isMe: false, time: DateTime.now().subtract(const Duration(minutes: 3))),
        MessageModel(text: 'Yes, 7pm works for me.', isMe: true, time: DateTime.now().subtract(const Duration(minutes: 1))),
        MessageModel(text: 'Hi! How are you?', isMe: false, time: DateTime.now().subtract(const Duration(minutes: 5))),
        MessageModel(text: 'I\'m good, you?', isMe: true, time: DateTime.now().subtract(const Duration(minutes: 4))),
        MessageModel(text: 'Doing great. Are we meeting later?', isMe: false, time: DateTime.now().subtract(const Duration(minutes: 3))),
        MessageModel(text: 'Yes, 7pm works for me.', isMe: true, time: DateTime.now().subtract(const Duration(minutes: 1))),
      ];
      emit(ChatLoadedState(messengers: messages));
    }
    catch(e) {
      emit(ChatErrorState());
    }
  }
}