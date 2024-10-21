import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/views/login_view.dart';
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
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final user = FirebaseAuth.instance.currentUser;
            print(user?.email);
            if (user != null && user.emailVerified) {
              return Text("Welcome! Your email is verified.");
            } else {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => VerifyEmailView(),
              //   ),
              // );
              return const VerifyEmailView();
            }
          } else {
            return const Center(child: Text('Please log in.'));
          }
        },
      ),
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Please verify your email."),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await user.sendEmailVerification();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Verification email sent.')),
              );
            }
          },
          child: const Text("Send email verification"),
        ),
      ],
    );
  }
}
