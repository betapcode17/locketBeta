import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/messenger/list_messenger/cubit/messenger_state.dart';
import 'package:locket_beta/model/user_model.dart';

class MessengerCubit extends Cubit<MessengerState>{
  MessengerCubit() :super(MessengerInitialState());

  void loadData() {
    emit(MessengerLoadingState());
    try {
      List<UserModel> friends = [
        UserModel(username: "Le Van A"),
        UserModel(username: "Le Van B"),
        UserModel(username: "Nguyen Thi A")
      ];

      emit(MessengerLoadedState(messengers: friends, messengerFilter: friends));
    }
    catch(e) {
      emit(MessengerErrorState());
    }
  }

    void filter(String query) {
    final current = state;
    if (current is MessengerLoadedState) {
      final q = query.trim().toLowerCase();
      final filtered = q.isEmpty
          ? current.messengers
          : current.messengers.where((m) => m.username.toLowerCase().contains(q)).toList();

      emit(MessengerLoadedState(messengers: current.messengers, messengerFilter: filtered));
    }
  }
}