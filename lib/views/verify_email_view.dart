// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // // import 'dart:developer' as devtools show log;

// // class VerifyEmailView extends StatefulWidget {
// //   const VerifyEmailView({super.key});

// //   @override
// //   State<VerifyEmailView> createState() => _VerifyEmailViewState();
// // }

// // class _VerifyEmailViewState extends State<VerifyEmailView> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         const Text("Please verify your email."),
// //         ElevatedButton(
// //           onPressed: () async {
// //             final user = FirebaseAuth.instance.currentUser;
// //             if (user != null) {
// //               await user.sendEmailVerification();
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 const SnackBar(content: Text('Verification email sent.')),
// //               );
// //             }
// //           },
// //           child: const Text("Send email verification"),
// //         ),
// //       ],
// //     );
// //   }
// // }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:notes/constants/routes.dart';
// // import 'dart:developer' as devtools show log;

// class VerifyEmailView extends StatefulWidget {
//   const VerifyEmailView({super.key});

//   @override
//   State<VerifyEmailView> createState() => _VerifyEmailViewState();
// }

// class _VerifyEmailViewState extends State<VerifyEmailView> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Text("Please verify your email."),
//         ElevatedButton(
//           onPressed: () async {
//             final user = FirebaseAuth.instance.currentUser;
//             if (user != null) {
//               await user.sendEmailVerification();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Verification email sent.')),
//               );
//             }
//           },
//           child: const Text("Send email verification"),
//         ),
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pushNamedAndRemoveUntil(
//               loginRoute,
//               (route) => false,
//             );
//           },
//           child: const Text("Go to Login page."),
//         )
//       ],
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool _isLoading = false; // To track if loading is in progress

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Email sent to the registered email. Please verify and come back!",
                  textAlign: TextAlign.center,
                ),
                const Text(""),
                const Text(
                  "If you haven't received a mail from us click the button below.",
                  textAlign: TextAlign.center,
                  // textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _isLoading
                    ? const CircularProgressIndicator() // Show a loading indicator when sending email
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true; // Start loading
                          });
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            try {
                              await user.sendEmailVerification();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Verification email sent.')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Failed to send verification email.')),
                              );
                            } finally {
                              setState(() {
                                _isLoading = false; // Stop loading
                              });
                            }
                          }
                        },
                        child: const Text("Hit me!!"),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  },
                  child: const Text("Restart!"),
                ),
              ],
            ),
          )),
    );
  }
}
