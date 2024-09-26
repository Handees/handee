import 'package:flutter/material.dart';

Widget getHelpListTile(context,
    {VoidCallback? onTap,
    required String text,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding}) {
  return ListTile(
    contentPadding: padding,
    tileColor: Colors.white,
    onTap: onTap,
    leading: Text(
      text,
      style: textStyle,
    ),
    trailing: const Icon(Icons.arrow_forward_ios_rounded),
  );
}
