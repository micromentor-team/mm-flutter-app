import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mm_flutter_app/constants/app_constants.dart';
import 'package:mm_flutter_app/widgets/atoms/inbox_list_tile.dart';

class InboxInvitesSentScreen extends StatelessWidget {
  const InboxInvitesSentScreen({super.key});

  InboxListTile _createTestTile(
    BuildContext context,
    AppLocalizations l10n,
    int tileIndex,
  ) {
    // TODO(m-rosario): Replace mock data with backend data.
    final DateTime date = DateTime.now()
        .subtract(Duration(days: tileIndex * pow(1.4, tileIndex).floor()));
    return InboxListTile(
      avatarUrl:
          'https://media.istockphoto.com/id/1160811064/photo/portrait-of-a-handsome-latin-man.jpg?s=612x612&w=0&k=20&c=MxkLwUFZ9ChfzFdB-OmmiWBnZrSioj9MmfSdlwCk4-4=',
      fullName: 'Antoine Mousa',
      date: date,
      simplifyDate: true,
      datePrefix: l10n.inboxInvitesDateSent,
    );
  }

  List<InboxListTile> _createTestTiles(
      BuildContext context, AppLocalizations l10n) {
    List<InboxListTile> tiles = [];
    for (int i = 0; i <= 12; i++) {
      tiles.add(
        _createTestTile(context, l10n, i),
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
          indent: Insets.widgetSmallInset,
        ),
        tiles[i],
      ]);
    }
    return contentList;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: Insets.widgetSmallInset,
          end: Insets.widgetMediumInset,
        ),
        child: ListView(
          children: _createContentList(
            _createTestTiles(context, l10n),
          ),
        ),
      ),
    );
  }
}
