import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:messaging_app/Widgets/Helpers.dart';
import 'package:messaging_app/models/message_data.dart';
import 'package:messaging_app/theme.dart';
import 'package:flutter_animate/animate.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.messageData}) : super(key: key);

  final MessageData messageData;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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
                          image:
                              NetworkImage(widget.messageData.profilePicture),
                          fit: BoxFit.fill))),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(widget.messageData.senderName,
                    style: const TextStyle(fontSize: 17)),
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
        body: Messages(
          messageData: widget.messageData,
        ));
  }
}

class ChatMessages extends StatefulWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  int text = 1;
  final items = [];
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  void sendMessage() {
    items.insert(
        0,
        MessageTile(
            message: text.toString(), messageDate: Helpers.randomDate()));
    _key.currentState!
        .insertItem(0, duration: const Duration(milliseconds: 100));
  }

  void _removeItem(int index) {
    _key.currentState!.removeItem(
      index,
      (context, animation) => SizeTransition(sizeFactor: animation),
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Messages extends StatelessWidget {
  const Messages({super.key, required this.messageData});
  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return ListView(
      reverse: true,
      children: [
        const _DateLabel(label: "Yesterday"),
        MessageTile(
          message: messageData.message,
          messageDate: messageData.messageDate,
        ),
        SenderMessageTile(
          message: messageData.message,
          messageDate: messageData.messageDate,
          profilePicture: messageData.profilePicture,
        ),
        SenderMessageTile(
          message: messageData.message,
          messageDate: messageData.messageDate,
          profilePicture: messageData.profilePicture,
        ),
        SenderMessageTile(
          message: messageData.message,
          messageDate: messageData.messageDate,
          profilePicture: messageData.profilePicture,
        ),
        SenderMessageTile(
          message: messageData.message,
          messageDate: messageData.messageDate,
          profilePicture: messageData.profilePicture,
        )
      ],
    );
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
  bool show = true;
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
                        widget.message + widget.message + widget.message,
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
                  child: Text(widget.messageDate.toString())
                      .animate()
                      .moveY(begin: 20, duration: 200.milliseconds),
                )
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
                                widget.message +
                                    widget.message +
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
                      child: Text(widget.messageDate.toString())
                          .animate()
                          .moveY(begin: 20, duration: 200.milliseconds))
              ],
            ),
          ),
        ));
  }
}
