import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../common/edit_field_cubit.dart';

class EditEmailScreen extends StatefulWidget {
  const EditEmailScreen({super.key});

  @override
  State<EditEmailScreen> createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditFieldCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xff121212),
        appBar: AppBar(
          title: const Text("Add Email", style: TextStyle(color: Colors.white)),
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
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Email address",
                      labelStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: state is EditFieldLoading
                        ? null
                        : () {
                            context.read<EditFieldCubit>().updateField({
                              "email": controller.text.trim(),
                            });
                          },
                    child: state is EditFieldLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save"),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
