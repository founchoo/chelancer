import 'package:chelancer/constant.dart';
import 'package:chelancer/view_model/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

class SettingsPage extends StatelessWidget {
  final SettingsViewModel viewModel;

  const SettingsPage(this.viewModel, {super.key});

  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return MVVM<SettingsViewModel>(
      view: () => const _SettingsView(),
      viewModel: viewModel,
    );
  }
}

class _SettingsView extends HookView<SettingsViewModel> {
  const _SettingsView() : super(reactive: true);

  @override
  Widget render(BuildContext context, SettingsViewModel viewModel) {
    const contentPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.pageName),
        forceMaterialTransparency: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              'Theme',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          SwitchListTile(
            contentPadding: contentPadding,
            secondary: const Icon(Icons.color_lens_outlined),
            title: const Text('System color'),
            subtitle: const Text('Toggle on to follow system color'),
            value: viewModel.isSysColor,
            onChanged: (bool value) {
              viewModel.setIsSysColor(value);
            },
          ),
          ListTile(
            contentPadding: contentPadding,
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Night mode'),
            trailing: DropdownButton<String>(
              style: Theme.of(context).textTheme.bodyMedium,
              underline: Container(),
              icon: Container(),
              value: viewModel.darkMode,
              onChanged: (String? value) {
                viewModel.setDarkMode(value!);
              },
              items: <String>['Follow system', 'On', 'Off'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              'About',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: appName,
            applicationVersion: appVersion,
          ),
        ],
      ),
    );
  }
}
