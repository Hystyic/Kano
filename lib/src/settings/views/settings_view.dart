import 'package:excode/src/home/providers/editor_provider.dart';
import 'package:excode/src/home/services/language.dart';
import 'package:excode/src/settings/providers/theme_provider.dart';
import 'package:excode/src/settings/widgets/dropdown_button.dart';
import 'package:excode/src/settings/widgets/font_size_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../helpers.dart';

class SettingsView extends HookConsumerWidget {
  const SettingsView({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = useState(ThemeMode.system);
    final editorTheme = ref.watch(editorThemeStateProvider);
    final globalTheme = ref.watch(themeStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  //const AuthContainerWidget(),
                  //const Divider(),
                  ListTile(
                    leading: const Icon(Icons.palette),
                    title: const Text('Theme'),
                    trailing: StyledDropdownContainer(
                      child: DropdownButton<ThemeMode>(
                        dropdownColor: globalTheme.primaryColor,
                        focusColor: globalTheme.secondaryColor,
                        isExpanded: true,
                        onChanged: ((val) {
                          theme.value = val!;
                          ref
                              .watch(themeStateProvider.notifier)
                              .changeTheme(theme.value);
                        }),
                        value: theme.value,
                        items: ThemeMode.values
                            .map((e) => DropdownMenuItem(
                                  child: Text(e.name.capitalize()),
                                  value: e,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.palette_outlined),
                    title: const Text('Editor theme'),
                    trailing: StyledDropdownContainer(
                      child: DropdownButton<Themes>(
                        dropdownColor: globalTheme.primaryColor,
                        focusColor: globalTheme.secondaryColor,
                        isExpanded: true,
                        onChanged: (value) async {
                          await ref
                              .watch(editorThemeStateProvider.notifier)
                              .setTheme(value!.name);
                        },
                        value: getEnumFromString(editorTheme),
                        items: Themes.values
                            .map((val) => DropdownMenuItem(
                                  child: Text(val.name.capitalize()),
                                  value: val,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(Icons.font_download),
                    title: Text('Font size'),
                    trailing: FontSizeButtonWidget(),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(
              child: Text('Kano - Code Editor Built by Team PR-3'),
            )
          ],
        ),
      ),
    );
  }
}
