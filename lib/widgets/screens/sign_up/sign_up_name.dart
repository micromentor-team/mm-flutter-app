import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:mm_flutter_app/constants/app_constants.dart';
import 'package:mm_flutter_app/widgets/screens/sign_up/sign_up_bottom_buttons.dart';
import 'package:mm_flutter_app/widgets/screens/sign_up/sign_up_icon_footer.dart';
import 'package:mm_flutter_app/widgets/screens/sign_up/sign_up_template.dart';

import '../../atoms/text_form_field_widget.dart';

class SignUpName extends StatefulWidget {
  const SignUpName({super.key});

  @override
  State<SignUpName> createState() => _SignUpNameState();
}

class _SignUpNameState extends State<SignUpName> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return SignUpTemplate(
      progress: SignUpProgress.one,
      title: l10n.signupNameTitle,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormFieldWidget(
              label: l10n.signupNameFirstInputLabel,
              hint: l10n.signupNameFirstInputHint,
              maxLength: 50,
              onChanged: (value) {
                setState(() {
                  _firstName = value;
                });
              },
            ),
            const SizedBox(
              height: Insets.paddingSmall,
            ),
            TextFormFieldWidget(
              label: l10n.signupNameLastInputLabel,
              hint: l10n.signupNameLastInputHint,
              maxLength: 50,
              onChanged: (value) {
                setState(() {
                  _lastName = value;
                });
              },
            )
          ],
        ),
      ),
      footer: SignUpIconFooter(
          icon: Icons.visibility_outlined, text: l10n.signUpVisibleInfoDesc),
      bottomButtons: SignUpBottomButtons(
        leftButtonText: l10n.previous,
        rightButtonText: l10n.next,
        leftOnPress: () {
          context.pop();
        },
        rightOnPress: (_firstName?.isNotEmpty ?? false) &&
                (_lastName?.isNotEmpty ?? false)
            ? () {
                if (_formKey.currentState!.validate()) {
                  context.push(Routes.signupPhoneNumber.path);
                }
              }
            : null,
      ),
    );
  }
}