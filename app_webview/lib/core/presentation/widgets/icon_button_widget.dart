import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  Function function;
  IconData? icon = Icons.abc;
  Color? coloredIcon = Colors.black;

  IconButtonWidget(
      {super.key, required this.function, this.icon, this.coloredIcon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => function(),
      icon: Icon(icon, color: coloredIcon),
    );
  }
}
