import 'package:bloc/bloc.dart';
import 'package:locket_beta/model/locket_photo_model.dart';
import 'package:locket_beta/home/cubit/post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  final List<LocketPhotoModel> _photos = [];

  // CREATE
  Future<void> uploadPhoto(String imageUrl, String userId) async {
    emit(PostUploading());
    try {
      final photo = LocketPhotoModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          imageUrl: imageUrl,
          timestamp: DateTime.now());
      _photos.add(photo);
      emit(PostUpLoaded(photo));
    } catch (e) {
      emit(PostError("Không thể tải ảnh lên: $e"));
    }
  }

  // READ ALL
  Future<void> fetchPhotos(String userId) async {
    emit(PostLoading());
    try {
      final userPhotos = _photos.where((p) => p.userId == userId).toList();
      emit(PostLoaded(userPhotos));
    } catch (e) {
      emit(PostError("Không thể lấy ảnh: $e"));
    }
  }

  // UPDATE
  Future<void> updatePhoto(LocketPhotoModel updatedPhoto) async {
    emit(PostUpdating());
    try {
      final index = _photos.indexWhere((p) => p.id == updatedPhoto.id);
      if (index != -1) {
        _photos[index] = updatedPhoto;
        emit(PostUpdated(updatedPhoto));
      } else {
        emit(PostError("Không tìm thấy ảnh để cập nhật"));
      }
    } catch (e) {
      emit(PostError("Không thể cập nhật ảnh: $e"));
    }
  }

  // DELETE
  Future<void> deletePhoto(String photoId) async {
    emit(PostDeleting());
    try {
      _photos.removeWhere((p) => p.id == photoId);
      emit(PostDeleted(photoId));
    } catch (e) {
      emit(PostError("Không thể xóa ảnh: $e"));
    }
  }
}
