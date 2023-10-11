import 'package:flutter/material.dart';
import 'package:tanyapakar/components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const RoundedInputField({
    Key? key,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          labelText: hintText,
        ),
      ),
    );
  }
}
