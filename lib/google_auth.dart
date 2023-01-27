import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messaging_app/chats.dart';
import 'package:messaging_app/contacts.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    as stream;

class AuthService {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const Chats();
          } else {
            return const Contacts();
          }
        });
  }

//Funtion moved to Chats.dart
  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    ).signIn();
    if (googleUser == null) return;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final UserCredential res =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return stream.User(
        id: res.user!.uid,
        image: res.user!.photoURL,
        name: res.user!.displayName);
  }

  googleSignOut() {
    FirebaseAuth.instance.signOut();
  }
}
