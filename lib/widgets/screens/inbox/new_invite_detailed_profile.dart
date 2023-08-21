import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:mm_flutter_app/__generated/schema/operations_invitation.graphql.dart';
import 'package:mm_flutter_app/constants/app_constants.dart';
import 'package:mm_flutter_app/providers/base/operation_result.dart';
import 'package:mm_flutter_app/providers/invitations_provider.dart';
import 'package:mm_flutter_app/utilities/router.dart';
import 'package:mm_flutter_app/utilities/utility.dart';
import 'package:mm_flutter_app/widgets/atoms/skill_chip.dart';
import 'package:mm_flutter_app/widgets/molecules/profile_quick_view_card.dart';
import 'package:provider/provider.dart';

import '../../../providers/models/scaffold_model.dart';

class NewInviteDetailedProfile extends StatefulWidget {
  final String channelInvitationId;
  const NewInviteDetailedProfile({
    super.key,
    required this.channelInvitationId,
  });

  @override
  State<NewInviteDetailedProfile> createState() =>
      _NewInviteDetailedProfileState();
}

class _NewInviteDetailedProfileState extends State<NewInviteDetailedProfile>
    with RouteAwareMixin<NewInviteDetailedProfile> {
  late final InvitationsProvider _invitationsProvider;
  late Future<OperationResult<ChannelInvitationById>> _invitation;
  late AppLocalizations _l10n;

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
    _invitation = _invitationsProvider.findChannelInvitationById(
      channelInvitationId: widget.channelInvitationId,
    );
    _l10n = AppLocalizations.of(context)!;
  }

  Widget _createCard(ChannelInvitationById invitation) {
    return createProfilCardFromInfoAndCheckbox(
      info: ProfileQuickViewInfo(
        isRecommended: false,
        userType: invitation.sender.offersHelp
            ? UserType.mentor
            : UserType.entrepreneur,
        avatarUrl: invitation.sender.avatarUrl,
        fullName: invitation.sender.fullName ?? '',
        location: invitation.sender.countryOfResidence?.translatedValue ??
            _l10n.defaultValueLocation,
        company: invitation.sender.companies.firstOrNull?.name,
        companyRole: invitation.sender.jobTitle,
        endorsements: invitation.sender.groupMemberships
            .firstWhere((element) => element.groupIdent == GroupIdent.mentors)
            .maybeWhen(
              mentorsGroupMembership: (g) => g.endorsements,
              orElse: () => 0,
            ),
        skills: invitation.sender.groupMemberships
            .firstWhere((element) => element.groupIdent == GroupIdent.mentors)
            .maybeWhen(
              mentorsGroupMembership: (g) => g.expertises
                  .map((e) => SkillChip(skill: e.translatedValue!))
                  .toList(),
              orElse: () => [],
            ),
      ),
    );
  }

  Widget _createDateDivider(ThemeData theme, String date) {
    return Padding(
      padding: const EdgeInsets.all(Insets.paddingMedium),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Text(
            date,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget _createMessagePopup(ThemeData theme, String messageText, String time) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.paddingExtraLarge, 0,
          Insets.paddingExtraLarge, Insets.paddingExtraLarge),
      child: SizedBox(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer,
            borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.zero,
                topEnd: Radius.circular(Radii.roundedRectRadiusMedium),
                bottomStart: Radius.circular(Radii.roundedRectRadiusMedium),
                bottomEnd: Radius.circular(Radii.roundedRectRadiusMedium)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              Insets.paddingSmall,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(messageText),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(time),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createDeclineAcceptButtons(
    ThemeData theme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Dimensions.bigButtonSize,
            backgroundColor: theme.colorScheme.surface,
            textStyle: theme.textTheme.labelLarge,
          ),
          onPressed: () {},
          child: Text(
            _l10n.decline,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: Insets.paddingMedium),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Dimensions.bigButtonSize,
            backgroundColor: theme.colorScheme.primary,
            textStyle: theme.textTheme.labelLarge,
          ),
          onPressed: () {},
          child: Text(
            _l10n.accept,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        )
      ],
    );
  }

  void _refreshScaffold() {
    final ScaffoldModel scaffoldModel = Provider.of<ScaffoldModel>(
      context,
      listen: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scaffoldModel.setInviteReceivedDetailScaffold(context: context);
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
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FutureBuilder(
      future: _invitation,
      builder: (context, snapshot) {
        return AppUtility.widgetForAsyncSnapshot(
          snapshot: snapshot,
          onReady: () {
            final ChannelInvitationById invitationResult =
                snapshot.data!.response!;
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _createCard(invitationResult),
                      _createDateDivider(
                        theme,
                        AppUtility.simplePastDateFormat(
                          context,
                          invitationResult.createdAt,
                        ),
                      ),
                      _createMessagePopup(
                        theme,
                        invitationResult.messageText!,
                        DateFormat.jm()
                            .format(invitationResult.createdAt)
                            .toLowerCase(),
                      ),
                      _createDeclineAcceptButtons(theme),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
