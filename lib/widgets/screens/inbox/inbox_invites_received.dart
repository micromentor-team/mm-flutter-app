import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mm_flutter_app/constants/app_constants.dart';
import 'package:mm_flutter_app/providers/base/operation_result.dart';
import 'package:mm_flutter_app/providers/invitations_provider.dart';
import 'package:mm_flutter_app/utilities/router.dart';
import 'package:mm_flutter_app/utilities/utility.dart';
import 'package:mm_flutter_app/widgets/molecules/inbox_list_tile.dart';
import 'package:provider/provider.dart';

import '../../../__generated/schema/schema.graphql.dart';
import '../../../providers/models/scaffold_model.dart';
import '../../../providers/user_provider.dart';

class InboxInvitesReceivedScreen extends StatefulWidget {
  const InboxInvitesReceivedScreen({super.key});

  @override
  State<InboxInvitesReceivedScreen> createState() =>
      _InboxInvitesReceivedScreenState();
}

class _InboxInvitesReceivedScreenState extends State<InboxInvitesReceivedScreen>
    with RouteAwareMixin<InboxInvitesReceivedScreen> {
  late final InvitationsProvider _invitationsProvider;
  late Future<OperationResult<InvitationInbox>> _invitationInbox;

  static const int tabBarIndex = 0;

  @override
  void initState() {
    super.initState();
    _invitationsProvider = Provider.of<InvitationsProvider>(
      context,
      listen: false,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _invitationInbox = _invitationsProvider.getInboxInvitations();
  }

  void _refreshScaffold() {
    final ScaffoldModel scaffoldModel = Provider.of<ScaffoldModel>(
      context,
      listen: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scaffoldModel.setInboxScaffold(router: router);
    });
  }

  @override
  void didPush() {
    super.didPush();
    _refreshScaffold();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _refreshScaffold();
    try {
      DefaultTabController.of(context).animateTo(tabBarIndex);
    } catch (_) {
      // Can fail if the controller is no longer present in the context.
      // Revert to replacing the page with a new one.
      router.pushReplacement(Routes.inboxInvitesReceived.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _invitationInbox,
      builder: (context, snapshot) {
        return AppUtility.widgetForAsyncSnapshot(
          snapshot: snapshot,
          onReady: () {
            return InvitesReceivedList(
              pendingInvitations:
                  snapshot.data?.response?.channels?.pendingInvitations ?? [],
            );
          },
        );
      },
    );
  }
}

class InvitesReceivedList extends StatefulWidget {
  final List<ChannelPendingInvitation> pendingInvitations;

  const InvitesReceivedList({
    super.key,
    required this.pendingInvitations,
  });

  @override
  State<InvitesReceivedList> createState() => _InvitesReceivedListState();
}

class _InvitesReceivedListState extends State<InvitesReceivedList>
    with RouteAwareMixin<InvitesReceivedList> {
  late final UserProvider _userProvider;
  late Future<OperationResult<List<AllUsersWithFilterResult>>> _invitationUsers;
  late AppLocalizations _l10n;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _l10n = AppLocalizations.of(context)!;
    List<String> userIds = widget.pendingInvitations
        .map((e) => e.createdBy)
        .nonNulls
        .toList(growable: false);
    _invitationUsers = _userProvider.findUsersWithFilter(
      input: Input$UserListFilter(ids: userIds),
    );
  }

  InboxListTile _createTile(
    ChannelPendingInvitation invitation,
    AllUsersWithFilterResult sender,
  ) {
    return InboxListTile(
      avatarUrl: sender.avatarUrl,
      fullName: sender.fullName ?? '',
      date: invitation.createdAt,
      message: _l10n.inboxInvitesReceivedMessage,
      highlightMessage: true,
      simplifyDate: true,
      onPressed: () => router.push(
        Routes.inboxInvitesReceivedProfile.path,
      ), // TODO: Use InvitationID to route to correct invitation detail page.
    );
  }

  List<InboxListTile> _createTileList(
    List<AllUsersWithFilterResult> invitationSenders,
  ) {
    List<InboxListTile> tiles = [];
    for (ChannelPendingInvitation invitation in widget.pendingInvitations) {
      tiles.add(
        _createTile(
          invitation,
          invitationSenders.firstWhere((e) => e.id == invitation.createdBy),
        ),
      );
    }
    return tiles;
  }

  List<Widget> _createContentList(List<InboxListTile> tiles) {
    if (tiles.isEmpty) {
      return [];
    }
    List<Widget> contentList = [tiles.first];
    for (int i = 1; i < tiles.length; i++) {
      contentList.addAll([
        const Divider(
          height: 0,
          indent: Insets.paddingSmall,
        ),
        tiles[i],
      ]);
    }
    return contentList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _invitationUsers,
      builder: (context, snapshot) {
        return AppUtility.widgetForAsyncSnapshot(
          snapshot: snapshot,
          onReady: () {
            return Padding(
              padding: const EdgeInsetsDirectional.only(
                start: Insets.paddingSmall,
                end: Insets.paddingMedium,
              ),
              child: ListView(
                children: _createContentList(
                  _createTileList(snapshot.data?.response ?? []),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
