import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/messenger/chat/chat.dart';
import 'package:locket_beta/messenger/list_messenger/cubit/messenger_cubit.dart';
import 'package:locket_beta/messenger/list_messenger/cubit/messenger_state.dart';
import 'package:locket_beta/model/user_model.dart';

class Messenger extends StatefulWidget{
  @override
  State<Messenger> createState() => _Messenger();
}

class _Messenger extends State<Messenger> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessengerCubit()..loadData(),
      child: Scaffold(
        backgroundColor: const Color(0xff1d1b20),
        appBar: AppBar(
          title: const Text(
            "Messenger",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          backgroundColor: const Color(0xff1d1b20),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      
        body: BlocBuilder<MessengerCubit, MessengerState>(
          builder: (context, state) {
            if(state is MessengerLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if(state is MessengerLoadedState) {
              List<UserModel> friends = state.messengerFilter;
              if(friends.isEmpty) {
                return const Center(
                  child: Text(
                    "Danh sách rỗng",
                    style: TextStyle(

                    ),
                  )
                );
              }
              else {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Column(
                      children: [
                        // Thanh tìm kiếm
                        TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            context.read<MessengerCubit>().filter(value);
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xff2a282c),
                            hintText: "Tìm kiếm",
                            hintStyle: TextStyle(color: Colors.grey[350]),
                            prefixIcon: const Icon(Icons.search, color: Colors.white54),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      
                        const SizedBox(height: 12),
                      
                        // List bạn bè chiếm phần còn lại
                        Expanded(
                          child: ListView.builder(
                            itemCount: friends.length,
                            // separatorBuilder: (context, index) => Divider(color: Colors.grey[800], height: 1),
                            itemBuilder: (context, index) {
                              final currentFriend = friends[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                leading: CircleAvatar(
                                  radius: 26,
                                  backgroundColor: const Color(0xff47444c),
                                  child: Image.asset(currentFriend.imagePath, height: 35,),
                                ),
                                title: Text(
                                  currentFriend.username,
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  "Online",
                                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                                ),
                                trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                                onTap: () {
                                  debugPrint('Open chat with ${currentFriend.username}');
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(currentFriend: currentFriend,)));
                      
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}