import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/messenger/message/cubit/message_cubit.dart';
import 'package:locket_beta/messenger/message/cubit/message_state.dart';
import 'package:locket_beta/model/chat_model.dart';
import 'package:locket_beta/model/message_model.dart';

class MessagePage extends StatefulWidget {
  UserShort currentFriend;
  String chatId;
  String currentUserId;
  MessagePage({Key? key, required this.currentFriend, required this.chatId, required this.currentUserId}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  late UserShort currentFriend;

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
      context.read<MessageCubit>().sendMessage(text);
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

  Widget _buildMessage(MessageModel m, BuildContext context) {
    final bubbleColor = m.isMe ? const Color(0xFF0B84FF) : const Color(0xFF2A2A2E);
    final textColor = m.isMe ? Colors.white : Colors.white70;
    final align = m.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(m.isMe ? 16 : 4),
      bottomRight: Radius.circular(m.isMe ? 4 : 16),
    );

    return GestureDetector(
      onLongPress: m.isMe ? () => _onLongPressMessage(context, m) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          crossAxisAlignment: align,
          children: [
            Row(
              mainAxisAlignment: m.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!m.isMe)
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFF3A3A3E),
                    child: Icon(Icons.person, size: 18, color: Colors.white70),
                  ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: borderRadius,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Text(m.content, style: TextStyle(color: textColor)),
                  ),
                ),
                const SizedBox(width: 8),
                if (m.isMe)
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor:  Color(0xFF0A74D1),
                    child: Icon(Icons.person, size: 18, color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(left: m.isMe ? 0 : 48, right: m.isMe ? 48 : 0),
              child: Text(
                _formatTime(m.createdAt),
                style: const TextStyle(fontSize: 11, color: Colors.white54),
              ),
            )
          ],
        ),
      ),
    );
  }

  // hàm hiển thị menu khi long press
  void _onLongPressMessage(BuildContext ctx, MessageModel m) {
    final cubit = ctx.read<MessageCubit>();
    showModalBottomSheet(
      context: ctx,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (c) {
        return BlocProvider.value(
          value: cubit,
          child: SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Xoá tin nhắn', style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    Navigator.of(c).pop(); // đóng bottom sheet
          
                    
                    final messenger = ScaffoldMessenger.of(ctx);
          
                    final confirmed = await showDialog<bool>(
                      context: ctx,
                      builder: (dCtx) => AlertDialog(
                        title: const Text('Xác nhận'),
                        content: const Text('Bạn có chắc muốn xoá tin nhắn này?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(dCtx).pop(false), child: const Text('Huỷ')),
                          TextButton(onPressed: () => Navigator.of(dCtx).pop(true), child: const Text('Xoá')),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      // gọi cubit để xóa (optimistic update)
                      try {
                        print("MessageIDdddddddddddddddddđ:" + m.id.toString());
                        cubit.deleteMessage(m.id ?? '');
                      } catch (e) {
                        // nếu cần, hiển thị lỗi ngắn
                        messenger.showSnackBar(const SnackBar(content: Text('Xoá thất bại')));
                      }
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel, color: Colors.white70),
                  title: const Text('Huỷ', style: TextStyle(color: Colors.white)),
                  onTap: () => Navigator.of(c).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
    Widget build(BuildContext context) {
    return BlocProvider<MessageCubit>(
      create: (context) => MessageCubit(currentFriend: currentFriend, 
            chatId: widget.chatId, currentUserId: widget.currentUserId)..loadData(),
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
                child: Image.asset(currentFriend.avatar  ?? "assets/images/defaultUser.png" , height: 35,),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text(currentFriend.username ?? "User", style: const TextStyle(fontSize: 16, color: Colors.white)),
                  //TODO: cần 1 API để trả về danh sách hoặc kiểm tra người dùng có đang onl không
                  const Text('Active now', style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
        body: BlocBuilder<MessageCubit, MessageState>(
          builder: (context, state) {
            if(state is MessageLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if(state is MessageLoadedState) {
              List<MessageModel> messages = state.messengers;
              return SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: messages.length,
                        itemBuilder: (context, index) => _buildMessage(messages[index], context),
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