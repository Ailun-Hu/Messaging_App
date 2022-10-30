import 'package:flutter/material.dart';
import 'package:messaging_app/chat.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Chat();
            },
          ),
        );
      },
      child: const Text('test'),
    ));
  }
}
