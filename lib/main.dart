import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:neuroukey/constants/routes.dart';
import 'package:neuroukey/firebase_options.dart';
import 'package:neuroukey/views/login_view.dart';
import 'package:neuroukey/views/register_view.dart';
import 'package:neuroukey/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

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
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      //Builder expects to return a widget mao ng return Text('Done' or 'Loading') kay text is widget
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            /*user can be null maong user?.emailVerified, but if user can be null then unsa man iyang buhaton
              //na si boolean true or false man iya e output if user isn't null, then mao ng ?? false, para
              //automatic false siya if null man gani si user
              final user = FirebaseAuth.instance.currentUser;
              if (user?.emailVerified ?? false) {
                return const Text('Done');
              } else {
                ---THIS IS AN ANONYMOUS ROUTE--- 
                ---Anonymous route aren't as reusable---
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const VerifyEmailView(),
                    ),
                  );
                });
              }*/
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView(); //---THIS IS NAMED ROUTE---
              }
            } else {
              return const LoginView(); //---THIS IS NAMED ROUTE---
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout, yes }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  devtools.log(shouldLogout.toString());
                case MenuAction.yes:
                  devtools.log(value.toString());
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.yes,
                  child: Text('Yes'),
                ),
              ];
            },
          )
        ],
      ),
      body: const Text("Hello world"),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Logout')),
          ]);
    },
  ).then((value) =>
      value ?? false); //if the user won't choose any from the actions,
  // press ra sila anywhere sa screen, the ?? false will dismiss the dialog
}
