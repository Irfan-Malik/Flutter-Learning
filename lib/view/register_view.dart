
import 'package:flutter/material.dart';
import 'package:flutter_project/services/auth/auth_exceptions.dart';
import 'package:flutter_project/services/auth/auth_service.dart';
import '../constants/routes.dart';
import '../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'Enter Email',
            ),
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(hintText: 'Enter Password'),
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
          ),
          TextButton(
            onPressed: () async {
              var email = _emailController.text;
              var password = _passwordController.text;

              try {
                await  AuthService.firebase().createUser(
                    email: email, password: password
                );
               await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              }
              on WeakPasswordAuthException{
                await showErrorDialog(context,
                    'Weak Password');
              }
              on EmailAlreadyInUseAuthException{
                await  showErrorDialog(context,
                    'this email is already in use');
              }
              on InvalidEmailAuthException{
                await  showErrorDialog(context,
                    'This is an invalid email address');
              }
              on GenericAuthException{
                await  showErrorDialog(context,
                    'Failed to register');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already registered? go to Login'),
          )
        ],
      ),
    );
  }
}
