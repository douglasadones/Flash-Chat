import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function(String)? onChanged;

  const LoginTextField({
    super.key,
    required this.textEditingController,
    this.onChanged,
  });

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      textInputAction: TextInputAction.next,
      cursorColor: Colors.blueAccent,
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.center,
      onChanged: (value) {
        widget.onChanged?.call(value);
        // setState(() {
        //   email = value;
        //   registerButtonEnableChecker();
        // });
      },
      decoration: kTextFieldDecoration.copyWith(
        hintText: 'Enter your email',
        suffixIcon: (widget.textEditingController.text.isNotEmpty)
            ? IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Colors.grey.shade600,
                ),
                onPressed: () {
                  setState(() {
                    widget.textEditingController.clear();
                  });
                },
              )
            : null,
      ),
    );
  }
}
