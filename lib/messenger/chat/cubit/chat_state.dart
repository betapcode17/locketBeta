import 'package:locket_beta/model/message_model.dart';

abstract class ChatState {}

class ChatInitialState extends ChatState {

}

class ChatLoadingState extends ChatState {

}

class ChatLoadedState extends ChatState {
  List<MessageModel> messengers;

  ChatLoadedState({
    required this.messengers
  });

  ChatLoadedState copyWith({
    List<MessageModel>? messengers,
  }) {
    return ChatLoadedState(messengers: messengers ?? this.messengers);
  }
}

class ChatErrorState extends ChatState {

}