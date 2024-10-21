import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}
class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool _isSendingEmailLoading = false; // Track email sending button state
  bool _isLoggingOutLoading = false; // Track logout button state

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
            children: [
              const Text(
                "Email sent to the registered email. Please verify and come back!",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "If you haven't received a mail from us click the button below.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Show CircularProgressIndicator or "Hit me!!" button
              _isSendingEmailLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isSendingEmailLoading = true; // Start email loading
                        });

                        final user = AuthService.firebase().currentUser;
                        if (user != null) {
                          try {
                            await AuthService.firebase()
                                .sendEmailVerification();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Verification email sent.'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Failed to send verification email.'),
                              ),
                            );
                          } finally {
                            setState(() {
                              _isSendingEmailLoading =
                                  false; // Stop email loading
                            });
                          }
                        }
                      },
                      child: const Text("Hit me!!"),
                    ),
              const SizedBox(height: 16),

              // Show CircularProgressIndicator or "Restart!" button
              _isLoggingOutLoading
                  ? const CircularProgressIndicator()
                  : TextButton(
                      onPressed: () async {
                        setState(() {
                          _isLoggingOutLoading = true; // Start logout loading
                        });

                        try {
                          await AuthService.firebase().logOut();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute,
                            (route) => false,
                          );
                        } finally {
                          setState(() {
                            _isLoggingOutLoading = false; // Stop logout loading
                          });
                        }
                      },
                      child: const Text("Restart!"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
