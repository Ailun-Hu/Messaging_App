import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/add_user.dart';
import 'package:messaging_app/app.dart';
import 'package:messaging_app/contacts.dart';
import 'package:messaging_app/select_user.dart';
import 'package:messaging_app/chats.dart';
import 'package:messaging_app/theme.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  final client = StreamChatClient('s63vmjsq57kr');

  runApp(MyApp(client: client));
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
      home: BottomNav(client: client),
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
  const BottomNav({super.key, required this.client});

  final StreamChatClient client;
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentPage = 1;

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

  void goToChats() {
    setState(() {
      currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 5),
              child: currentPage == 0
                  ? Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(context.currentUserImage!))),
                    )
                  : Container(),
            ),
          ],
          title: const Text(
            "Chats App",
            style: TextStyle(fontSize: 22),
          ),
          toolbarHeight: 70,
          leading: InkWell(
            child: const Icon(
              Icons.note_add_outlined,
              size: 40,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
                  return AddUserListPage();
                  //const Scaffold(body: UserListPage());
                },
              ));
            },
          )),
      body: Container(
        child: currentPage == 1
            ? SelectUserScreen(goToChats: goToChats)
            : const Chats(),
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
          if (currentPage == 0 && index == 1) {
            _signOut();
          }
        },
        selectedIndex: currentPage,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }
}
