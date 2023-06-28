import 'package:flutter/material.dart';
import 'package:mm_flutter_app/__generated/schema/operations.graphql.dart';
import 'package:mm_flutter_app/data/models/messages/unseen_messages.dart';
import 'package:provider/provider.dart';

import '../../../data/models/channels/channel.dart';
import '../../../data/models/messages/messages_provider.dart';
import '../channel_messages/channel_messages.dart';

class MessagesList extends StatelessWidget {
  final Query$GetAuthenticatedUser$getAuthenticatedUser user;
  final List channels;

  const MessagesList({Key? key, required this.user, required this.channels})
      : super(key: key);

  String _channelName(Channel channel) {
    final participant =
        channel.participants.firstWhere((item) => item.id != user.id);
    return participant.fullName;
  }

  String _channelAvatarUrl(Channel channel) {
    String avatarUrl = channel.participants
        .where((element) => element.id != user.id)
        .first
        .avatarUrl;
    return avatarUrl;
  }

  List _channelUnseenMessage(unseenMessages, channel) {
    return unseenMessages
        .where((element) =>
            element.channelId == channel.id && element.createdBy != user.id)
        .toList();
  }

  _openChannelMessages({context, channelId}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChannelMessagesScreen(
              channelId: channelId,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final messagesProvider = Provider.of<MessagesProvider>(context);
    return messagesProvider.unseenMessages(
      onData: (data) {
        List unseenMessages =
            data.map((item) => UnseenMessages.fromJson(item)).toList();
        return ListView.separated(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => const Divider(
            height: 1.0,
          ),
          itemCount: channels.length,
          itemBuilder: (context, index) {
            Channel channel = channels[index];
            debugPrint('show channel');
            if (channel.participants.length > 1) {
              final channelName = _channelName(channel);
              final channelAvatarUrl = _channelAvatarUrl(channel);
              final channelUnseenMessages =
                  _channelUnseenMessage(unseenMessages, channel);

              return ListTile(
                dense: true,
                leading: CircleAvatar(
                    radius: 45,
                    child: ClipOval(
                      child: channelAvatarUrl.isNotEmpty
                          ? Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(channelAvatarUrl))
                          : const Icon(Icons.account_circle),
                    )),
                title: Text(channelName, style: const TextStyle(fontSize: 18)),
                trailing: channelUnseenMessages.isNotEmpty
                    ? Badge(
                        label: Center(
                            child:
                                Text(channelUnseenMessages.length.toString())),
                        backgroundColor: Colors.green,
                        alignment: AlignmentDirectional.center,
                      )
                    : const SizedBox(),
                onTap: () {
                  _openChannelMessages(
                    context: context,
                    channelId: channel.id,
                  );
                },
              );
            } else {
              return const Center(
                child: Text('You have not any messages'),
              );
            }
          },
        );
      },
    );
  }
}
