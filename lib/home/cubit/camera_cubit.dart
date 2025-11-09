import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  final List<CameraDescription> cameras;

  CameraCubit({required this.cameras}) : super(CameraInitial());

  Future<void> initializeCamera() async {
    if (cameras.isEmpty) {
      emit(CameraError("Không có camera nào khả dụng"));
      return;
    }

    try {
      emit(CameraLoading());
      final controller = CameraController(
        cameras[0],
        ResolutionPreset.low,
        enableAudio: false,
      );
      await controller.initialize();
      emit(CameraReady(controller: controller));
    } catch (e) {
      emit(CameraError("Không thể khởi tạo camera: $e"));
    }
  }

  Future<void> toggleCamera() async {
    if (state is! CameraReady) return;
    final currentState = state as CameraReady;
    try {
      final newIndex = currentState.frontCamera ? 0 : 1;
      if (newIndex >= cameras.length) return;

      final controller = CameraController(
        cameras[newIndex],
        ResolutionPreset.ultraHigh,
        enableAudio: false,
      );
      await controller.initialize();
      emit(currentState.copyWith(
        controller: controller,
        frontCamera: !currentState.frontCamera,
      ));
    } catch (e) {
      emit(CameraError("Không thể chuyển camera: $e"));
    }
  }

  Future<void> toggleFlash() async {
    if (state is! CameraReady) return;
    final currentState = state as CameraReady;
    try {
      final newFlash = !currentState.flash;
      await currentState.controller
          .setFlashMode(newFlash ? FlashMode.always : FlashMode.off);
      emit(currentState.copyWith(flash: newFlash));
    } catch (e) {
      // Flash không được hỗ trợ
    }
  }

  Future<void> setZoom(double zoom) async {
    if (state is! CameraReady) return;
    final currentState = state as CameraReady;
    try {
      await currentState.controller.setZoomLevel(zoom);
      emit(currentState.copyWith(zoom: zoom));
    } catch (e) {
      // Zoom không được hỗ trợ
    }
  }

  Future<void> takePicture(Function(String) onPictureTaken) async {
    if (state is! CameraReady) return;
    final currentState = state as CameraReady;
    try {
      final file = await currentState.controller.takePicture();
      onPictureTaken(file.path);
    } catch (e) {
      // Lỗi chụp ảnh
    }
  }

  @override
  Future<void> close() {
    if (state is CameraReady) {
      (state as CameraReady).controller.dispose();
    }
    return super.close();
  }
}
