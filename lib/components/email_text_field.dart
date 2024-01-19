import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class EmailTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function(String)? onChanged;

  const EmailTextField({
    super.key,
    required this.textEditingController,
    required this.onChanged,
  });

  @override
  State<EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
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
