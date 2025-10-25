import 'package:locket_beta/model/user_model.dart';

abstract class MessengerState {}

class MessengerInitialState extends MessengerState {

}

class MessengerLoadingState extends MessengerState {

}

class MessengerLoadedState extends MessengerState {
  List<UserModel> messengers;

  MessengerLoadedState({
    required this.messengers
  });

  MessengerLoadedState copyWith({
    List<UserModel>? messengers,
  }) {
    return MessengerLoadedState(messengers: messengers ?? this.messengers);
  }
}

class MessengerErrorState extends MessengerState {

}