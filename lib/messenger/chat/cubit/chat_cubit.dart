import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/messenger/chat/cubit/chat_state.dart';
import 'package:locket_beta/model/chat_model.dart';

class ChatCubit extends Cubit<ChatState>{
  String currentUserId;
  ChatCubit({
      required this.currentUserId,
  }) :super(ChatInitialState());

  void loadData() async {
    Dio dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:8000"));
    emit(ChatLoadingState());
    try {
      // List<UserModel> friends = [
      //   UserModel(username: "Le Van A"),
      //   UserModel(username: "Le Van B"),
      //   UserModel(username: "Nguyen Thi A")
      // ];
      final response = await dio.get("/api/chats/$currentUserId");
      if(response.statusCode == 200) {
        final data = response.data;
        
        // Server trả về { chats: [...] }
        final List<dynamic> chatsJson = data['chats'] ?? [];
        
        // Parse danh sách chat từ JSON
        List<ChatModel> chats = chatsJson
            .map((json) {
              print('Raw chat JSON: $json'); // <-- thêm log này
              return ChatModel.fromJson(json as Map<String, dynamic>);
            })
            .toList();
        
        emit(ChatLoadedState(chats: chats, chatFilter: chats));
      } else {
        emit(ChatErrorState());
      }
    }
    catch(e) {
      emit(ChatErrorState());
      print(e.toString());
    }
  }

    void filter(String query) {
    final current = state;
    if (current is ChatLoadedState) {
      final q = query.trim().toLowerCase();
      final filtered = q.isEmpty
          ? current.chats
          : current.chats.where((m) {
            return m.members.any((member) => member.username?.toLowerCase().contains(q) ?? false);
          }).toList();

      emit(ChatLoadedState(chats: current.chats, chatFilter: filtered));
    }
  }
}