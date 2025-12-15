import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. User hiện tại
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 3. Đăng ký
  Future<User?> register({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      // ignore: avoid_print
      print("Lỗi đăng ký: $e");
      rethrow;
    }
  }

  // 4. Đăng nhập
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      // ignore: avoid_print
      print("Lỗi đăng nhập: $e");
      rethrow;
    }
  }

  // 5. Đăng xuất
  Future<void> logout() async {
    await _auth.signOut();
  }
}