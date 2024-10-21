import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/notes_view.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Notes',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 255, 132, 0),
      ),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Notes"),
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
          // FirebaseAuth.instance.authStateChanges().first,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                user?.reload();
                devtools.log((user?.email).toString());
                if (user != null) {
                  if (user.emailVerified) {
                    return const NotesView();
                  } else {
                    return const VerifyEmailView();
                  }
                } else {
                  return const LoginView();
                }
              default:
                return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

enum MenuAction { logout }

