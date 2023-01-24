import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class AddUserListPage extends StatefulWidget {
  const AddUserListPage({super.key});

  @override
  State<AddUserListPage> createState() => _AddUserListPageState();
}

class _AddUserListPageState extends State<AddUserListPage> {
  late final userListController = StreamUserListController(
      client: StreamChatCore.of(context).client,
      filter: Filter.and([
        Filter.notEqual('id', StreamChatCore.of(context).currentUser!.id),
        Filter.notExists('dashboard_user')
      ]));

  @override
  void initState() {
    userListController.doInitialLoad();
    super.initState();
  }

  @override
  void dispose() {
    userListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PagedValueListenableBuilder<int, User>(
          valueListenable: userListController,
          builder: (context, value, child) {
            return value.when(
              (users, nextPageKey, error) => LazyLoadScrollView(
                onEndOfPage: () async {
                  if (nextPageKey != null) {
                    userListController.loadMore(nextPageKey);
                  }
                },
                child: ListView.builder(
                  /// We're using the users length when there are no more
                  /// pages to load and there are no errors with pagination.
                  /// In case we need to show a loading indicator or and error
                  /// tile we're increasing the count by 1.
                  itemCount: (nextPageKey != null || error != null)
                      ? users.length + 1
                      : users.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == users.length) {
                      if (error != null) {
                        return TextButton(
                          onPressed: () {
                            userListController.retry();
                          },
                          child: Text(error.message),
                        );
                      }
                      return const CircularProgressIndicator();
                    }

                    final _item = users[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 95),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(_item.image!)))),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              _item.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
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
