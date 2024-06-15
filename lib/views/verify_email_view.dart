import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email Address"),
      ),
      body: Column(children: [
        const Text("Please verify your email address: "),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            //starting with user?.sendEmailVerification since its a future, add await, then add async
            await user?.sendEmailVerification();
          },
          child: const Text('Send verification email'),
        )
      ]),
    );
  }
}
