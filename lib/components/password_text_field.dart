import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Widget? suffixIconButton;
  final bool obscureText;

  const PasswordTextField({
    super.key,
    required this.textEditingController,
    required this.onChanged,
    required this.onSubmitted,
    required this.suffixIconButton,
    required this.obscureText,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obscureText,
      onSubmitted: widget.onSubmitted,
      controller: widget.textEditingController,
      cursorColor: Colors.blueAccent,
      keyboardType: TextInputType.visiblePassword,
      textAlign: TextAlign.center,
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
      decoration: kTextFieldDecoration.copyWith(
        hintText: 'Enter your password',
        suffixIcon: widget.suffixIconButton,
      ),
    );
  }
}
