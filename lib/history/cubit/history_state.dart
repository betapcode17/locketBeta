import 'package:equatable/equatable.dart';
import 'package:locket_beta/model/photo_model.dart';

abstract class HistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<PhotoModel> photos;
  HistoryLoaded(this.photos);
  @override
  List<Object> get props => [photos];
}

class HistoryError extends HistoryState {
  final String errorMessage;
  HistoryError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
