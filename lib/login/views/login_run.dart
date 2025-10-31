import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/login/cubit/login_cubit.dart';
import 'login_ui.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => LoginCubit(),
        child: const LoginUI(),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
