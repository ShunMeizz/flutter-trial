import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:neuroukey/constants/routes.dart';
import 'package:neuroukey/services/auth/auth_exceptions.dart';
import 'package:neuroukey/services/auth/auth_service.dart';
import 'package:neuroukey/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController emailCon;
  late final TextEditingController passwordCon;

  @override
  void initState() {
    emailCon = TextEditingController();
    passwordCon = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailCon.dispose();
    passwordCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailCon,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          TextField(
              controller: passwordCon,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(hintText: 'Password')),
          TextButton(
            onPressed: () async {
              final email = emailCon.text;
              final password = passwordCon.text;
              try {
                final userCredential = await AuthService.firebase()
                    .createUser(email: email, password: password);
                devtools.log(userCredential.toString());
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(context, "Weak password");
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, "Email is already in use");
              } on InvalidEmailAuthException {
                await showErrorDialog(
                    context, "This is an invalid email address");
              } on GenericAuthException {
                await showErrorDialog(context, "Failed to register");
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already registered? Login here!'),
          ),
        ],
      ),
    );
  }
}
