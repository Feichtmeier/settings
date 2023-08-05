import 'package:duration/duration.dart';
import 'package:flutter/material.dart';

Color colorFromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.tryParse(buffer.toString(), radix: 16) ?? 0);
}

/// Darken a color by [percent] amount (100 = black)
Color darken(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  final f = 1 - percent / 100;
  return Color.fromARGB(
    c.alpha,
    (c.red * f).round(),
    (c.green * f).round(),
    (c.blue * f).round(),
  );
}

/// Lighten a color by [percent] amount (100 = white)
Color lighten(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  final p = percent / 100;
  return Color.fromARGB(
    c.alpha,
    c.red + ((255 - c.red) * p).round(),
    c.green + ((255 - c.green) * p).round(),
    c.blue + ((255 - c.blue) * p).round(),
  );
}

/// Convert duration in seconds into legible string
String formatTime(int seconds) {
  return prettyDuration(
    Duration(seconds: seconds),
    tersity: DurationTersity.second,
  );
}

/// Convert string in camel case to string split by dash
String camelCaseToSplitByDash(String value) {
  final beforeCapitalLetterRegex = RegExp(r'(?=[A-Z])');
  final parts = value.split(beforeCapitalLetterRegex);
  var newString = '';
  for (final part in parts) {
    if (newString.isEmpty) {
      newString = part.toLowerCase();
    } else {
      newString = '${newString.toLowerCase()}-${part.toLowerCase()}';
    }
  }
  return newString;
}
