import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:neuroukey/constants/routes.dart';

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
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, password: password);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  devtools.log("User not found");
                } else if (e.code == 'wrong-password') {
                  devtools.log("Wrong password");
                } else {
                  devtools.log("Something else happened");
                  devtools.log(e.code);
                }
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
