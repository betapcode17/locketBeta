import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

abstract class CameraState extends Equatable {
  final bool flashOn;
  const CameraState({this.flashOn = false});
  @override
  List<Object?> get props => [flashOn];
}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraReady extends CameraState {
  final CameraController controller;
  final double maxZoomLevel;
  const CameraReady(
    this.controller,
    this.maxZoomLevel, {
    super.flashOn,
  });
  CameraReady copyWith({
    bool? flashOn,
    double? maxZoomLevel,
  }) {
    return CameraReady(
      controller,
      maxZoomLevel ?? this.maxZoomLevel,
      flashOn: flashOn ?? this.flashOn,
    );
  }

  @override
  List<Object?> get props => [controller, flashOn, maxZoomLevel];
}

class CameraError extends CameraState {
  final String message;
  const CameraError(this.message);
  @override
  List<Object?> get props => [message];
}
