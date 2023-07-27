import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:mm_flutter_app/constants/app_constants.dart';
import 'package:mm_flutter_app/widgets/atoms/autocomplete_widget.dart';
import 'package:mm_flutter_app/providers/explore_card_filters_provider.dart';

class RecommendedMentorsFilters extends StatefulWidget {
  final ExploreCardFiltersProvider filtersProvider;

  const RecommendedMentorsFilters({super.key, required this.filtersProvider});

  @override
  State<StatefulWidget> createState() => _RecommendedMentorsFilters();
}

class _RecommendedMentorsFilters extends State<RecommendedMentorsFilters> {
  late final TextfieldTagsController _countriesController;
  late final TextfieldTagsController _languagesController;
  Set<String> _selectedSkills = {};

  @override
  void initState() {
    super.initState();
    _countriesController = TextfieldTagsController();
    _languagesController = TextfieldTagsController();
    _selectedSkills = widget.filtersProvider.selectedSkills;
  }

  @override
  void dispose() {
    _countriesController.dispose();
    _languagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.exploreSearchFilterTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(children: [
              _Expertise(skills: _selectedSkills),
              _AutocompletePicker(
                fieldName: "Language",
                controller: _languagesController,
                options: ExploreCardFiltersProvider.languages,
                optionsTranslations: l10n.exploreSearchFilterLanguages,
                selectedOptions: widget.filtersProvider.selectedLanguages,
              ),
              _AutocompletePicker(
                fieldName: "Countries",
                controller: _countriesController,
                options: ExploreCardFiltersProvider.countries,
                optionsTranslations: l10n.exploreSearchFilterCountries,
                selectedOptions: widget.filtersProvider.selectedCountries,
              ),
            ]),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.tune),
                label: Text(l10n.exploreSearchFilterAdvancedFilters),
                onPressed: null,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Dimensions.bigButtonSize,
                  ),
                  child: Text(l10n.exploreSearchFilterClear,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(color: theme.colorScheme.secondary)),
                  onPressed: () {
                    setState(() {
                      _countriesController.clearTags();
                      _languagesController.clearTags();
                      _selectedSkills.clear();
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Dimensions.bigButtonSize,
                    backgroundColor: theme.colorScheme.surface,
                    disabledBackgroundColor: theme.colorScheme.surface,
                    textStyle: theme.textTheme.labelLarge,
                  ),
                  child: Text(l10n.exploreSearchFilterApply,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(color: theme.colorScheme.primary)),
                  onPressed: () {
                    widget.filtersProvider.setAll(
                        _countriesController.getTags?.toSet() ?? {},
                        _languagesController.getTags?.toSet() ?? {},
                        _selectedSkills);

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Expertise extends StatefulWidget {
  final Set<String> skills;

  const _Expertise({required this.skills});

  @override
  State<StatefulWidget> createState() => _ExpertiseState();
}

class _ExpertiseState extends State<_Expertise> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    var skillButtons = [];
    for (int i = 0; i < ExploreCardFiltersProvider.skills.length; i++) {
      var skill = ExploreCardFiltersProvider.skills[i];
      var isSelected = widget.skills.contains(skill);

      skillButtons.add(OutlinedButton(
        onPressed: () {
          setState(() {
            if (isSelected) {
              widget.skills.remove(skill);
            } else {
              widget.skills.add(skill);
            }
          });
        },
        style: ButtonStyles.primaryRoundedRectangleButton(context).copyWith(
          backgroundColor: MaterialStatePropertyAll(
              (isSelected) ? theme.colorScheme.onInverseSurface : Colors.white),
        ),
        child: Text(l10n.exploreSearchFilterSkills(skill),
            style: const TextStyle(color: Colors.black)),
      ));
      if (i != ExploreCardFiltersProvider.skills.length - 1) {
        skillButtons.add(const SizedBox(width: 4));
      }
    }

    bool allSkillsSelected =
        setEquals(widget.skills, ExploreCardFiltersProvider.skills.toSet());

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.exploreSearchFilterExpertise),
              const SizedBox(height: 4),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            if (allSkillsSelected) {
                              widget.skills.clear();
                            } else {
                              widget.skills.clear();
                              widget.skills
                                  .addAll(ExploreCardFiltersProvider.skills);
                            }
                          });
                        },
                        style:
                            ButtonStyles.primaryRoundedRectangleButton(context)
                                .copyWith(
                          backgroundColor: MaterialStatePropertyAll(
                            (allSkillsSelected)
                                ? theme.colorScheme.onInverseSurface
                                : Colors.white,
                          ),
                        ),
                        child: Text(l10n.exploreSearchFilterAll,
                            style: const TextStyle(color: Colors.black)),
                      ),
                      const VerticalDivider(),
                      ...skillButtons,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class _AutocompletePicker extends StatelessWidget {
  final TextfieldTagsController controller;
  final String fieldName;
  final List<String> options;
  final String Function(String)? optionsTranslations;
  final Set<String>? selectedOptions;

  const _AutocompletePicker({
    required this.fieldName,
    required this.controller,
    required this.options,
    this.optionsTranslations,
    this.selectedOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fieldName),
            const SizedBox(height: 4),
            AutocompleteWidget(
              options: options.toList(),
              optionsTranslations: optionsTranslations,
              selectedOptions: selectedOptions?.toList() ?? [],
              controller: controller,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ]);
  }
}
