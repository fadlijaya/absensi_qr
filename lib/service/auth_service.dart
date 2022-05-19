import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth;

  AuthService(this.auth);

  Stream<User?> get authStateChanges => auth.idTokenChanges();

  Future<String> login(
      {required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "Logged In";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUp(
      {required String email, required String password, required String nip, required String fullName}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseFirestore.instance
          .collection("absensi")
          .doc(auth.currentUser!.uid)
          .set({
            'uid': auth.currentUser!.uid,
            'nip': nip,
            'nama lengkap': fullName,
            'waktu': '',
            'status': ''
          });

      return "Signed Up";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<String> uid() async {
    return auth.currentUser!.uid;
  }
}
