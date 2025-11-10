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

      final lockets = [
        LocketPhotoModel(
            id: 'a',
            userId: '123',
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6nWrDmTZ5-h_wOryw8-CnXnOjuitgTOaHFg&s',
            timestamp: DateTime(2025, 10, 25)),
        LocketPhotoModel(
            id: 'b',
            userId: '123',
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhLrq4s4xwmnVwnLBDcBPH7CZY4SSto1DoDA&s',
            timestamp: DateTime(2025, 10, 24)),
        LocketPhotoModel(
            id: 'c',
            userId: '123',
            imageUrl:
                'https://thechive.com/wp-content/uploads/2019/12/person-hilariously-photoshops-animals-onto-random-things-xx-photos-25.jpg?attachment_cache_bust=3136487&quality=85&strip=info&w=400',
            timestamp: DateTime(2025, 10, 23)),
        LocketPhotoModel(
            id: 'd',
            userId: '123',
            imageUrl:
                'https://plus.unsplash.com/premium_photo-1689551670902-19b441a6afde?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cmFuZG9tJTIwcGVvcGxlfGVufDB8fDB8fHww&fm=jpg&q=60&w=3000',
            timestamp: DateTime(2025, 9, 20)),
        LocketPhotoModel(
            id: 'e',
            userId: '123',
            imageUrl:
                'https://www.boredpanda.com/blog/wp-content/uploads/2025/03/67c700849a6c7_funny-random-rare-pictures.jpg',
            timestamp: DateTime(2025, 8, 19)),
        LocketPhotoModel(
            id: 'e',
            userId: '123',
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThOIJADhWt65CEl5WEehoHPaJBCfeh5P5Vqg&s',
            timestamp: DateTime(2025, 8, 19)),
        LocketPhotoModel(
            id: 'e',
            userId: '123',
            imageUrl:
                'https://pbs.twimg.com/profile_images/495157428745678848/_iUW0sIC.jpeg',
            timestamp: DateTime(2025, 8, 19)),
        LocketPhotoModel(
            id: 'e',
            userId: '123',
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlm7hKdlMDSHrkEGXwO2yF1nOB6sRZM9yCIw&s',
            timestamp: DateTime(2025, 8, 19)),
        LocketPhotoModel(
            id: 'e',
            userId: '123',
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAYWm7TwxYUYqAhnpQNgd92209vu4Kgg_8yQ&s',
            timestamp: DateTime(2025, 8, 19)),
        LocketPhotoModel(
            id: 'e',
            userId: '123',
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXMyxRZFyt1Sqy9i0tiLXmlqCFXUSv3YWdNw&s',
            timestamp: DateTime(2025, 8, 19)),
        LocketPhotoModel(
            id: 'e',
            userId: '123',
            imageUrl:
                'https://img.freepik.com/premium-photo/random-image_590832-9664.jpg',
            timestamp: DateTime(2025, 8, 19)),
        LocketPhotoModel(
            id: 'e',
            userId: '123',
            imageUrl:
                'https://cdn.dribbble.com/userupload/15575029/file/original-0e6a01ce3727e2b4022b3fdd1e495156.png?resize=752x&vertical=center',
            timestamp: DateTime(2025, 8, 19)),
        LocketPhotoModel(
            id: 'e',
            userId: '123',
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbhihvepad41lmyESpsCoHKvIFJKbSuZZ-2w&s',
            timestamp: DateTime(2025, 8, 19)),
      ];

      final userProfile = UserProfileModel(
        id: '123',
        username: 'Hậu Ngọc',
        handle: 'dodoododo',
        profileImageUrl:
            'https://i.pinimg.com/736x/c8/94/c0/c894c0cabce37aeb478dc2ac06743cb5.jpg',
        locketCount: lockets.length,
        streak: 0,
      );

      emit(ProfileLoaded(userProfile, lockets));
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }
}
