import 'package:flutter/material.dart';
import 'package:jaguar/pages/settings/settings_page.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsPage(),
          ),
        );
      },
      icon: Icon(
        Icons.settings_sharp,
        size: 30,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
