import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mm_flutter_app/constants/app_constants.dart';
import 'edit_template.dart';

class EditOriginLocationScreen extends StatelessWidget {
  const EditOriginLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return EditTemplate(
      title: l10n.profileEditOriginLocation,
      body: const Padding(
        padding: EdgeInsets.all(Insets.paddingMedium),
        child: Column(
          children: [
            Placeholder(),
          ],
        ),
      ),
    );
  }
}