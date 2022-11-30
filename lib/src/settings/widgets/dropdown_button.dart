import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StyledDropdownContainer extends ConsumerWidget {
  const StyledDropdownContainer({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 300,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: child,
      ),
    );
  }
}
