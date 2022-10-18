import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/Contacts.dart';
import 'package:messaging_app/chats.dart';
import 'package:messaging_app/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
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
  final pages = [Chats(), Contacts()];
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
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messaging App")),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(CupertinoIcons.bubble_left_bubble_right_fill),
              label: "Chats"),
          NavigationDestination(icon: Icon(Icons.people), label: "Contacts")
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
