import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:messaging_app/chat.dart';
import 'package:faker/faker.dart';
import 'package:messaging_app/models/message_data.dart';
import 'package:messaging_app/theme.dart';

import 'Widgets/helpers.dart';

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
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return Chat(messageData: messageData);
        }));
      },
      child: Container(
        height: 90,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        child: Row(children: [
          Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 55, 213, 249),
                          width: 5),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(messageData.profilePicture),
                          fit: BoxFit.fill)))),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  height: 22,
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: SizedBox(
                    height: 30,
                    child: Text(
                      messageData.message,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    )),
              ),
            ],
          )),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    Jiffy(messageData.messageDate).fromNow().toUpperCase(),
                    style: const TextStyle(
                        fontSize: 11.5,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textFaded),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                        color: AppColors.secondary, shape: BoxShape.circle),
                    child: const Center(
                      child: Text(
                        '1',
                        style:
                            TextStyle(fontSize: 12, color: AppColors.textLigth),
                      ),
                    ),
                  ),
                  const SizedBox(height: 23)
                ]),
          )
        ]),
      ),
    );
  }
}
