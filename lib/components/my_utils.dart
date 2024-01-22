import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

enum IconCheck {
  withCheckIcon,
  withWrongIcon,
  withoutIcon,
}

class MyUtils {
  static void passwordErrorHandlingAndUpdateUIWarning({
    required String password,
    required List<Widget> credentialUserWarningList,
  }) {
    Widget passwordWarning;
    Widget iconWarning;
    IconCheck suffixIcon;
    if (password.isNotEmpty && password.length < 6) {
      passwordWarning = const Text(
        'At least 6 characters',
        style: kPasswordLessThansixCharacters,
      );
      suffixIcon = IconCheck.withWrongIcon;
    } else if (password.length > 5) {
      passwordWarning = const Text(
        'At least 6 characters',
        style: kPasswordEqualOrgreaterThansixCharacters,
      );
      suffixIcon = IconCheck.withCheckIcon;
    } else {
      passwordWarning = const SizedBox();
      suffixIcon = IconCheck.withoutIcon;
    }
    switch (suffixIcon) {
      case IconCheck.withCheckIcon:
        iconWarning = const Icon(
          Icons.check,
          color: Colors.green,
        );
        break;
      case IconCheck.withWrongIcon:
        iconWarning = const Icon(
          Icons.close_rounded,
          color: Colors.red,
        );
      case IconCheck.withoutIcon:
        iconWarning = const SizedBox();
    }
    _updateUIWarning(
      warningList: credentialUserWarningList,
      warningText: passwordWarning,
      warningIcon: iconWarning,
    );
  }

  static void fireAuthErrorHandlingAndUpdateUIWarning({
    required List<Widget> credentialUserWarningList,
    required FirebaseAuthException error,
  }) {
    Widget warningError = const SizedBox();
    switch (error.code) {
      case 'invalid-credential':
        warningError = const Text(
          'Invalid Credentials',
          style: kPasswordLessThansixCharacters,
        );
        break;
      case 'too-many-requests':
        warningError = const Text(
          'Too many requests. Try later.',
          style: kPasswordLessThansixCharacters,
        );
        break;
      case 'invalid-email':
        warningError = const Text(
          'Invalid Email Adress.',
          style: kPasswordLessThansixCharacters,
        );
        break;
      case 'email-already-in-use':
        warningError = const Text(
          'Email Already In Use',
          style: kPasswordLessThansixCharacters,
        );
        break;
    }
    _updateUIWarning(
      warningList: credentialUserWarningList,
      warningText: warningError,
    );
  }

  static void _updateUIWarning({
    required List<Widget> warningList,
    required Widget warningText,
    Widget? warningIcon,
  }) {
    warningList.clear();
    warningList.add(warningText);
    if (warningIcon != null) {
      warningList.add(warningIcon);
    }
  }
}
