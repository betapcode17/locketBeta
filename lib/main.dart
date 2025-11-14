import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:locket_beta/messenger/chat/chat.dart';
import 'home/view/home.dart';
import 'home/cubit/camera_cubit.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint("❌ Lỗi camera: $e");
  }

  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CameraCubit(cameras: cameras)..initializeCamera(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChatPage(currentUserId: "690effbcb90f29f230c54995"),
      ),
    );
  }
}
