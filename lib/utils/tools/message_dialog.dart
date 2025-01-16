import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';

void showError(String errorMsg) {
  FlashyFlushbar(
    leadingWidget: const Icon(
      Icons.error_outline,
      color: Colors.orange,
      size: 24,
    ),
    message: errorMsg,
    duration: const Duration(seconds: 5),
    trailingWidget: IconButton(
      icon: const Icon(
        Icons.close,
        color: Colors.black,
        size: 24,
      ),
      onPressed: () {
        FlashyFlushbar.cancel();
      },
    ),
    isDismissible: true,
  ).show();
}

void showSuccess(String msg) {
  FlashyFlushbar(
    leadingWidget: const Icon(
      Icons.check_circle_outline_outlined,
      color: Colors.green,
      size: 24,
    ),
    message: msg,
    duration: const Duration(seconds: 5),
    trailingWidget: IconButton(
      icon: const Icon(
        Icons.close,
        color: Colors.black,
        size: 24,
      ),
      onPressed: () {
        FlashyFlushbar.cancel();
      },
    ),
    isDismissible: true,
  ).show();
}