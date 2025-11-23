import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:locket_beta/logout/views/logout_ui.dart";
import 'package:locket_beta/profile/user_settings/edit_avatar_screen.dart';
import 'package:locket_beta/profile/user_settings/edit_email_screen.dart';
import 'package:locket_beta/profile/user_settings/edit_name_screen.dart';

// Assuming SettingsCubit and states are defined elsewhere
// import 'package:locket_beta/profile/user_settings/cubit/user_settings_cubit.dart';

// Mock classes for demonstration since the CUBIT is not provided
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());
  void fetchSettings() {
    // Simulate a network request
    Future.delayed(const Duration(seconds: 1), () {
      emit(SettingsLoaded(settings: "Mock Settings")); // Pass mock data
    });
  }
}

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final dynamic settings; // Using dynamic for mock data
  SettingsLoaded({required this.settings});
}

class SettingsError extends SettingsState {
  final String message;
  SettingsError({required this.message});
}
// End of mock classes

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit()..fetchSettings(),
      child: Scaffold(
        backgroundColor: const Color(0xff121212),
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff121212),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading || state is SettingsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SettingsError) {
              return Center(child: Text(state.message));
            }
            if (state is SettingsLoaded) {
              // final settings = state.settings; // You can use this if needed
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // --- Existing General Section ---
                  _buildSectionHeader('General'),
                  _SettingsListItem(
                    icon: Icons.text_fields,
                    title: 'Edit name',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditNameScreen()),
                      );
                    },
                  ),
                  _SettingsListItem(
                    icon: Icons.portrait_outlined,
                    title: 'Edit profile photo',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditAvatarScreen()),
                      );
                    },
                  ),
                  _SettingsListItem(
                    icon: Icons.mail_outline,
                    title: 'Add email address',
                    onTap: () {/* TODO */},
                  ),
                  const SizedBox(height: 16), // Spacer between sections

                  // --- Added About Section ---
                  _buildSectionHeader('About'),
                  _SettingsListItem(
                    icon: Icons.share_outlined,
                    title: 'Share My Locket',
                    onTap: () {/* TODO */},
                  ),
                  const SizedBox(height: 16), // Spacer between sections

                  // --- Added Danger Zone Section ---
                  _buildSectionHeader('Danger Zone'),
                  _SettingsListItem(
                    icon: Icons.logout_outlined,
                    title: 'Sign out',
                    iconColor: Colors.red,
                    titleColor: Colors.red,
                    onTap: () {
                      showLogoutDialog(context);
                    },
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SettingsListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? titleColor; // Added for custom title color
  final Color? iconColor; // Added for custom icon color

  const _SettingsListItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.titleColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xff2a2a2a),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading:
            Icon(icon, color: iconColor ?? Colors.white70), // Use custom color
        title: Text(
          title,
          style:
              TextStyle(color: titleColor ?? Colors.white), // Use custom color
        ),
        trailing: trailing ??
            (onTap != null
                ? const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.white70)
                : null),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
