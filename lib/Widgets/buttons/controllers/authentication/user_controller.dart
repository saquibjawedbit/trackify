import 'package:bit_book/Misc/Models/user_model.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController extends GetxController {
  //Obs
  var loginMessage = "".obs;
  var loggedIn = false.obs;

  UserModel? user;
  FirebaseFirestore db = FirebaseFirestore.instance;

  void fetchUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> data =
        await db.collection('user').doc(uid).get();
    if (data.data() == null) {
      loggedIn.value = false;
      return null;
    } else {
      user = UserModel.fromMap(data.data()!);
      loggedIn.value = true;
    }
  }

  void login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        loginMessage.value = 'The email provided is invalid.';
      } else if (e.code == 'user-disabled') {
        loginMessage.value = 'The account is disabled.';
      } else if (e.code == 'user-not-found') {
        loginMessage.value = "User not found";
      } else if (e.code == "wrong-password") {
        loginMessage.value = "Wrong Password";
      } else {
        print(e);
        loginMessage.value = "Something went wrong";
      }
    } catch (e) {
      print("Error $e");
    }
    Get.offNamed('/');
  }

  void saveDetails(String name, String lastName, String rollNo) {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    String id = FirebaseAuth.instance.currentUser!.uid;
    UserModel userModel = UserModel(
      email: email,
      name: "$name $lastName",
      rollno: rollNo,
      semester: 1,
    );

    db.collection("user").doc(id).set(userModel.toMap());
    Get.offAllNamed('/');
  }

  //Google Sign In
  void signInWithGoogle() async {
    // print(FirebaseAuth.instance.currentUser == null);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        clientId:
            "31679741662-0rfj74bl59n4dqnoudicvuuo56qqnsn1.apps.googleusercontent.com",
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.offNamed("/onboard");
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> createAccount(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offNamed("/onboard");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        loginMessage.value = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        loginMessage.value = 'The account already exists for that email.';
      } else {
        loginMessage.value = e.code;
      }
    } catch (e) {
      print(e);
    }
  }
}
