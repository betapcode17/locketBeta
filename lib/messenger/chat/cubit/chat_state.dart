import 'package:locket_beta/model/chat_model.dart';

abstract class ChatState {}

class ChatInitialState extends ChatState {

}

class ChatLoadingState extends ChatState {

}

class ChatLoadedState extends ChatState {
  List<ChatModel> chats;
  List<ChatModel> chatFilter;

  ChatLoadedState({
    required this.chats,
    required this.chatFilter
  });

  ChatLoadedState copyWith({
    List<ChatModel>? chats,
    List<ChatModel>? chatFilter
  }) {
    return ChatLoadedState(chats: chats ?? this.chats, chatFilter: chatFilter ?? this.chatFilter);
  }
}

class ChatErrorState extends ChatState {

}