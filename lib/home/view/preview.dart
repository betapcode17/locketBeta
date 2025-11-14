import 'dart:io';
import 'package:flutter/material.dart';
import 'package:locket_beta/settings/global.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({
    super.key,
    required this.imagePath,
    required this.onSend,
  });
  final String imagePath;
  final void Function() onSend;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1d1b20),
      body: Column(
        children: [
          // Top bar: gửi & download
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon:
                      const Icon(Icons.download, color: Colors.white, size: 30),
                  onPressed: () {
                    // TODO: xử lý download
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 30),
                  onPressed: () {
                    images.add(widget.imagePath);
                    widget.onSend();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          // Phần preview ảnh trong khung (không full màn hình)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.contain, // Thay fit để ảnh vừa khung, không cover
                ),
              ),
            ),
          ),
          // Dưới cùng: dot indicators
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == 0 ? Colors.white : Colors.white54,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          // Cuối màn hình: 3 icon
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 50),
                  onPressed: () {
                    images.add(widget.imagePath);
                    widget.onSend();
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz,
                      color: Colors.white, size: 40),
                  onPressed: () {
                    // TODO: xử lý thêm
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
