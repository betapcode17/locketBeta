import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraReady extends CameraState {
  final CameraController controller;
  final bool frontCamera;
  final bool flash;
  final double zoom;

  const CameraReady({
    required this.controller,
    this.frontCamera = false,
    this.flash = false,
    this.zoom = 1.0,
  });

  CameraReady copyWith({
    CameraController? controller,
    bool? frontCamera,
    bool? flash,
    double? zoom,
  }) {
    return CameraReady(
      controller: controller ?? this.controller,
      frontCamera: frontCamera ?? this.frontCamera,
      flash: flash ?? this.flash,
      zoom: zoom ?? this.zoom,
    );
  }

  @override
  List<Object?> get props => [controller, frontCamera, flash, zoom];
}

class CameraError extends CameraState {
  final String message;
  const CameraError(this.message);

  @override
  List<Object?> get props => [message];
}
