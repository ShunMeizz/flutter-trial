import 'package:flutter/material.dart';
import 'package:neuroukey/constants/routes.dart';
import 'package:neuroukey/services/auth/auth_service.dart';
import 'package:neuroukey/views/login_view.dart';
import 'package:neuroukey/views/notes_view.dart';
import 'package:neuroukey/views/register_view.dart';
import 'package:neuroukey/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //instead na mabutang ni siya inside sa TextButton pressed,
      //we will follow the architecture na e initialize daan si firebase
      //before performing such things: engines dayun framework
      future: AuthService.firebase().initialize(),
      //Builder expects to return a widget mao ng return Text('Done' or 'Loading') kay text is widget
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            /*---THIS IS AN ANONYMOUS ROUTE--- 
                ---Anonymous route aren't as reusable---
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const VerifyEmailView(),
                    ),
                  );
                });
              }*/
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView(); //---THIS IS NAMED ROUTE---
              }
            } else {
              return const LoginView(); //---THIS IS NAMED ROUTE---
            }
          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
