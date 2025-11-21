import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/history/cubit/history_state.dart';
import 'package:locket_beta/profile/profile.dart';
import 'package:locket_beta/model/photo_model.dart';
import 'history_grid.dart';
import "package:locket_beta/history/cubit/history_cubit.dart";

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool clicked = false;
  bool showGrid = false;
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = HistoryCubit();
        cubit.fetchPhotos(); // Trigger fetch all photos on init
        return cubit;
      },
      child: Scaffold(
        backgroundColor: showGrid ? Colors.black : const Color(0xff1d1b20),
        body: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            }
            if (state is HistoryError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.white54, size: 64),
                    const SizedBox(height: 16),
                    Text(state.errorMessage,
                        style: const TextStyle(color: Colors.white54)),
                  ],
                ),
              );
            }
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: showGrid
                  ? _buildGridView(context, state)
                  : _buildMainView(state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainView(HistoryState state) {
    if (state is! HistoryLoaded || state.photos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.photo_library_outlined,
                color: Colors.white54, size: 64),
            const SizedBox(height: 16),
            const Text('No history yet',
                style: TextStyle(color: Colors.white54)),
          ],
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: state.photos.length,
      onPageChanged: (index) => setState(() => _currentIndex = index),
      itemBuilder: (context, index) {
        final photo = state.photos[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 50),
              Expanded(
                child: _buildHeader(photo),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSenderInfo(photo),
                    const SizedBox(height: 40),
                    _buildBottomButtons(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, HistoryState state) {
    if (state is! HistoryLoaded) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }
    return HistoryGrid(
        photos: state
            .photos); // Pass photos to grid for vertical scrolling with loop
  }

  Widget _buildImage(String url) {
    final errorWidget =
        (BuildContext context, Object error, StackTrace? stackTrace) =>
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[800],
              child: const Icon(Icons.image_not_supported,
                  color: Colors.white54, size: 100),
            );

    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: errorWidget,
      );
    } else {
      return Image.file(
        File(url),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: errorWidget,
      );
    }
  }

  Widget _buildHeader(PhotoModel photo) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          child: _buildImage(photo.imageUrl),
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
            child: Text(
              (photo.caption?.isNotEmpty ?? false)
                  ? photo.caption!
                  : 'No caption',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSenderInfo(PhotoModel photo) {
    final userInitial =
        photo.userId.isNotEmpty ? photo.userId[0].toUpperCase() : '?';
    final diff = DateTime.now().difference(photo.timestamp);
    String timeAgo;
    if (diff.inDays > 0) {
      timeAgo = '${diff.inDays}d';
    } else if (diff.inHours > 0) {
      timeAgo = '${diff.inHours}h';
    } else if (diff.inMinutes > 0) {
      timeAgo = '${diff.inMinutes}m';
    } else {
      timeAgo = 'now';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xff47444c),
          child: Text(
            userInitial,
            style: const TextStyle(
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
            Text(
              photo.userId,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              timeAgo,
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

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            final goingToMain = showGrid;
            setState(() => showGrid = !showGrid);
            if (goingToMain) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _pageController.jumpToPage(0);
              });
            }
          },
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
          onPressed: () => _pageController.jumpToPage(0),
          icon: const Icon(Icons.keyboard_arrow_up,
              color: Colors.white, size: 28),
        ),
      ],
    );
  }
}
