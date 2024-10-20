import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Notes',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 132, 0)),
      useMaterial3: true,
    ),
    home: const HomePage(),
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
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              final emailVerified = user?.emailVerified ?? false;
              if (emailVerified) {
                print("User is verified!");
              } else {
                print("Please verify your account first!");
              }
              return Text("Done");
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
