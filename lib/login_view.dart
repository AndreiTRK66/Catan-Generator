import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:harta_catan/constants/routes.dart';
import 'package:harta_catan/firebase_options.dart';
import 'package:harta_catan/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: () async {
              await Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
              );
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(catanRoute, (route) => false);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-credential') {
                  await showErrorDialog(context, 'Invalid Credentials');
                }
              } catch (e) {
                await showErrorDialog(context, e.toString());
              }
            },
            child: const Text('Login'),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not registered? Register here'),
          ),
        ],
      ),
    );
  }
}
