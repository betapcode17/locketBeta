import 'dart:io';
import 'package:flutter/material.dart';

class ImageWithPopup extends StatelessWidget {
  final String imagePath;

  const ImageWithPopup({
    super.key,
    required this.imagePath,
  });

  Widget _buildImage() {
    // Ảnh URL
    if (imagePath.startsWith("http")) {
      return Image.network(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            Image.asset('assets/images/logo.png', fit: BoxFit.contain),
      );
    }

    // Ảnh local (file)
    if (imagePath.startsWith("/storage") || imagePath.startsWith("/data")) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            Image.asset('assets/images/logo.png', fit: BoxFit.contain),
      );
    }

    // Ảnh asset
    return Image.asset(
      imagePath,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.black.withOpacity(0.85),
                child: Center(
                  child: GestureDetector(
                    onTap: () {}, // không tắt khi bấm vào ảnh
                    child: _buildImage(),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _buildImage(),
      ),
    );
  }
}
