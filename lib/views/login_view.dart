import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
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
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Login"),
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
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration:
                            const InputDecoration(hintText: "Enter your email"),
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
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true; // Set loading to true
                          });

                          final email = _email.text;
                          final password = _password.text;

                          try {
                            if (email.isEmpty || password.isEmpty) {
                              throw EmptyEmailAndPassword();
                            }
                            final userCredential =
                                await AuthService.firebase().logIn(
                              email: email,
                              password: password,
                            );
                            devtools.log(userCredential.toString());
                            final user = AuthService.firebase().currentUser;
                            if (user?.isEmailVerified ?? false) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                notesRoute,
                                (route) => false,
                              );
                            } else {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                verifyEmailRoute,
                                (route) => false,
                              );
                            }
                          } on EmptyEmailAndPassword {
                            await showErrorDialog(
                              context,
                              "Email or password cannot be empty!",
                            );
                          } on UserNotFoundAuthException {
                            await showErrorDialog(
                              context,
                              "User not Found!",
                            );
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              registerRoute,
                              (route) => false,
                            );
                          } on WrongPasswordAuthException {
                            await showErrorDialog(
                              context,
                              "Incorrect Credentials!! Check email and password and try again!",
                            );
                          } on GenericAuthException {
                            await showErrorDialog(
                              context,
                              "Authentication Error!",
                            );
                          } finally {
                            setState(() {
                              _isLoading = false; // Set loading to false
                            });
                          }
                        },
                        child: const Text('Login'),
                      ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute,
                          (route) => false,
                        );
                      },
                      child: const Text("New to Notes? Register here."),
                    ),
                  ],
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
    );
  }
}

Future<void> showErrorDialog(
  BuildContext context,
  String message,
) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Haha got you!😈"),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(message),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Okay"),
          ),
        ],
      );
    },
  );
}
