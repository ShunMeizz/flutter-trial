import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:neuroukey/firebase_options.dart';
import 'package:neuroukey/views/login_view.dart';
import 'package:neuroukey/views/register_view.dart';

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
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
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
            return const LoginView(); //---THIS IS NAMED ROUTE---
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
