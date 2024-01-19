import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

enum IconCheck {
  withCheckIcon,
  withWrongIcon,
  withoutIcon,
}

class MyUtils {
  static void passwordWarning({
    required String password,
    required List<Widget> credentialUserWarningList,
  }) {
    Widget passwordWarning;
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
    credentialUserWarningList.clear();
    credentialUserWarningList.add(passwordWarning);
    switch (suffixIcon) {
      case IconCheck.withCheckIcon:
        credentialUserWarningList.add(
          const Icon(
            Icons.check,
            color: Colors.green,
          ),
        );
        break;
      case IconCheck.withWrongIcon:
        credentialUserWarningList.add(
          const Icon(
            Icons.close_rounded,
            color: Colors.red,
          ),
        );
      case IconCheck.withoutIcon:
        credentialUserWarningList.add(const SizedBox());
    }
  }

  static void fireAuthErrorHandling({
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
          'Too Many Requests. Try later.',
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
    credentialUserWarningList.clear();
    credentialUserWarningList.add(warningError);
  }
}
