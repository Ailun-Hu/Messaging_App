import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:messaging_app/chat.dart';
import 'package:faker/faker.dart';
import 'package:messaging_app/main.dart';
import 'package:messaging_app/models/message_data.dart';

import 'Widgets/Helpers.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(_delagate),
        )
      ],
    );
  }

  Widget _delagate(BuildContext context, int index) {
    final Faker faker = Faker();
    final date = Helpers.randomDate();
    return _MessageTitle(
        messageData: MessageData(
      senderName: faker.person.name(),
      message: faker.lorem.sentence(),
      dataMessage: Jiffy(date).fromNow(),
      profilePicture: Helpers.randomPictureUrl(),
      messageDate: date,
    ));
  }
}

class _MessageTitle extends StatelessWidget {
  const _MessageTitle({Key? key, required this.messageData}) : super(key: key);

  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 55, 213, 249), width: 5),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(messageData.profilePicture),
                      fit: BoxFit.fill)))),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              messageData.senderName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 18,
                  letterSpacing: 0.2,
                  wordSpacing: 1.5,
                  fontWeight: FontWeight.w900),
            ),
          ),
          SizedBox(
              height: 20,
              child: Text(
                messageData.message,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              )),
        ],
      ))
    ]);
    // Row(
    //   children: [
    //     Expanded(
    //         child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Container(
    //           padding: const EdgeInsets.only(left: 5),
    //           child: Container(
    //               width: 75,
    //               height: 75,
    //               decoration: BoxDecoration(
    //                 border: Border.all(
    //                     color: const Color.fromARGB(255, 55, 213, 249),
    //                     width: 5),
    //                 shape: BoxShape.circle,
    //                 image: DecorationImage(
    //                     image: NetworkImage(messageData.profilePicture),
    //                     fit: BoxFit.fill),
    //               )),
    //         ),
    //         Text(
    //           messageData.senderName,
    //           overflow: TextOverflow.ellipsis,
    //         )
    //       ],
    //     ))
    //   ],
    // );
  }
}
