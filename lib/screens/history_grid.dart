import 'package:flutter/material.dart';
import 'package:locket_beta/screens/home.dart';

class HistoryGrid extends StatelessWidget {
  const HistoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/images/cat_img.jpg',
      'assets/images/fox.jpg',
      'assets/images/man.jpg',
      'assets/images/cat_img.jpg',
      'assets/images/fox.jpg',
      'assets/images/man.jpg',
      'assets/images/cat_img.jpg',
      'assets/images/fox.jpg',
      'assets/images/man.jpg',
      'assets/images/cat_img.jpg',
      'assets/images/fox.jpg',
      'assets/images/man.jpg',
      'assets/images/cat_img.jpg',
      'assets/images/fox.jpg',
      'assets/images/man.jpg',
      'assets/images/cat_img.jpg',
      'assets/images/fox.jpg',
      'assets/images/man.jpg',
      'assets/images/man.jpg',
      'assets/images/cat_img.jpg',
      'assets/images/fox.jpg',
      'assets/images/man.jpg',
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // --- GridView có thể cuộn ---
          SafeArea(
            child: GridView.builder(
              padding: const EdgeInsets.all(15),
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final path = images[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Error loading $path: $error');
                      return Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // --- Nút tròn nổi (không di chuyển khi scroll) ---
          Positioned(
            bottom: 40, // cách mép dưới
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Chuyển hướng sang HomeScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xffFCB600),
                      width: 5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
