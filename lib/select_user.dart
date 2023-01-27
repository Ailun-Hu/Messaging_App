import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messaging_app/google_auth.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    as stream;
import 'demo_users.dart';
import 'package:logger/logger.dart' as log;

var logger = log.Logger();

class SelectUserScreen extends StatefulWidget {
  const SelectUserScreen({
    super.key,
    required this.goToChats,
  });

  final Function goToChats;

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  bool loading = false;

  Future<void> onUserSelected(DemoUsers user) async {
    setState(() {
      loading = true;
    });
    try {
      final client = stream.StreamChatCore.of(context).client;
      await client.connectUser(
          stream.User(id: user.id), client.devToken(user.id).rawValue);
      setState(() {
        loading = false;
      });
    } on Exception catch (e, st) {
      logger.e("could not connect user", e, st);
      setState(() {
        loading = false;
      });
    }

    widget.goToChats();
  }

  Future<void> googleLogin() async {
    setState(() {
      loading = true;
    });
    //Google Login
    final client = stream.StreamChatCore.of(context).client;
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    ).signIn();
    if (googleUser == null) {
      setState(() {
        loading = false;
      });
      return;
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final UserCredential res =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final stream.User user = stream.User(
        id: res.user!.uid,
        image: res.user!.photoURL,
        name: res.user!.displayName);

    //Stream Login After Google Login
    try {
      await client.connectUser(user, client.devToken(user.id).rawValue);
    } on Exception catch (e, st) {
      logger.e("could not connect user", e, st);
      setState(() {
        loading = false;
      });
    }
    widget.goToChats();
  }

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      googleLogin();
                    },
                    child: const Image(
                        width: 300, image: AssetImage('assets/google.png'))),
                Expanded(
                    child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return SelectUserButton(
                        user: users[index], onPressed: onUserSelected);
                  },
                )),
              ],
            ),
          );
  }
}

class SelectUserButton extends StatelessWidget {
  const SelectUserButton(
      {super.key, required this.user, required this.onPressed});

  final DemoUsers user;
  final Function(DemoUsers user) onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
          onTap: () {
            onPressed(user);
          },
          child: Row(children: [
            Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: NetworkImage(user.image)))),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                user.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ])),
    );
  }
}
