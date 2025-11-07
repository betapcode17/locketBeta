import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/friends/view/friends_screen.dart';
import 'package:locket_beta/home/cubit/camera_cubit.dart';
import 'package:locket_beta/home/cubit/camera_state.dart';
import 'package:locket_beta/messenger/list_messenger/messenger.dart';
import 'package:locket_beta/history/view/history.dart';
import 'package:locket_beta/home/view/preview.dart';
import 'package:locket_beta/settings/sizes.dart';
import 'package:locket_beta/profile/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController = ScrollController();
  bool clicked = false;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, double maxZoomLevel) {
    _currentScale = (_baseScale * details.scale).clamp(
      1.0,
      maxZoomLevel,
    );
    context.read<CameraCubit>().setZoomLevel(_currentScale);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
// Khi vào trang, khởi tạo camera Cubit
    Future.microtask(() async {
      final cameras = await availableCameras();
      context.read<CameraCubit>().initializeCamera(cameras);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff1d1b20),
        appBar: AppBar(
          backgroundColor: const Color(0xff1b20),
          elevation: 0,
          centerTitle: true,
          leadingWidth: 64,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color.fromARGB(255, 124, 122, 128),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                },
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FriendsScreen()),
              );
            },
            child: Container(
              alignment: Alignment.center,
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color.fromARGB(255, 124, 122, 128),
              ),
              child: const Text(
                "Add Friends",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                width: 57,
                height: 57,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(255, 124, 122, 128),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Messenger()));
                  },
                  icon: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<CameraCubit, CameraState>(
          builder: (context, state) {
            if (state is CameraInitial || state is CameraLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            }
            if (state is CameraError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (state is CameraReady) {
              return SizedBox(
                  child: PageView.builder(
                itemCount: 2,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  if (index == 0) {
// Trang camera
                    return GestureDetector(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 50, horizontal: 5),
                        width: Sizes.width(context),
                        height: Sizes.height(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onDoubleTap: () async {
                                final cameras = await availableCameras();
                                context
                                    .read<CameraCubit>()
                                    .toggleCamera(cameras);
                              },
                              onScaleUpdate: (d) =>
                                  _onScaleUpdate(d, state.maxZoomLevel),
                              onScaleStart: _onScaleStart,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                width: Sizes.width(context),
                                height: Sizes.width(context),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Stack(
                                    children: [
                                      CameraPreview(state.controller),
                                      Positioned(
                                        bottom: 10,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 10,
                                                sigmaY: 10,
                                              ),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Center(
                                                  child: Text(
                                                    _currentScale
                                                        .toStringAsFixed(1),
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      context.read<CameraCubit>().toggleFlash();
                                    },
                                    icon: Icon(
                                      state.flashOn
                                          ? Icons.flash_on_outlined
                                          : Icons.flash_off_outlined,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: Color(0xffFCB600),
                                        width: 5,
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          clicked = !clicked;
                                        });
                                        state.controller
                                            .takePicture()
                                            .then((value) {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) => ImagePreview(
                                              imagePath: value.path,
                                              onSend: () {
                                                setState(() {});
                                              },
                                            ),
                                          );
                                        });
                                      },
                                      onLongPress: () {
                                        setState(() {
                                          clicked = !clicked;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        onEnd: () {
                                          setState(() {
                                            clicked = false;
                                          });
                                        },
                                        duration: Duration(milliseconds: 100),
                                        width: clicked ? 50 : 80,
                                        height: clicked ? 50 : 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: clicked
                                              ? Color(0xff47444c)
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final cameras = await availableCameras();
                                      context
                                          .read<CameraCubit>()
                                          .toggleCamera(cameras);
                                    },
                                    icon: const Icon(
                                      Icons.flip_camera_ios_outlined,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              width: 125,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Color(0xff47444c),
                                        ),
                                        child: Icon(
                                          Icons.photo,
                                          color: Colors.white.withOpacity(0.5),
                                          size: 30,
                                        ),
                                      ),
                                      Text(
                                        "History",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_up_rounded,
                                    color: Colors.white.withOpacity(0.5),
                                    size: 40,
                                    weight: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return HistoryScreen();
                  }
                },
              ));
            }
            return const SizedBox.shrink();
          },
        ));
  }
}
