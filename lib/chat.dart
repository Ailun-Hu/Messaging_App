import 'package:flutter/material.dart';
import 'package:messaging_app/models/message_data.dart';
import 'package:messaging_app/theme.dart';

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
          message: widget.messageData.message,
          messageDate: widget.messageData.messageDate,
        ));
  }
}

class Messages extends StatelessWidget {
  const Messages({super.key, required this.message, required this.messageDate});
  final String message;
  final DateTime messageDate;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const _DateLabel(label: "Yesterday"),
        _MessageTile(
          message: message,
          messageDate: messageDate,
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

class _MessageTile extends StatelessWidget {
  const _MessageTile(
      {Key? key, required this.message, required this.messageDate})
      : super(key: key);
  final String message;
  final DateTime messageDate;
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
              Container(
                decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.all(Radius.circular(1))),
                child: Text(message),
              )
            ],
          ),
        ));
  }
}
