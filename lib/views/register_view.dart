import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/firebase_options.dart';
// import 'dart:developer' as devtools show log;

import 'package:notes/views/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
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
                    ElevatedButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;

                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          final user = FirebaseAuth.instance.currentUser;
                          await user?.sendEmailVerification();
                          Navigator.of(context).pushNamed(verifyEmailRoute);
                          // devtools.log(
                          //     "User registered: ${userCredential.user?.email}");
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            await showErrorDialog(context,
                                "Email is already registered. Try logging in.");
                            // devtools.log("dusra email dhund bhai!");
                          } else if (e.code == 'invalid-email') {
                            await showErrorDialog(
                                context, "Please enter a valid email!");
                            // devtools.log("Enter Valid Email!");
                          } else {
                            await showErrorDialog(
                                context, "Something went wrong!");
                          }
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
                      child: Text("Already a member? Login here."),
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
