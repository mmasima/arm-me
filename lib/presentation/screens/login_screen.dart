import 'package:armme/presentation/cubit/login_cubit.dart';
import 'package:armme/presentation/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:armme/presentation/screens/dashboard_screen.dart';

import '../../../data/service/login_api.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(LoginUserApi()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Login Screen")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                );
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<LoginCubit>();

              return Column(
                children: [
                  TextField(
                    controller: username,
                    decoration: const InputDecoration(labelText: 'Enter username'),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Enter password'),
                  ),
                  const SizedBox(height: 24),
                  state is LoginLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            cubit.login(username.text, password.text);
                          },
                          child: const Text('Submit'),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
