import 'package:flutter/material.dart';
import 'package:locket_beta/settings/global.dart'; // Nếu bạn dùng biến/hàm global trong dự án
import 'history_grid.dart'; // import file chứa HistoryGrid

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool clicked = false;
  bool showGrid = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: showGrid ? Colors.black : const Color(0xff1d1b20),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: showGrid ? _buildGridView() : _buildMainView(),
      ),
    );
  }

  Widget _buildMainView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 5),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  _buildSenderInfo(),
                  const SizedBox(height: 20),
                  _buildTextFieldWithIcons(),
                  const SizedBox(height: 20),
                  _buildBottomButtons(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() => const HistoryGrid();

  Widget _buildHeader() {
    return SizedBox(
      height: 450,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
              bottom: Radius.circular(30),
            ),
            child: Image.asset(
              "assets/images/cat_img.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.6],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff2a2a2a),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                "I swear this wasn't planned 😂😂",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSenderInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xff47444c),
          child: Text(
            'J',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jessica',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '36m',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextFieldWithIcons() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xff47444c),
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: _messageController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Send message...',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              isDense: true,
            ),
            onSubmitted: (_) => _messageController.clear(),
          ),
        ),
        Positioned(
          right: 10,
          top: 0,
          bottom: 0,
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.local_fire_department,
                    color: Colors.orange, size: 20),
                padding: EdgeInsets.zero,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
                padding: EdgeInsets.zero,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.sentiment_very_satisfied,
                    color: Colors.yellow, size: 20),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => setState(() => showGrid = !showGrid),
          icon: const Icon(Icons.more_horiz, color: Colors.white, size: 28),
        ),
        GestureDetector(
          onTap: () => setState(() => clicked = !clicked),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: clicked ? 50 : 70,
            height: clicked ? 50 : 70,
            decoration: BoxDecoration(
              color: clicked ? Colors.grey[800] : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xffFCB600),
                width: 5,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.keyboard_arrow_up,
              color: Colors.white, size: 28),
        ),
      ],
    );
  }
}
