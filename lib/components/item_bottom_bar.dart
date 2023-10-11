import 'package:flutter/material.dart';

class ItemBottomBar extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  const ItemBottomBar({
    Key? key,
    required this.icon,
    this.selected = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _tabIcon = Container(
      decoration: BoxDecoration(
          color: selected ? Colors.white24 : Colors.transparent,
          shape: BoxShape.circle),
      child: IconButton(
        onPressed: onPressed,
        iconSize: 40,
        icon: Icon(icon),
      ),
    );
    return _tabIcon;
  }
}
