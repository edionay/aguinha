import 'package:aguinha/services/api.dart';
import 'package:aguinha/shared/common.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/shared/ui/subtitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsScreen extends StatefulWidget {
  static String id = 'settings_screen';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = '';

  @override
  void initState() {
    super.initState();
    API.getCurrentUserLocale().then((userLocale) {
      setState(() {
        selectedLanguage = userLocale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        elevation: 0,
        backgroundColor: kPrimaryColor,
        shape: Border.all(width: 0, color: kPrimaryColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/nav_background.svg',
            fit: BoxFit.fitWidth,
            alignment: Alignment.topLeft,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Subtitle(
                  title: AppLocalizations.of(context)!.language,
                  hint: AppLocalizations.of(context)!.languageHint,
                ),
                SizedBox(
                  height: kDefaultPadding * 2,
                ),
                TextButton(
                  onPressed: () {
                    API.setCurrentUserLocale('en_US');
                    setState(() {
                      selectedLanguage = 'en_US';
                    });
                  },
                  child: LanguageRadio(
                    label: 'english (Unites States)',
                    selected: selectedLanguage == 'en_US',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    API.setCurrentUserLocale('pt_BR');
                    setState(() {
                      selectedLanguage = 'pt_BR';
                    });
                  },
                  child: LanguageRadio(
                    label: 'portugues (Brasil)',
                    selected: selectedLanguage == 'pt_BR',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LanguageRadio extends StatelessWidget {
  const LanguageRadio({required this.label, required this.selected});

  final String label;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: selected ? kPrimaryColor : Colors.transparent,
          ),
          Text(
            label,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w100,
                color: selected ? kPrimaryColor : Colors.grey),
          )
        ],
      ),
    );
  }
}
