import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:mm_flutter_app/constants/app_constants.dart';
import 'package:mm_flutter_app/widgets/screens/sign_up/sign_up_icon_footer.dart';
import 'package:mm_flutter_app/widgets/screens/sign_up/sign_up_template.dart';
import 'sign_up_bottom_buttons.dart';

class SignupMentorInternationallyScreen extends StatefulWidget {
  const SignupMentorInternationallyScreen({Key? key}) : super(key: key);

  @override
  State<SignupMentorInternationallyScreen> createState() =>
      _SignupMentorInternationallyScreenState();
}

class _SignupMentorInternationallyScreenState
    extends State<SignupMentorInternationallyScreen> {
  String? _selection;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return SignUpTemplate(
      progress: SignUpProgress.three,
      title: l10n.wantToMentorInternationally,
      bottomButtons: SignUpBottomButtons(
          leftButtonText: l10n.previous,
          rightButtonText: l10n.next,
          leftOnPress: () {
            context.pop();
          },
          rightOnPress: () {
            context.push(Routes.signupMentorCompleted.path);
          }),
      footer: SignUpIconFooter(
          icon: Icons.lock_outline, text: l10n.signUpHiddenInfoDesc),
      body: Column(
        children: [
          Text(
            l10n.openToMentorInternationally,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.secondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Insets.paddingLarge),
          Column(
            children: [
              ListTile(
                  title: Text(
                    l10n.openToTalkingToAnyone,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  trailing: Radio<String>(
                    value: l10n.openToTalkingToAnyone,
                    groupValue: _selection,
                    onChanged: (String? value) {
                      setState(() {
                        _selection = value;
                      });
                    },
                  )),
              ListTile(
                  title: Text(
                    l10n.onlyTalkToSameCountryEntrepreneurs,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  trailing: Radio<String>(
                    value: l10n.onlyTalkToSameCountryEntrepreneurs,
                    groupValue: _selection,
                    onChanged: (String? value) {
                      setState(() {
                        _selection = value;
                      });
                    },
                  )),
            ],
          )
        ],
      ),
    );
  }
}
