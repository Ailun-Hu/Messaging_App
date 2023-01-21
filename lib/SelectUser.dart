import 'package:flutter/material.dart';
import 'package:messaging_app/Widgets/Helpers.dart';
import 'demo_users.dart';

class SelectUserScreen extends StatefulWidget {
  const SelectUserScreen({super.key});

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return (loading)
        ? const CircularProgressIndicator()
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return SelectUserButton(user: users[index]);
                  },
                ))
              ],
            ));
  }
}

class SelectUser extends StatelessWidget {
  const SelectUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text("Hello"),
    );
  }
}

class SelectUserButton extends StatelessWidget {
  const SelectUserButton({super.key, required this.user});

  final DemoUsers user;
  // final Function(DemoUsers user) onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
          onTap: () => {},
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
