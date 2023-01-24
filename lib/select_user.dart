import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
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
      final client = StreamChatCore.of(context).client;
      await client.connectUser(
          User(id: user.id), client.devToken(user.id).rawValue);
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

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return SelectUserButton(
                        user: users[index], onPressed: onUserSelected);
                  },
                ))
              ],
            ));
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
