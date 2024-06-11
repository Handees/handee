import 'package:flutter/material.dart';
import 'package:handees/shared/res/icons.dart';

Widget brushIconWidget() {
  return Expanded(
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: ShapeDecoration(
        color: Color.fromRGBO(255, 125, 203, 1).withOpacity(0.2),
        shape: CircleBorder(),
      ),
      child: CircleAvatar(
        radius: 15,
        backgroundColor: Color.fromRGBO(255, 125, 203, 1),
        child: Icon(
          HandeeIcons.hairBrush,
          color: Colors.white,
          size: 15,
        ),
      ),
    ),
  );
}
