import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:procrew_task/data/models/user.dart';

abstract class AuthRepository {
  User? currentUser();

  Future<User> loginWithEmailAndPassword(String email, String password);

  Future<void> registerWithEmailAndPassword(String email, String password);

  Future<void> logout();

  Future<void> signInWithGoogle();

  Future<void> signInWithFacebook();

  Future<void> signInWithTwitter();
}

class FirebaseAuthRepository implements AuthRepository {
  final firebaseAuth.FirebaseAuth _auth = firebaseAuth.FirebaseAuth.instance;

  @override
  User? currentUser() {
    firebaseAuth.User? user = _auth.currentUser;
    return user != null ? User(uid: user.uid) : null;
  }

  @override
  Future<User> loginWithEmailAndPassword(String email, String password) async {
    try {
      firebaseAuth.UserCredential result = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return User(uid: result.user!.uid);
    } catch (e) {
      throw (e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  @override
  Future<User> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      firebaseAuth.UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return User(uid: result.user!.uid);
    } catch (e) {
      throw (e);
    }
  }

  @override
  Future<void> signInWithFacebook() {
    // TODO: implement signInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithTwitter() {
    // TODO: implement signInWithTwitter
    throw UnimplementedError();
  }
}
