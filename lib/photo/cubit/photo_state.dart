import 'package:equatable/equatable.dart';
import 'package:locket_beta/model/photo_model.dart';

abstract class PhotoState extends Equatable {
  @override
  List<Object> get props => [];

  String? get errorMessage => null;
}

class PhotoInitial extends PhotoState {}

// Create
class PhotoUploading extends PhotoState {}

class PhotoUpLoaded extends PhotoState {
  final PhotoModel photo;
  PhotoUpLoaded(this.photo);
  @override
  List<Object> get props => [photo];
}

class PhotoError extends PhotoState {
  final String errorMessage;
  PhotoError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];

  String get message => errorMessage;
}

//Read
class PhotoLoading extends PhotoState {}

class PhotoLoaded extends PhotoState {
  final List<PhotoModel> photos;
  PhotoLoaded(this.photos);
  @override
  List<Object> get props => [photos];
}

// Update
class PhotoUpdating extends PhotoState {}

class PhotoUpdated extends PhotoState {
  final PhotoModel photo;
  PhotoUpdated(this.photo);
  @override
  List<Object> get props => [photo];
}

//Delete
class PhotoDeleting extends PhotoState {}

class PhotoDeleted extends PhotoState {
  final String photoId;
  PhotoDeleted(this.photoId);
  @override
  List<Object> get props => [photoId];
}
