import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harta_catan/constants/routes.dart';
import 'package:harta_catan/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _password = TextEditingController();
  bool _isLoading = false;

  Future<void> _onTapSignUp(BuildContext context) async {
    final email = _email.text;
    final password = _password.text;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(verifyEmailRoute, (_) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        await showErrorDialog(context, 'Weak password');
      } else if (e.code == 'email-already-in-use') {
        await showErrorDialog(context, 'Email is already in use');
      } else if (e.code == 'invalid-email') {
        await showErrorDialog(context, 'Invalid email');
      } else {
        await showErrorDialog(context, 'Error: ${e.code}');
      }
    } catch (e) {
      await showErrorDialog(context, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
      appBar: AppBar(title: const Text('Register')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: _isLoading ? null : () => _onTapSignUp(context),
            child:
                _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: Text('Already registered? Login here'),
          ),
        ],
      ),
    );
  }
}
