part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfileModel userProfile;
  final List<PhotoModel> lockets;
  final Map<String, List<PhotoModel>> groupedLocket;

  ProfileLoaded(this.userProfile, this.lockets)
      : groupedLocket = _groupLocketByMonth(lockets);

  static Map<String, List<PhotoModel>> _groupLocketByMonth(
      List<PhotoModel> lockets) {
    final Map<String, List<PhotoModel>> map = {};
    for (var locket in lockets) {
      final key = DateFormat('MMMM yyyy').format(locket.timestamp);
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(locket);
    }
    return map;
  }
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
