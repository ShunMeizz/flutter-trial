import 'package:flutter/material.dart';
import 'package:neuroukey/constants/routes.dart';
import 'package:neuroukey/services/auth/auth_service.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); //navigate back to previous screen
          },
        ),
      ),
      body: Column(children: [
        const Text(
            "We've sent you an email verification. Please open it to verify."),
        const Text(
            "If you haven't received a verification email yet, press the button below."),
        TextButton(
          onPressed: () async {
            AuthService.firebase().sendEmailVerification();
          },
          child: const Text('Send verification email'),
        ),
        TextButton(
          onPressed: () async {
            await AuthService.firebase().logOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false,
            );
          },
          child: const Text('Restart'),
        )
      ]),
    );
  }
}
