import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/friends/cubit/friend_cubit.dart';
import 'package:locket_beta/friends/cubit/friend_state.dart';
import 'package:locket_beta/model/friend_model.dart';
import 'package:locket_beta/home/view/home.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendCubit()..loadFriends(),
      child: const FriendsView(),
    );
  }
}

class FriendsView extends StatelessWidget {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff151415),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
          child: BlocBuilder<FriendCubit, FriendState>(
            builder: (context, state) {
              if (state is FriendLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FriendLoaded) {
                return _buildBody(context, state.friends);
              } else if (state is FriendError) {
                return Center(
                    child: Text(state.message,
                        style: const TextStyle(color: Colors.white)));
              }
              return const Center(
                  child: Text('No Friends',
                      style: TextStyle(color: Colors.white)));
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Friend> friends) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Stack(
            //mainAxisAlignment: MainAxisAlignment.start,
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 4),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Friends',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '11 / 20 Friends',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 40,
          ),
          const SizedBox(height: 18),

          // Search field
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Add a new Friend',
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: const Color(0xff252425),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Social row
          const Text('Find Friend from other App',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _socialItem(
                  imageUrl: "assets/images/mess_icon.jpg", label: 'Messenger'),
              _socialItem(
                  imageUrl: "assets/images/zalo_icon.jpg", label: 'Zalo'),
              _socialItem(
                  imageUrl: "assets/images/ig_icon.jpg", label: 'Instagram'),
              _socialItem(
                  imageUrl: "assets/images/defaultUser.png", label: 'Others'),
            ],
          ),

          const SizedBox(height: 22),
          const Text('Your Friends',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ListView.separated(
            itemCount: friends.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final friend = friends[index];
              return Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xff2a2a2a),
                      backgroundImage: friend.profileImage != null
                          ? AssetImage(friend.profileImage!) as ImageProvider
                          : null,
                      child: friend.profileImage == null
                          ? Text(
                              friend.name.isNotEmpty
                                  ? friend.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(color: Colors.white))
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(friend.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(
                          friend.isActive
                              ? 'Online'
                              : 'Actived ${_formatLastSeen(friend.lastSeen)}',
                          style: TextStyle(
                              color:
                                  friend.isActive ? Colors.green : Colors.grey,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.close, color: Colors.white),
                  )
                ],
              );
            },
          ),

          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('See more ▾',
                  style: TextStyle(color: Colors.white70)),
            ),
          ),

          const SizedBox(height: 18),
          const Text('Recommendation',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _socialItem({required String imageUrl, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 9,
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${lastSeen.day}/${lastSeen.month}/${lastSeen.year}';
    }
  }
}
