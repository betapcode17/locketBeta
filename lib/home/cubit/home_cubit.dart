import 'package:bloc/bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setBaseScale(double scale) {
    emit(state.copyWith(baseScale: scale));
  }

  void setCurrentScale(double scale) {
    emit(state.copyWith(currentScale: scale));
  }

  void setClicked(bool clicked) {
    emit(state.copyWith(clicked: clicked));
  }
}
