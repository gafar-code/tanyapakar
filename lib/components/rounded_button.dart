import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final String text;
  final VoidCallback press;
  final Color color, color2, textColor;
  final double sizeWidth;
  final IconData? icon;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    required this.color,
    required this.textColor,
    required this.sizeWidth,
    this.icon,
    required this.color2,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * sizeWidth,
      height: size.height * 0.06,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color2]),
        borderRadius: borderRadius,
      ),
      child: newElevatedButton(),
    );
  }

  //Used:ElevatedButton as FlatButton is deprecated.
  //Here we have to apply customizations to Button by inheriting the styleFrom

  Widget newElevatedButton() {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      onPressed: press,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        textStyle: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
