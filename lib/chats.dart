import 'package:flutter/material.dart';
import 'package:messaging_app/chat.dart';
import 'package:messaging_app/theme.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  late final channelListController = StreamChannelListController(
    client: StreamChatCore.of(context).client,
    filter: Filter.and([
      Filter.equal('type', 'messaging'),
      Filter.in_(
        'members',
        [
          StreamChatCore.of(context).currentUser!.id,
        ],
      ),
    ]),
  );

  @override
  void initState() {
    channelListController.doInitialLoad();
    super.initState();
  }

  @override
  void dispose() {
    channelListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PagedValueListenableBuilder<int, Channel>(
        valueListenable: channelListController,
        builder: (context, value, child) {
          return value.when(
            (channels, nextPageKey, error) => LazyLoadScrollView(
              onEndOfPage: () async {
                if (nextPageKey != null) {
                  channelListController.loadMore(nextPageKey);
                }
              },
              child: ListView.builder(
                /// We're using the channels length when there are no more
                /// pages to load and there are no errors with pagination.
                /// In case we need to show a loading indicator or and error
                /// tile we're increasing the count by 1.
                itemCount: (nextPageKey != null || error != null)
                    ? channels.length + 1
                    : channels.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == channels.length) {
                    if (error != null) {
                      return TextButton(
                        onPressed: () {
                          channelListController.retry();
                        },
                        child: Text(error.message),
                      );
                    }
                    return const CircularProgressIndicator();
                  }

                  final _item = channels[index];
                  return ListTile(
                    title: Text(_item.name ?? ''),
                    subtitle: StreamBuilder<Message?>(
                      stream: _item.state!.lastMessageStream,
                      initialData: _item.state!.lastMessage,
                      builder: (context, snapshot) {
                        return _MessageTitle(channel: _item);
                      },
                    ),
                    onTap: () {
                      // / Display a list of messages when the user taps on
                      // / an item. We can use [StreamChannel] to wrap our
                      // / [MessageScreen] screen with the selected channel.
                      // /
                      // / This allows us to use a built-in inherited widget
                      // / for accessing our `channel` later on.
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StreamChannel(
                            channel: _item,
                            child: Chat(channel: _item),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            loading: () => const Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e) => Center(
              child: Text(
                'Oh no, something went wrong. '
                'Please check your config. $e',
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MessageTitle extends StatefulWidget {
  const _MessageTitle({Key? key, required this.channel}) : super(key: key);

  final Channel channel;

  @override
  State<_MessageTitle> createState() => _MessageTitleState();
}

class _MessageTitleState extends State<_MessageTitle> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: otherUserImage == ""
                ? Container()
                : Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(otherUserImage),
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
                  otherUserName,
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
              child: SizedBox(height: 30, child: buildLastMessage()),
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
                _buildLastMessageAt(),
                const SizedBox(height: 10),
                Center(child: UnreadIndicator(channel: widget.channel)),
                const SizedBox(height: 23)
              ]),
        )
      ]),
    );
  }

  Widget buildLastMessage() {
    return BetterStreamBuilder(
        stream: widget.channel.state!.lastMessageStream,
        builder: (context, lastMessage) {
          return Text(lastMessage.text ?? "",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, color: AppColors.textFaded));
        });
  }

  Widget _buildLastMessageAt() {
    return BetterStreamBuilder<DateTime>(
      stream: widget.channel.lastMessageAtStream,
      initialData: widget.channel.lastMessageAt,
      builder: (context, data) {
        final lastMessageAt = data.toLocal();
        String stringDate;
        final now = DateTime.now();

        final startOfDay = DateTime(now.year, now.month, now.day);

        if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay.millisecondsSinceEpoch) {
          stringDate = Jiffy(lastMessageAt.toLocal()).jm;
        } else if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay
                .subtract(const Duration(days: 1))
                .millisecondsSinceEpoch) {
          stringDate = 'YESTERDAY';
        } else if (startOfDay.difference(lastMessageAt).inDays < 7) {
          stringDate = Jiffy(lastMessageAt.toLocal()).EEEE;
        } else {
          stringDate = Jiffy(lastMessageAt.toLocal()).yMd;
        }
        return Text(
          stringDate,
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: -0.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textFaded,
          ),
        );
      },
    );
  }
}

class UnreadIndicator extends StatelessWidget {
  const UnreadIndicator({
    Key? key,
    required this.channel,
  }) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: BetterStreamBuilder<int>(
        stream: channel.state!.unreadCountStream,
        initialData: channel.state!.unreadCount,
        builder: (context, data) {
          if (data == 0) {
            return const SizedBox.shrink();
          }
          return Material(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.secondary,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5,
                right: 5,
                top: 2,
                bottom: 1,
              ),
              child: Center(
                child: Text(
                  '${data > 99 ? '99+' : data}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
