import 'package:locket_beta/model/message_model.dart';

abstract class MessageState {}

class MessageInitialState extends MessageState {

}

class MessageLoadingState extends MessageState {

}

class MessageLoadedState extends MessageState {
  List<MessageModel> messengers;

  MessageLoadedState({
    required this.messengers
  });

  MessageLoadedState copyWith({
    List<MessageModel>? messengers,
  }) {
    return MessageLoadedState(messengers: messengers ?? this.messengers);
  }
}

class MessageErrorState extends MessageState {

}