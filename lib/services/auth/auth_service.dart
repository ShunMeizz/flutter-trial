import 'package:neuroukey/services/auth/auth_provider.dart';
import 'package:neuroukey/services/auth/auth_user.dart';

//AuthService will expose the functionalities of AuthProvider to the outside world,
//the goal is to have AuthService to do more work than AuthProvider eventhough rn the
//only thing it does is just delegates all its functionality to the auth provider
class AuthService implements AuthProvider {
  @override
  Future<void> initialize() => provider.initialize();

  final AuthProvider provider;
  const AuthService(this.provider);

  @override
  Future<AuthUser> createUser(
          {required String email, required String password}) =>
      provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
