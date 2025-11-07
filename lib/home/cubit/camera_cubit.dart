import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:locket_beta/home/cubit/camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraController? controller;
  bool isFront = false;
  double maxZoomLevel = 1.0;
  CameraCubit() : super(CameraInitial());
  Future<void> initializeCamera(List<CameraDescription> cameras) async {
    try {
      emit(CameraLoading());
      controller = CameraController(cameras[0], ResolutionPreset.medium);
      await controller!.initialize();
      try {
        maxZoomLevel = await controller!.getMaxZoomLevel();
      } on CameraException catch (e) {
        if (e.code == 'zoomLevelNotSupported') {
          maxZoomLevel = 1.0;
        } else {
          rethrow;
        }
      } catch (e) {
        rethrow;
      }
      emit(CameraReady(controller!, maxZoomLevel));
    } catch (e) {
      emit(CameraError("Không thể khởi tạo camera: $e"));
    }
  }

  Future<void> toggleCamera(List<CameraDescription> cameras) async {
    try {
      emit(CameraLoading());
      isFront = !isFront;
      controller = CameraController(
        cameras[isFront ? 1 : 0],
        ResolutionPreset.medium,
      );
      await controller!.initialize();
      try {
        maxZoomLevel = await controller!.getMaxZoomLevel();
      } on CameraException catch (e) {
        if (e.code == 'zoomLevelNotSupported') {
          maxZoomLevel = 1.0;
        } else {
          rethrow;
        }
      } catch (e) {
        rethrow;
      }
      emit(CameraReady(controller!, maxZoomLevel));
    } catch (e) {
      emit(CameraError("Không thể chuyển camera: $e"));
    }
  }

  Future<void> toggleFlash() async {
    if (controller == null) return;
    final newMode = state.flashOn ? FlashMode.off : FlashMode.always;
    try {
      await controller!.setFlashMode(newMode);
    } on CameraException catch (e) {
// Ignore if flash not supported
      if (e.code != 'flashModeNotSupported') {
        rethrow;
      }
    }
    emit((state as CameraReady).copyWith(flashOn: !state.flashOn));
  }

  Future<void> setZoomLevel(double zoom) async {
    if (controller == null) return;
    try {
      await controller!.setZoomLevel(zoom);
    } on CameraException catch (e) {
      if (e.code == 'zoomLevelNotSupported') {
        return;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> close() {
    controller?.dispose();
    return super.close();
  }
}
