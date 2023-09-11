import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mm_flutter_app/constants/app_constants.dart';
import 'package:mm_flutter_app/providers/models/inbox_chat_tile_model.dart';
import 'package:mm_flutter_app/utilities/errors/crash_handler.dart';
import 'package:mm_flutter_app/utilities/errors/exceptions.dart';
import 'package:mm_flutter_app/utilities/utility.dart';
import 'package:mm_flutter_app/widgets/atoms/empty_state_message.dart';
import 'package:mm_flutter_app/widgets/screens/inbox/dismissible_tile.dart';
import 'package:mm_flutter_app/widgets/screens/inbox/inbox_chat_list_tile.dart';
import 'package:provider/provider.dart';

import '../../../providers/channels_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../utilities/navigation_mixin.dart';

class InboxChatListScreen extends StatefulWidget {
  final bool isArchivedForUser;

  const InboxChatListScreen({
    super.key,
    required this.isArchivedForUser,
  });

  @override
  State<InboxChatListScreen> createState() => _InboxChatListScreenState();
}

class _InboxChatListScreenState extends State<InboxChatListScreen>
    with NavigationMixin<InboxChatListScreen> {
  late final AuthenticatedUser? _authenticatedUser;
  late final ChannelsProvider _channelsProvider;
  late Future<List<ChannelForUser>> _userChannels;
  late AppLocalizations _l10n;

  @override
  void initState() {
    super.initState();
    _authenticatedUser = Provider.of<UserProvider>(context, listen: false).user;
    _channelsProvider = Provider.of<ChannelsProvider>(
      context,
      listen: false,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!pageRoute.isCurrent) return;
    _l10n = AppLocalizations.of(context)!;
    _queryUserChannels();
  }

  void _queryUserChannels() {
    _userChannels = _channelsProvider
        .queryUserChannels(userId: _authenticatedUser!.id)
        .then((result) {
      return result.response?.where(
            (element) {
              return widget.isArchivedForUser == element.isArchivedForMe;
            },
          ).toList() ??
          [];
    });
  }

  List<Widget> _createContentList(
    List<ChannelForUser> channels,
  ) {
    final List<DismissibleTile> tiles = [];

    // Sort channels by latestMessage creation time, starting from most recent
    channels.sort(
      (a, b) => b.latestMessage.createdAt
          .toLocal()
          .compareTo(a.latestMessage.createdAt.toLocal()),
    );

    for (int i = 0; i < channels.length; i++) {
      final ChannelForUser channel = channels[i];
      final ChannelForUserParticipant otherParticipant = channel.participants
          .firstWhere((item) => item.user.id != _authenticatedUser!.id);
      final String channelName = otherParticipant.user.fullName!;
      final String? channelAvatarUrl = otherParticipant.user.avatarUrl;

      tiles.add(
        DismissibleTile(
          tileId: channel.id,
          onDismissed: () async {
            int tileIndexToRemove = -1;
            for (int i = 0; i < tiles.length; i++) {
              if (tiles[i].tileId == channel.id) {
                tileIndexToRemove = i;
                break;
              }
            }
            tiles.removeAt(tileIndexToRemove);
            if (widget.isArchivedForUser) {
              _channelsProvider.unarchiveChannelForAuthenticatedUser(
                channelId: channel.id,
              );
            } else {
              _channelsProvider.archiveChannelForAuthenticatedUser(
                channelId: channel.id,
              );
            }
            // Refresh Scaffold and channels only once the change is live.
            final bool updateCompleted =
                await CrashHandler.retryOnException<bool>(
              () async {
                final result = await _channelsProvider.findChannelById(
                    channelId: channel.id);
                final bool? isArchived = result.response?.isArchivedForMe;
                if (isArchived == null ||
                    isArchived == widget.isArchivedForUser) {
                  throw RetryException(
                    message: 'Waiting for isArchivedForMe to update...',
                  );
                }
                return true;
              },
              onFailOperation: () => false,
              logFailures: false,
            );
            if (updateCompleted) {
              buildPageRouteScaffold((scaffoldModel) {
                scaffoldModel.setInboxScaffold(router: router);
              });
              _queryUserChannels();
              setState(() {});
            }
          },
          icon: widget.isArchivedForUser
              ? Icons.unarchive_outlined
              : Icons.archive_outlined,
          child: ChangeNotifierProvider(
            create: (context) => InboxChatTileModel(
              context: context,
              channelId: channels[i].id,
              channelName: channelName,
              channelAvatarUrl: channelAvatarUrl,
              authenticatedUserId: _authenticatedUser!.id,
              isArchivedChannel: widget.isArchivedForUser,
            ),
            child: InboxChatListTile(
              isArchivedForUser: widget.isArchivedForUser,
            ),
          ),
        ),
      );
    }

    List<Widget> contentList = [tiles.first];
    for (int i = 1; i < tiles.length; i++) {
      contentList.addAll([
        const Divider(
          height: 0,
          indent: Insets.paddingMedium,
          endIndent: Insets.paddingMedium,
        ),
        tiles[i],
      ]);
    }
    return contentList;
  }

  @override
  Widget build(BuildContext context) {
    if (!pageRoute.isCurrent) return const SizedBox.shrink();
    buildPageRouteScaffold((scaffoldModel) {
      scaffoldModel.setInboxScaffold(router: router);
    });
    return FutureBuilder(
      future: _userChannels,
      builder: (context, snapshot) {
        return AppUtility.widgetForAsyncSnapshot(
          snapshot: snapshot,
          onReady: () {
            final List<ChannelForUser> channels = snapshot.data ?? [];
            if (channels.isEmpty) {
              return EmptyStateMessage(
                icon: Icons.chat,
                text: _l10n.emptyStateChats,
              );
            }
            return ListView(
              children: _createContentList(
                channels,
              ),
            );
          },
        );
      },
    );
  }
}
