import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/history/view/image_with_popup.dart';
import 'package:locket_beta/home/view/home.dart';
import 'package:locket_beta/model/photo_model.dart';
import 'package:locket_beta/photo/cubit/photo_cubit.dart';
import 'package:locket_beta/photo/cubit/photo_state.dart';

class HistoryGrid extends StatelessWidget {
  const HistoryGrid({super.key, required List<PhotoModel> photos});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoCubit()..fetchPhotos(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SafeArea(
              child: BlocBuilder<PhotoCubit, PhotoState>(
                builder: (context, state) {
                  if (state is PhotoLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.yellow),
                    );
                  }

                  if (state is PhotoError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state is PhotoLoaded) {
                    final List<PhotoModel> photos = state.photos;

                    if (photos.isEmpty) {
                      return const Center(
                        child: Text(
                          "Chưa có ảnh nào",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(15),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        return ImageWithPopup(
                          imagePath: photos[index].imageUrl,
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
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
      ),
    );
  }
}
