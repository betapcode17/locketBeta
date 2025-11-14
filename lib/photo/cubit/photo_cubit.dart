import 'package:bloc/bloc.dart';
import 'package:locket_beta/model/photo_model.dart';
import 'package:locket_beta/photo/cubit/photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  PhotoCubit() : super(PhotoInitial());

  final List<PhotoModel> _photos = [];

  // CREATE
  Future<void> uploadPhoto(String imageUrl, String userId) async {
    emit(PhotoUploading());
    try {
      final photo = PhotoModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          imageUrl: imageUrl,
          timestamp: DateTime.now());
      _photos.add(photo);
      emit(PhotoUpLoaded(photo));
    } catch (e) {
      emit(PhotoError("Không thể tải ảnh lên: $e"));
    }
  }

  // READ ALL
  Future<void> fetchPhotos(String userId) async {
    emit(PhotoLoading());
    try {
      final userPhotos = _photos.where((p) => p.userId == userId).toList();
      emit(PhotoLoaded(userPhotos));
    } catch (e) {
      emit(PhotoError("Không thể lấy ảnh: $e"));
    }
  }

  // UPDATE
  Future<void> updatePhoto(PhotoModel updatedPhoto) async {
    emit(PhotoUpdating());
    try {
      final index = _photos.indexWhere((p) => p.id == updatedPhoto.id);
      if (index != -1) {
        _photos[index] = updatedPhoto;
        emit(PhotoUpdated(updatedPhoto));
      } else {
        emit(PhotoError("Không tìm thấy ảnh để cập nhật"));
      }
    } catch (e) {
      emit(PhotoError("Không thể cập nhật ảnh: $e"));
    }
  }

  // DELETE
  Future<void> deletePhoto(String photoId) async {
    emit(PhotoDeleting());
    try {
      _photos.removeWhere((p) => p.id == photoId);
      emit(PhotoDeleted(photoId));
    } catch (e) {
      emit(PhotoError("Không thể xóa ảnh: $e"));
    }
  }
}
