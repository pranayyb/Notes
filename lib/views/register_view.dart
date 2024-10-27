import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
import 'package:notes/utilities/dialogs/error_dialog.dart';
// import 'package:notes/views/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isLoading = false;

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
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email is already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text("Register"),
          ),
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
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: _email,
                          // enableSuggestions: false,
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
                      _isLoading
                          ? const Center(
                              child:
                                  CircularProgressIndicator(), // Show loading while initializing
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true; // Start loading
                                });
                                final email = _email.text;
                                final password = _password.text;
                                if (email.isEmpty || password.isEmpty) {
                                  throw EmptyEmailAndPassword();
                                }
                                context.read<AuthBloc>().add(AuthEventRegister(
                                      email: email,
                                      password: password,
                                    ));
                                setState(() {
                                  _isLoading = false; // Stop loading
                                });
                              },
                              child: const Text('Register'),
                            ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(const AuthEventLogout());
                        },
                        child: const Text("Already a member? Login here."),
                      ),
                    ],
                  ),
                );
              default:
                return const Center(
                  child: Text('Loading......'),
                );
            }
          },
        ),
      ),
    );
  }
}
