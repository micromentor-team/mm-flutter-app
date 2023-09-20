import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:mm_flutter_app/constants/app_constants.dart';
import 'package:mm_flutter_app/providers/channels_provider.dart';
import 'package:mm_flutter_app/utilities/emoji_utils/emoji_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../providers/messages_provider.dart';
import 'reply_message.dart';

class MessageBubble extends StatelessWidget {
  final List<ChannelParticipant> participants;
  final ChannelMessage message;
  final ChannelMessage? replyingTo;
  final bool isDeleted;
  final bool isSentByAuthenticatedUser;

  const MessageBubble({
    super.key,
    required this.message,
    required this.participants,
    this.replyingTo,
    required this.isDeleted,
    required this.isSentByAuthenticatedUser,
  });

  Future<void> _onOpenLink(LinkableElement link) async {
    try {
      if (await canLaunchUrl(link.url as Uri)) {
        await launchUrl(link.url as Uri);
      } else {
        throw 'Could not launch $link';
      }
    } catch (error) {
      debugPrint('$error');
    }
  }

  String _participantName({userId}) {
    final ChannelParticipant? participant =
        participants.where((item) => item.user.id == userId).firstOrNull;
    if (participant != null) {
      return participant.user.fullName!
          .trim()
          .split(RegExp(' +'))
          .take(1)
          .join();
    }
    return '';
  }

  Widget _buildMessageStatus(
      AppLocalizations l10n, ThemeData theme, bool isUser) {
    String? status;
    if (isDeleted) {
      if (isUser) {
        status = l10n.messagesStatusDeleted;
      }
    } else if (message.editedAt != null) {
      status = l10n.messagesStatusEdited;
    }

    if (status != null) {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: Insets.paddingSmall,
        ),
        child: Text(
          status,
          style: theme.textTheme.labelSmall?.copyWith(
            fontStyle: FontStyle.italic,
            color: theme.colorScheme.outline,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildMessageText(AppLocalizations l10n, ThemeData theme, isUser) {
    final isEmoji = EmojiUtils.isOnlyEmoji(message.messageText!) &&
        message.replyToMessageId == null;
    if (isDeleted && !isUser) {
      return Text(
        l10n.messagesStatusDeleted,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
          color: theme.colorScheme.outline,
        ),
      );
    } else {
      return SelectableLinkify(
        text: message.messageText!,
        onOpen: (link) => _onOpenLink(link),
        linkStyle: theme.textTheme.bodyMedium?.copyWith(
          color: isUser
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onTertiaryContainer,
        ),
        textAlign: isEmoji && isUser ? TextAlign.end : null,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: isEmoji ? theme.textTheme.displayMedium?.fontSize : null,
          decoration: isDeleted ? TextDecoration.lineThrough : null,
          color: isUser
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onTertiaryContainer,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sentAt =
        DateFormat.jm().format(message.createdAt.toLocal()).toLowerCase();
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.paddingExtraSmall),
      child: Container(
        constraints: BoxConstraints(
          minWidth: 80,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Material(
          elevation: Elevations.level1,
          borderRadius: BorderRadiusDirectional.only(
            topStart: isSentByAuthenticatedUser
                ? const Radius.circular(
                    Radii.roundedRectRadiusSmall,
                  )
                : Radius.zero,
            topEnd: isSentByAuthenticatedUser
                ? Radius.zero
                : const Radius.circular(
                    Radii.roundedRectRadiusSmall,
                  ),
            bottomStart: const Radius.circular(
              Radii.roundedRectRadiusSmall,
            ),
            bottomEnd: const Radius.circular(
              Radii.roundedRectRadiusSmall,
            ),
          ),
          color: isSentByAuthenticatedUser
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.tertiaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(Insets.paddingSmall),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (participants.length > 2)
                          Text(
                            _participantName(userId: message.createdBy),
                            style: theme.textTheme.labelSmall?.copyWith(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        _buildMessageStatus(
                            l10n, theme, isSentByAuthenticatedUser),
                      ],
                    ),
                    if (replyingTo != null && !isDeleted)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: Insets.paddingSmall,
                        ),
                        child: ReplyMessage(
                          replyMessage: replyingTo!,
                          participants: participants,
                        ),
                      ),
                    _buildMessageText(l10n, theme, isSentByAuthenticatedUser),
                    if (!isDeleted || isSentByAuthenticatedUser)
                      const SizedBox(
                        height: Insets.paddingLarge,
                      ),
                  ],
                ),
                if (!isDeleted || isSentByAuthenticatedUser)
                  PositionedDirectional(
                    bottom: 0,
                    end: isSentByAuthenticatedUser ? null : 0,
                    start: isSentByAuthenticatedUser ? 0 : null,
                    child: Text(
                      sentAt,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
