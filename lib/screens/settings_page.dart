import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;
  final MaterialColor currentColor;
  final Function(MaterialColor) changeThemeColor;

  const SettingsPage({
    super.key,
    required this.isDarkMode,
    required this.toggleDarkMode,
    required this.currentColor,
    required this.changeThemeColor,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<MaterialColor> availableColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: widget.isDarkMode,
            onChanged: (value) {
              widget.toggleDarkMode(value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value ? 'Dark Mode Enabled' : 'Light Mode Enabled',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme Color'),
            subtitle: Text(widget.currentColor.toString().split('.').last),
            trailing: DropdownButton<MaterialColor>(
              value: widget.currentColor,
              items: availableColors.map((color) {
                return DropdownMenuItem<MaterialColor>(
                  value: color,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  widget.changeThemeColor(value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Theme Color Updated')),
                  );
                }
              },
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About App'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Weather Mood App',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.sunny),
                children: [
                  const Text(
                    'Developed by Group 9.\nThis app shows weather-based mood and outfit suggestions with forecasts.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
