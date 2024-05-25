import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeControllerPage extends GetxController {

  final List<ButtonData> buttonDataList = [
    ButtonData.news(),
    ButtonData.helpRS(),
    ButtonData.football(),
  ];
}

class ButtonData {
  final String text;
  final Color color;

  ButtonData({required this.text, required this.color});

  factory ButtonData.news() => ButtonData(text: 'Notícias', color: Colors.red);

  factory ButtonData.helpRS() =>
      ButtonData(text: 'Ajude o RS', color: Colors.purple.shade700);

  factory ButtonData.football() =>
      ButtonData(text: 'Futebol', color: Colors.green);
}
