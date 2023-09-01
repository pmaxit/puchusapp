import 'package:flutter/material.dart';

class RadioWidget extends StatelessWidget {

  final String titleRadio;
  final Color categColor;
  final String groupValue;
  void Function(String?)? onChanged;
   RadioWidget({super.key, required this.titleRadio, required this.categColor, required this.groupValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: RadioListTile(
        title: Transform.translate(
          offset: const Offset(-16, 0),
          child: Text(titleRadio, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),

        ),
        value: titleRadio,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: categColor,
      ),
    );
  }
}