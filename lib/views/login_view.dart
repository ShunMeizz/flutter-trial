import 'package:flutter/material.dart';
import 'package:neuroukey/constants/routes.dart';
import 'package:neuroukey/services/auth/auth_exceptions.dart';
import 'package:neuroukey/services/auth/auth_service.dart';
import 'package:neuroukey/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: const Text("Login")),
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
                await AuthService.firebase()
                    .logIn(email: email, password: password);

                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  //user's email is verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  //user's email is NOT verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(context, "User not found");
              } on WrongPasswordAuthException {
                await showErrorDialog(context, "Wrong password");
              } on GenericAuthException {
                await showErrorDialog(context, "Authentication error");
              } catch (e) {
                await showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) =>
                    false, //Remove evrything from the current route and just go to register
              );
            },
            child: const Text("New? Register Here!"),
          ),
        ],
      ),
    );
  }
}
