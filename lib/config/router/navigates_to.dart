import 'package:flutter/material.dart';

Future navigateTo(
    BuildContext context, {
      required String destination,
      Map<String, dynamic>? arguments,
    }) {
  return Navigator.pushNamed(
    context,
    destination,
    arguments: arguments,
  );
}

Future navigateReplaceTo(
    BuildContext context, {
      required String destination,
      Map<String, dynamic>? arguments,
    }) {
  return Navigator.pushReplacementNamed(context, destination,
      arguments: arguments);
}

Future navigateEndTo(
    BuildContext context, {
      required String destination,
      Map<String, dynamic>? arguments,
    }) {
  return Navigator.pushNamedAndRemoveUntil(
    context,
    destination,
    arguments: arguments,
        (route) => false,
  );
}