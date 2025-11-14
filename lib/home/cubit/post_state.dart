import 'package:equatable/equatable.dart';
import 'package:locket_beta/model/locket_photo_model.dart';

abstract class PostState extends Equatable {
  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

// Create
class PostUploading extends PostState {}

class PostUpLoaded extends PostState {
  final LocketPhotoModel photo;
  PostUpLoaded(this.photo);
  @override
  List<Object> get props => [photo];
}

class PostError extends PostState {
  final String errorMessage;
  PostError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

//Read
class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<LocketPhotoModel> photos;
  PostLoaded(this.photos);
  @override
  List<Object> get props => [photos];
}

// Update
class PostUpdating extends PostState {}

class PostUpdated extends PostState {
  final LocketPhotoModel photo;
  PostUpdated(this.photo);
  @override
  List<Object> get props => [photo];
}

//Delete
class PostDeleting extends PostState {}

class PostDeleted extends PostState {
  final String photoId;
  PostDeleted(this.photoId);
  @override
  List<Object> get props => [photoId];
}
