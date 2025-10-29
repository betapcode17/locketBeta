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

      emit(MessengerLoadedState(messengers: friends));
    }
    catch(e) {
      emit(MessengerErrorState());
    }
  }
}