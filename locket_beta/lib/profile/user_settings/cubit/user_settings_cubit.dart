import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/model/user_settings_model.dart';

part 'user_settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  
  Future<void> fetchSettings() async {
    try {
      emit(SettingsLoading());

      
      await Future.delayed(const Duration(milliseconds: 500));
      
      final settings = UserSettingsModel(
        birthday: 'January 1, 2000',
        name: 'Hậu Ngọc',
        profilePhotoUrl: 'https://placeimg.com/100/100/people',
        phoneNumber: '+123456789',
        emailAddress: 'hau.ngoc@example.com',
        sendReadReceipts: true,
      );
      

      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError('Failed to load settings.'));
    }
  }

  
  Future<void> updateReadReceipts(bool newValue) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      
      
      emit(SettingsLoaded(currentSettings.copyWith(sendReadReceipts: newValue)));
      
      
      try {
        await Future.delayed(const Duration(milliseconds: 700));
        
      } catch (e) {
        
        emit(SettingsLoaded(currentSettings)); 
      }
    }
  }
}