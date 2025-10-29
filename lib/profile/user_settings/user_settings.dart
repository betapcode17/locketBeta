import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:locket_beta/profile/user_settings/cubit/user_settings_cubit.dart';


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
              final settings = state.settings;
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildSectionHeader('General'),
                  _SettingsListItem(
                    icon: Icons.cake_outlined,
                    title: 'Edit birthday',
                    onTap: () { /* TODO */ },
                  ),
                  _SettingsListItem(
                    icon: Icons.text_fields,
                    title: 'Edit name',
                    onTap: () { /* TODO */ },
                  ),
                  _SettingsListItem(
                    icon: Icons.portrait_outlined,
                    title: 'Edit profile photo',
                    onTap: () { /* TODO */ },
                  ),
                  _SettingsListItem(
                    icon: Icons.phone_outlined,
                    title: 'Phone number',
                    onTap: () { /* TODO */ },
                  ),
                  _SettingsListItem(
                    icon: Icons.mail_outline,
                    title: 'Add email address',
                    onTap: () { /* TODO */ },
                  ),
                  _SettingsListItem(
                    icon: Icons.music_note_outlined,
                    title: 'Unlink music provider',
                    onTap: () { /* TODO */ },
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader('Support'),
                  _SettingsListItem(
                    icon: Icons.error_outline,
                    title: 'Report a problem',
                    onTap: () { /* TODO */ },
                  ),
                  _SettingsListItem(
                    icon: Icons.lightbulb_outline,
                    title: 'Make a suggestion',
                    onTap: () { /* TODO */ },
                  ),
                  _SettingsListItem(
                    icon: Icons.restore,
                    title: 'Restore purchases',
                    onTap: () { /* TODO */ },
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader('Privacy & Safety'),

                  _SettingsListItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: 'Send read receipts',
                    trailing: Switch(
                      value: settings.sendReadReceipts,
                      onChanged: (newValue) {
                        
                        context.read<SettingsCubit>().updateReadReceipts(newValue);
                      },
                      activeColor: Colors.amber,
                    ),
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

  const _SettingsListItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
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
        leading: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70) : null),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}