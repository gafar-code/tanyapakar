import 'package:flutter/material.dart';
import 'package:tanyapakar/constanta/warna.dart';

class TextFieldPakar extends StatelessWidget {
  final String label;
  final String? hint;
  final bool? isPwd;
  final TextEditingController controller;

  const TextFieldPakar(
      {Key? key,
      required this.controller,
      required this.label,
      this.hint,
      this.isPwd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        style: const TextStyle(fontSize: 14),
        controller: controller,
        obscureText: isPwd == true ? true : false,
        decoration: InputDecoration(
          labelText: label,
          hintText: (hint != null) ? hint : "",
          contentPadding: const EdgeInsets.fromLTRB(28, 0, 12, 12),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: kPrimaryColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: kPrimaryLightColor),
          ),
        ),
      ),
    );
  }
}
