import 'dart:math';

import 'package:flutter/material.dart';
import 'package:handees/shared/data/handees/handee.dart';
import 'package:handees/shared/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

mixin InputValidationMixin {
  bool isEmailValid(String email) {
    var pattern = r'^\S+@\S+\.\S+$';
    var regex = RegExp(pattern);

    return regex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    var light = r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{6,}$';
    // var extreme =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$';
    var regex = RegExp(light);

    return regex.hasMatch(password);
  }

  bool isNumberValid(String number) {
    var pattern = r'^[0-9-+\s]+$';
    var regex = RegExp(pattern);

    return regex.hasMatch(number);
  }
}

Color getHexColor(String hexColor) {
  if (hexColor.length != 6) {
    throw 'hexColor must be of length 6';
  }

  int val = 0xff000000 + int.parse(hexColor, radix: 16);
  return Color(val);
}

void dPrint(dynamic message) {
  MyLogger.instance.logger.d(message);
}

void ePrint(dynamic message) {
  MyLogger.instance.logger.e(message);
}

String formatString(String str) {
  String res = '';
  for (int i = 0; i < str.length; i++) {
    String char = str[i].toLowerCase();
    int ascii = char.codeUnitAt(0);
    int aAscii = 'a'.codeUnitAt(0);
    if (char == ' ') {
      res += '-';
    } else if (ascii - aAscii >= 0 && ascii - aAscii <= 26) {
      res += char;
    }
  }
  return res;
}

Future<void> openUrl(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

List<Handee> generateHandeeList(int count) {
  final List<String> names = ['Dro', 'Omas', 'Moyin', 'Paul', 'Ife'];
  final List<DateTime> dates = [
    DateTime(2023, 06, 24),
    DateTime(2023, 02, 21),
    DateTime(2023, 07, 17),
    DateTime(2023, 09, 05),
    DateTime(2023, 04, 30),
  ];

  final List<Handee> result = [];

  for (int i = 0; i < count; i++) {
    final int nameIdx = Random().nextInt(names.length);
    final int dateIdx = Random().nextInt(dates.length);
    final int rating = Random().nextInt(6) + 1;
    final bool isCompleted = Random().nextInt(2) == 1;

    result.add(Handee(
        customerName: names[nameIdx],
        rating: rating,
        isCompleted: isCompleted,
        date: dates[dateIdx]));
  }

  return result;
}

List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

String dateToString(DateTime date) {
  return '${date.day.toString()} ${months[date.month - 1]}, ${date.year}';
}

String formatDateYMD(DateTime date) {
  return '${date.year}-${date.month}-${date.day}';
}

void displaySnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    ),
  );
}

String capitalize(String word) {
  return word[0].toUpperCase() + word.substring(1);
}
