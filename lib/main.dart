import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/verify_email_view.dart';
// import 'package:notes/views/register_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before running the app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    title: 'Notes',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 255, 132, 0),
      ),
      useMaterial3: true,
    ),
    home: const LoginView(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
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
          future: FirebaseAuth.instance.authStateChanges().first,
          // builder: (context, snapshot) {
          //   if (snapshot.connectionState == ConnectionState.waiting) {
          //     return const Center(child: CircularProgressIndicator());
          //   } else if (snapshot.hasData) {
          //     final user = FirebaseAuth.instance.currentUser;
          //     print(user?.email);
          //     if (user != null && user.emailVerified) {
          //       return Text("Welcome! Your email is verified.");
          //     } else {
          //       // Navigator.of(context).push(
          //       //   MaterialPageRoute(
          //       //     builder: (context) => VerifyEmailView(),
          //       //   ),
          //       // );
          //       return const VerifyEmailView();
          //     }
          //   } else {
          //     return LoginView();
          //   }
          // },
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                print(user?.email);
                if (user != null) {
                  if (user.emailVerified) {
                    return Text("Welcome! Your email is verified.");
                  } else {
                    return const VerifyEmailView();
                  }
                } else {
                  return const LoginView();
                }
              default:
                return const Center(
                    child: CircularProgressIndicator()); // Default case
            }
          }),
    );
  }
}
