import 'package:flutter/material.dart';

class IconCreation extends StatelessWidget {
  final String text;
  final VoidCallback tap;
  final IconData icons;
  final Color color;

  const IconCreation({
    Key? key,
    required this.tap,
    required this.icons,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child: Icon(
              icons,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }
}
