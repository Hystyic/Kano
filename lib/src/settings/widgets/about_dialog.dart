import 'package:flutter/material.dart';

class AboutDialogWidget extends StatelessWidget {
  const AboutDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AboutDialog(
      applicationName: 'Kano',
      children: [
        Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: Text('Kano - Code Editor Built by Team PR-3'),
        )
      ],
    );
  }
}
