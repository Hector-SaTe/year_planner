import 'package:flutter/material.dart';

enum SnackBarType {
  info,
  error,
}

void showSnackBarMessage(
    BuildContext context, String message, SnackBarType sbType) {
  final Color background = (sbType == SnackBarType.info)
      ? Colors.green.shade400
      : Colors.red.shade400;

  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 1),
    backgroundColor: background,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
