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
      body: Stack(
        children: [
          // Ảnh full màn hình
          Positioned.fill(
            child: Image.file(
              File(widget.imagePath),
              fit: BoxFit.cover,
            ),
          ),
          // Top bar: gửi & download
          Positioned(
            top: 50,
            left: 20,
            right: 20,
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
          // Dưới cùng: dot indicators
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
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
                      )),
            ),
          ),
          // Cuối màn hình: 3 icon
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
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
