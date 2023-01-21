import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/Contacts.dart';
import 'package:messaging_app/SelectUser.dart';
import 'package:messaging_app/Widgets/Helpers.dart';
import 'package:messaging_app/chats.dart';
import 'package:messaging_app/theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:logger/logger.dart' as log;

var logger = log.Logger();

int currentPage = 1;
void main() {
  const streamKey = 's63vmjsq57kr';
  final client = StreamChatClient(streamKey);
  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.client});

  final StreamChatClient client;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      builder: (context, child) {
        return StreamChatCore(client: client, child: child!);
      },
      home: const BottomNav(),
    );
  }
}

class CurrentPage extends StatefulWidget {
  const CurrentPage({super.key});
  @override
  State<CurrentPage> createState() => _CurrentPageState();
}

class _CurrentPageState extends State<CurrentPage> {
  final pages = [const Chats(), const Contacts()];
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  Future<void> _signOut() async {
    try {
      await StreamChatCore.of(context).client.disconnectUser();
      setState(() {
        currentPage = 1;
      });
    } on Exception catch (e, st) {
      logger.e("Unable to Sign Out", e, st);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 5),
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(Helpers.randomPictureUrl()))),
              ),
            ),
          ],
          title: const Text(
            "Chats App",
            style: TextStyle(fontSize: 22),
          ),
          toolbarHeight: 70,
          leading: const Icon(
            Icons.note_add_outlined,
            size: 40,
          )),
      body: Container(
        child: currentPage == 1 ? const SelectUserScreen() : const Chats(),
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 3.0,
        height: 70,
        destinations: const [
          NavigationDestination(
              icon: Icon(CupertinoIcons.bubble_left_bubble_right_fill),
              label: "Chats"),
          NavigationDestination(icon: Icon(Icons.people), label: "Contacts")
        ],
        onDestinationSelected: (int index) {
          // if (currentPage == 0 && index == 1) {
          //   _signOut();
          // }
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }
}
