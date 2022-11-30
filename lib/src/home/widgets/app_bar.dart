import 'package:dropdown_search/dropdown_search.dart';
import 'package:excode/src/home/providers/editor_provider.dart';
import 'package:excode/src/home/providers/output_provider.dart';
import 'package:excode/src/home/services/api.dart';
import 'package:excode/src/home/services/language.dart';
import 'package:excode/src/home/widgets/input_dialog.dart';
import 'package:excode/src/home/widgets/snackbar.dart';
import 'package:excode/src/settings/providers/settings_provider.dart';
import 'package:excode/src/settings/providers/theme_provider.dart';
import 'package:excode/src/settings/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../helpers.dart';
import 'package:flutter/services.dart';

class AppBarWidget extends HookConsumerWidget with PreferredSizeWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    final editorLanguage = ref.watch(editorLanguageStateProvider);
    final globalTheme = ref.watch(themeStateProvider);

    return AppBar(
      leading: const Text(
        'Kano',
        style: TextStyle(fontSize: 23),
      ),
      title: DropdownSearch<Languages>(
        mode: Mode.MENU,
        popupBackgroundColor: globalTheme.primaryColor,
        showSearchBox: true,
        selectedItem: langMap[editorLanguage]!.lang,
        items: Languages.values,
        itemAsString: (Languages? e) => e.toString().substring(10).capitalize(),
        onChanged: (val) {
          final lang = ApiHandler.getNameFromLang(val!).match<String>(
            (l) => 'python',
            (r) => r,
          );

          ref.watch(editorLanguageStateProvider.notifier).setLanguage(lang);
          ref
              .watch(editorContentStateProvider.notifier)
              .setContent(const None(), lang);
        },
      ),
      automaticallyImplyLeading: false,
      actions: [
        SizedBox(
          width: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 0),
            child: ref.watch(outputIsLoadingProvider)
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow),
            onPressed: () async {
              await ref.watch(outputContentStateProvider.notifier).setOutput(
                    langMap[editorLanguage]!.lang,
                    ref.watch(editorContentStateProvider),
                  );
              ref.watch(outputIsVisibleStateProvider.notifier).showOutput();
              if (ref.watch(saveOnRunProvider)) {
                await ref
                    .watch(editorContentStateProvider.notifier)
                    .saveContent(
                      ref.read(editorLanguageStateProvider),
                      ref.read(editorContentStateProvider),
                    );
              }
            },
            onLongPress: () async {
              showDialog(
                context: context,
                builder: ((context) {
                  return const InputDialogWidget();
                }),
              );
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.restorablePushNamed(context, SettingsView.routeName);
          },
        ),
        Consumer(builder: (_, ref, __) {
          return PopupMenuButton<String>(itemBuilder: ((context) {
            return [
              PopupMenuItem(
                child: const Text('Clear'),
                onTap: () {
                  if (!ref.watch(lockProvider)) {
                    ref
                        .watch(editorContentStateProvider.notifier)
                        .setContent(const Some(''));
                  }
                },
              ),
              PopupMenuItem(
                child: const Text('Save'),
                onTap: () async {
                  await ref
                      .watch(editorContentStateProvider.notifier)
                      .saveContent(
                        ref.read(editorLanguageStateProvider),
                        ref.read(editorContentStateProvider),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                    content: 'Saved to local storage!',
                    state: ActionState.success,
                  ));
                },
              ),
            ];
          }));
        }),
      ],
    );
  }
}
