import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:locket_beta/model/locket_photo_model.dart';
import 'package:locket_beta/model/profile_model.dart'; 

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchProfile() async {
    try {
      emit(ProfileLoading());

      await Future.delayed(const Duration(seconds: 1));

      final userProfile = UserProfileModel(
        id: '123',
        username: 'Hậu Ngọc',
        handle: 'dodoododo',
        profileImageUrl: 'https://placeimg.com/100/100/people', 
        locketCount: 1533,
        streak: 0,
      );

      final lockets = [
        LocketPhotoModel(id: 'a', userId: '123', imageUrl: 'https://placeimg.com/100/100/nature', timestamp: DateTime(2025, 10, 25)),
        LocketPhotoModel(id: 'b', userId: '123', imageUrl: 'https://placeimg.com/100/100/animals', timestamp: DateTime(2025, 10, 24)),
        LocketPhotoModel(id: 'c', userId: '123', imageUrl: 'https://placeimg.com/100/100/tech', timestamp: DateTime(2025, 10, 23)),
        LocketPhotoModel(id: 'd', userId: '123', imageUrl: 'https://placeimg.com/100/100/arch', timestamp: DateTime(2025, 9, 20)),
        LocketPhotoModel(id: 'e', userId: '123', imageUrl: 'https://placeimg.com/100/100/grayscale', timestamp: DateTime(2025, 9, 19)),
      ];
      

      emit(ProfileLoaded(userProfile, lockets));
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }
}