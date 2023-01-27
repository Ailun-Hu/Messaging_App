import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messaging_app/app.dart';
import 'package:messaging_app/theme.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.channel}) : super(key: key);

  final Channel channel;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late StreamSubscription<int> unreadCountSubscription;
  String otherUserImage = "";
  String otherUserName = "";
  _otherUser() {
    widget.channel
        .queryMembers(
            filter: Filter.notEqual(
                'id', StreamChatCore.of(context).currentUser!.id),
            pagination: const PaginationParams(limit: 1))
        .then((value) => value.members[0].userId.toString())
        .then((value) => StreamChatCore.of(context)
            .client
            .queryUsers(filter: Filter.equal('id', value))
            .then((value) => setState(() {
                  otherUserImage = value.users[0].image.toString();
                  otherUserName = value.users[0].name.toString();
                })));
  }

  @override
  void initState() {
    super.initState();

    _otherUser();
    unreadCountSubscription = StreamChannel.of(context)
        .channel
        .state!
        .unreadCountStream
        .listen(_unreadCountHandler);
  }

  Future<void> _unreadCountHandler(int count) async {
    if (count > 0) {
      await StreamChannel.of(context).channel.markRead();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          children: [
            Container(
                width: 53,
                height: 53,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(otherUserImage),
                        fit: BoxFit.fill))),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(otherUserName, style: const TextStyle(fontSize: 17)),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 30,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListCore(
              emptyBuilder: (context) {
                return const Center(
                  child: Text('Nothing here...'),
                );
              },
              loadingBuilder: (context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              messageListBuilder: (context, list) {
                return Messages(messages: list);
              },
              errorBuilder: (context, err) {
                return const Center(
                  child: Text('Error'),
                );
              },
            ),
          ),
          const _ActionBar()
        ],
      ),
      // Column(
      //   children: [
      //     // Expanded(
      //     //   child: Messages(
      //     //     messageData: messageData,
      //     //   ),
      //     // ),
      //     const _ActionBar()
      //   ],
      // )
    );
  }
}

class _ActionBar extends StatefulWidget {
  const _ActionBar({Key? key}) : super(key: key);

  @override
  State<_ActionBar> createState() => _ActionBarState();
}

class _ActionBarState extends State<_ActionBar> {
  final TextEditingController controller = TextEditingController();

  Timer? _debounce;

  Future<void> sendMessage() async {
    if (controller.text.isNotEmpty) {
      StreamChannel.of(context)
          .channel
          .sendMessage(Message(text: controller.text));
      controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _onTextChange() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        StreamChannel.of(context).channel.keyStroke();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    controller.removeListener(_onTextChange);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: true,
        top: false,
        child: Row(children: [
          Container(
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        width: 2, color: Theme.of(context).dividerColor))),
            child: Padding(
              padding: const EdgeInsets.only(left: 18, right: 16),
              child: FloatingActionButton(
                onPressed: sendMessage,
                child: const Icon(
                  CupertinoIcons.add_circled_solid,
                  size: 40,
                ),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                  hintText: "...", border: InputBorder.none),
              onChanged: ((value) {
                StreamChannel.of(context).channel.keyStroke();
              }),
              onSubmitted: (_) => sendMessage(),
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 24),
            child: FloatingActionButton(
              heroTag: "Test",
              onPressed: sendMessage,
              backgroundColor: AppColors.secondary,
              child: const Icon(Icons.send_rounded),
            ),
          )
        ]));
  }
}

class Messages extends StatelessWidget {
  const Messages({super.key, required this.messages});
  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.separated(
        reverse: true,
        separatorBuilder: ((context, index) {
          if (index == messages.length - 1) {
            return _DateLabel(
                label: Jiffy(messages[index].createdAt.toLocal())
                    .MMMEd
                    .toString());
          } else {
            return const SizedBox.shrink();
          }
        }),
        itemCount: messages.length + 1,
        itemBuilder: (context, index) {
          if (index < messages.length) {
            final message = messages[index];
            if (message.user?.id == context.currentUser?.id) {
              return MessageTile(
                  message: message.text!, messageDate: message.createdAt);
            } else {
              return SenderMessageTile(
                  message: message.text!,
                  messageDate: message.createdAt,
                  profilePicture: message.user!.image!);
            }
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
    // ListView(
    //   children: [
    //     const _DateLabel(label: "Yesterday"),
    //     MessageTile(
    //       message: messageData.message,
    //       messageDate: messageData.messageDate,
    //     ),
    //     SenderMessageTile(
    //       message: messageData.message,
    //       messageDate: messageData.messageDate,
    //       profilePicture: messageData.profilePicture,
    //     ),
    //     SenderMessageTile(
    //       message: messageData.message,
    //       messageDate: messageData.messageDate,
    //       profilePicture: messageData.profilePicture,
    //     ),
    //     SenderMessageTile(
    //       message: messageData.message,
    //       messageDate: messageData.messageDate,
    //       profilePicture: messageData.profilePicture,
    //     ),
    //     SenderMessageTile(
    //       message: messageData.message,
    //       messageDate: messageData.messageDate,
    //       profilePicture: messageData.profilePicture,
    //     )
    //   ],
    // );
  }
}

class _DateLabel extends StatelessWidget {
  const _DateLabel({Key? key, required this.label}) : super(key: key);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ));
  }
}

class MessageTile extends StatefulWidget {
  const MessageTile(
      {Key? key, required this.message, required this.messageDate})
      : super(key: key);
  final String message;
  final DateTime messageDate;

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Align(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      show = !show;
                    });
                  },
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.all(Radius.circular(17))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      child: Text(
                        widget.message,
                        style: GoogleFonts.getFont("Lato",
                            color: const Color(0xFFF5F5F5), fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              if (show)
                Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                            Jiffy(widget.messageDate.toLocal()).jm.toString()))
                    .animate()
                    .moveY(begin: 20, duration: 200.milliseconds),
            ],
          ),
        ));
  }
}

class SenderMessageTile extends StatefulWidget {
  const SenderMessageTile(
      {Key? key,
      required this.profilePicture,
      required this.message,
      required this.messageDate})
      : super(key: key);

  final String profilePicture;
  final String message;
  final DateTime messageDate;

  @override
  State<SenderMessageTile> createState() => _SenderMessageTileState();
}

class _SenderMessageTileState extends State<SenderMessageTile> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 5),
                      child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(widget.profilePicture),
                                  fit: BoxFit.fill))),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          show = !show;
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 280),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 222, 222, 222),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(17))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              child: Text(
                                widget.message,
                                style: GoogleFonts.getFont("Lato",
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
                if (show)
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                              Jiffy(widget.messageDate.toLocal()).jm.toString())
                          .animate()
                          .moveY(begin: 20, duration: 200.milliseconds))
              ],
            ),
          ),
        ));
  }
}
