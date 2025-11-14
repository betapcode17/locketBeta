import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final double currentScale;
  final double baseScale;
  final bool clicked;

  const HomeState({
    this.currentScale = 1.0,
    this.baseScale = 1.0,
    this.clicked = false,
  });

  HomeState copyWith({
    double? currentScale,
    double? baseScale,
    bool? clicked,
  }) {
    return HomeState(
      currentScale: currentScale ?? this.currentScale,
      baseScale: baseScale ?? this.baseScale,
      clicked: clicked ?? this.clicked,
    );
  }

  @override
  List<Object?> get props => [currentScale, baseScale, clicked];
}
