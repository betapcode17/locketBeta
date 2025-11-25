import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../common/edit_field_cubit.dart';

class EditAvatarScreen extends StatefulWidget {
  const EditAvatarScreen({super.key});

  @override
  State<EditAvatarScreen> createState() => _EditAvatarScreenState();
}

class _EditAvatarScreenState extends State<EditAvatarScreen> {
  File? imageFile;
  XFile? pickedFile; 

  Future pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

    if (picked != null) {
      pickedFile = picked; 
      setState(() => imageFile = File(picked.path));
    }
    print("PICKED IMAGE: $picked.path");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditFieldCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xff121212),
        appBar: AppBar(
          title: const Text("Edit Profile Photo",
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xff121212),
        ),
        body: BlocConsumer<EditFieldCubit, EditFieldState>(
          listener: (context, state) {
            if (state is EditFieldSuccess) Navigator.pop(context, true);
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (imageFile != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(imageFile!, height: 180),
                    ),
                  const SizedBox(height: 20),

                  OutlinedButton(
                    onPressed: pickImage,
                    child: const Text("Choose Image",
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: (imageFile == null || state is EditFieldLoading)
                        ? null
                        : () async {
                            final formData = FormData.fromMap({
                              "avatarUrl": pickedFile!.path,
                            });
                            print("FORM DATA: " + formData.fields.toString());
                            context
                                .read<EditFieldCubit>()
                                .updateAvatar(formData);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: state is EditFieldLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
