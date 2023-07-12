import 'package:flutter/material.dart';
import 'package:mm_flutter_app/providers/channels_provider.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import 'messages_list.dart';

class ChannelsScreen extends StatelessWidget {
  const ChannelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text('Messages',
            style: TextStyle(color: Colors.deepPurpleAccent)),
      ),
      body: const SafeArea(
        child: ChannelsList(),
      ),
    );
  }
}

class ChannelsList extends StatelessWidget {
  const ChannelsList({super.key});

  @override
  Widget build(BuildContext context) {
    final channelsProvider = Provider.of<ChannelsProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return channelsProvider.queryUserChannels(
      userId: user!.id,
      onData: (data, {refetch, fetchMore}) {
        return MessagesList(user: user, channels: data.response!);
      },
    );
  }
}
