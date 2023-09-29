import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:mm_flutter_app/widgets/screens/sign_up/sign_up_template.dart';
import '../../../constants/app_constants.dart';
import 'sign_up_bottom_buttons.dart';

class SignupBusinessMoreInfoScreen extends StatefulWidget {
  const SignupBusinessMoreInfoScreen({Key? key}) : super(key: key);

  @override
  State<SignupBusinessMoreInfoScreen> createState() =>
      _SignupBusinessMoreInfoScreenState();
}

class _SignupBusinessMoreInfoScreenState
    extends State<SignupBusinessMoreInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return SignUpTemplate(
      progress: SignUpProgress.one,
      title: l10n.needLittleMoreInfo,
      bottomButtons: SignUpBottomButtons(
          leftButtonText: l10n.findMentors,
          rightButtonText: l10n.continueButton,
          leftOnPress: () {
            context.pop();
          },
          rightOnPress: () {
            context.push(Routes.addProfilePicture.path);
          }),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: Insets.paddingMedium),
            child: Text(
              l10n.moreInfoPrompt,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: Insets.paddingMedium),
            child: Text(
              l10n.readyToBrowseMentorsPrompt,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}