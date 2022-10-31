import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:messaging_app/chat.dart';
import 'package:faker/faker.dart';
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
            messageDate: date));
  }
}

class _MessageTitle extends StatelessWidget {
  const _MessageTitle({Key? key, required this.messageData}) : super(key: key);

  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(
          children: [
            Text(
              messageData.senderName,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ))
      ],
    );
  }
}
