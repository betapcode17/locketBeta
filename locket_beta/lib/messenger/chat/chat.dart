import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/messenger/chat/cubit/chat_cubit.dart';
import 'package:locket_beta/messenger/chat/cubit/chat_state.dart';
import 'package:locket_beta/model/message_model.dart';
import 'package:locket_beta/model/user_model.dart';

class ChatPage extends StatefulWidget {
  UserModel currentFriend;
  ChatPage({Key? key, required this.currentFriend}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  late UserModel currentFriend;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    currentFriend = widget.currentFriend;
  }

  void _send(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
      context.read<ChatCubit>().addMessage(text, true, DateTime.now());
      _controller.clear();
    // scroll to bottom after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildMessage(MessageModel m) {
    final bubbleColor = m.isMe ? const Color(0xFF0B84FF) : const Color(0xFF2A2A2E);
    final textColor = m.isMe ? Colors.white : Colors.white70;
    final align = m.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(m.isMe ? 16 : 4),
      bottomRight: Radius.circular(m.isMe ? 4 : 16),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Row(
            mainAxisAlignment: m.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!m.isMe)
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF3A3A3E),
                  child: const Icon(Icons.person, size: 18, color: Colors.white70),
                ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: borderRadius,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Text(m.text, style: TextStyle(color: textColor)),
                ),
              ),
              const SizedBox(width: 8),
              if (m.isMe)
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF0A74D1),
                  child: const Icon(Icons.person, size: 18, color: Colors.white),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(left: m.isMe ? 0 : 48, right: m.isMe ? 48 : 0),
            child: Text(
              _formatTime(m.time),
              style: const TextStyle(fontSize: 11, color: Colors.white54),
            ),
          )
        ],
      ),
    );
  }

  static String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
    Widget build(BuildContext context) {
    return BlocProvider<ChatCubit>(
      create: (context) => ChatCubit(currentFriend: currentFriend)..loadData(),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1F1B24),
          iconTheme: const IconThemeData(color: Colors.white),
          leadingWidth: 70,
          leading: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFF2C2C2E),
                child: Image.asset(currentFriend.imagePath, height: 35,),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text(currentFriend.username, style: const TextStyle(fontSize: 16, color: Colors.white)),
                  const Text('Active now', style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if(state is ChatLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if(state is ChatLoadedState) {
              List<MessageModel> messages = state.messengers;
              return SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: messages.length,
                        itemBuilder: (context, index) => _buildMessage(messages[index]),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF121212),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
                      ),
                      child: Row(
                        children: [
                          IconButton(icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.white70), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.attach_file, color: Colors.white70), onPressed: () {}),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: Colors.white),
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _send(context),
                              decoration: InputDecoration(
                                hintText: 'Nhắn tin...',
                                hintStyle: const TextStyle(color: Colors.white54),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                filled: true,
                                fillColor: const Color(0xFF2A2A2E),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: const Color(0xFF0B84FF),
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: () => _send(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}