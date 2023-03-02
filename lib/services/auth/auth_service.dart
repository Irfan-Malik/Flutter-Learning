import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_project/services/auth/auth_provider.dart';
import 'package:flutter_project/services/auth/auth_user.dart';
import 'package:flutter_project/services/auth/firebase_auth_provider.dart';
import 'package:flutter_project/services/firebase_options.dart';

class AuthService implements AuthProvider {
  final AuthProvider authProvider;

  const AuthService(this.authProvider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      authProvider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => authProvider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      authProvider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => authProvider.logOut();

  @override
  Future<void> sendEmailVerification() => authProvider.sendEmailVerification();

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
