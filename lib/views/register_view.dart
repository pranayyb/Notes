import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_service.dart';
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
    return Scaffold(
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
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true; // Start loading
                              });
                              final email = _email.text;
                              final password = _password.text;

                              try {
                                if (email.isEmpty || password.isEmpty) {
                                  throw EmptyEmailAndPassword();
                                }
                                await AuthService.firebase().createUser(
                                  email: email,
                                  password: password,
                                );
                                AuthService.firebase().sendEmailVerification();
                                Navigator.of(context)
                                    .pushNamed(verifyEmailRoute);
                              } on EmptyEmailAndPassword {
                                await showErrorDialog(
                                  context,
                                  "Email or password cannot be empty!",
                                );
                              } on EmailAlreadyInUseAuthException {
                                await showErrorDialog(
                                  context,
                                  "Email is already registered. Try logging in.",
                                );
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  loginRoute,
                                  (route) => false,
                                );
                              } on InvalidEmailAuthException {
                                await showErrorDialog(
                                  context,
                                  "Please enter a valid email!",
                                );
                              } on WeakPasswordAuthException {
                                await showErrorDialog(context,
                                    "Weak password. Please enter at least 6 characters.");
                              } on GenericAuthException {
                                await showErrorDialog(
                                  context,
                                  "Something went wrong!",
                                );
                              } finally {
                                setState(() {
                                  _isLoading = false; // Stop loading
                                });
                              }
                            },
                            child: const Text('Register'),
                          ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
                          (route) => false,
                        );
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
    );
  }
}
