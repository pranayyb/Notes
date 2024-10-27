import 'package:flutter/material.dart';
// import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
// import 'dart:developer' as devtools show log;

import 'package:notes/utilities/dialogs/error_dialog.dart';
import 'package:notes/utilities/dialogs/loading_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;
  bool _isLoading = false; // loading state

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialogHandle;
          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialogHandle = showLoadingDialog(
              context: context,
              text: "Loading......",
            );
          }
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found!');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email!');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication Error!');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text("Login"),
          ),
          toolbarHeight: 50.0,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          titleTextStyle: const TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        body: FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextField(
                            controller: _email,
                            // enableSuggestions: true,
                            autocorrect: false,
                            decoration: const InputDecoration(
                                hintText: "Enter your email"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextField(
                            controller: _password,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                                hintText: "Enter your password"),
                          ),
                        ),
                        if (_isLoading) // Show loading indicator if loading
                          const Center(
                            child:
                                CircularProgressIndicator(), // Show loading while initializing
                          )
                        else
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true; // Set loading to true
                              });
                              final email = _email.text;
                              final password = _password.text;
                              context.read<AuthBloc>().add(
                                    AuthEventLogIn(
                                      email: email,
                                      password: password,
                                    ),
                                  );
                              setState(() {
                                _isLoading = false; // Set loading to false
                              });
                            },
                            child: const Text('Login'),
                          ),
                        TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthEventShouldRegister(),
                                );
                          },
                          child: const Text("New to Notes? Register here."),
                        ),
                      ],
                    ),
                  ),
                );
              default:
                return const Center(
                  child:
                      CircularProgressIndicator(), // Show loading while initializing
                );
            }
          },
        ),
      ),
    );
  }
}
