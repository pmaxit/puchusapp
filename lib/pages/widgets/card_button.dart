
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
   CardButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      borderOnForeground: true,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30.0),
        child:  ListTile(
          leading: Icon(Icons.star_border_purple500_rounded, size: 40),
          title: Text(title),
          trailing: Icon(Icons.arrow_forward_ios),
          isThreeLine: false,
        ),
      ),
    );
  }
}
