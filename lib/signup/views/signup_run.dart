import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/signup/cubit/signup_cubit.dart';
import 'signup_ui.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => SignupCubit(),
        child: const SignupUI(),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
