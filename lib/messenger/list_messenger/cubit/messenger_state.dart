import 'package:locket_beta/model/user_model.dart';

abstract class MessengerState {}

class MessengerInitialState extends MessengerState {

}

class MessengerLoadingState extends MessengerState {

}

class MessengerLoadedState extends MessengerState {
  List<UserModel> messengers;
  List<UserModel> messengerFilter;

  MessengerLoadedState({
    required this.messengers,
    required this.messengerFilter
  });

  MessengerLoadedState copyWith({
    List<UserModel>? messengers,
    List<UserModel>? messengerFilter
  }) {
    return MessengerLoadedState(messengers: messengers ?? this.messengers, messengerFilter: messengerFilter ?? this.messengerFilter);
  }
}

class MessengerErrorState extends MessengerState {

}