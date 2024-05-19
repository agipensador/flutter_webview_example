import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ButtonData> buttonDataList = [
      ButtonData.news(),
      ButtonData.helpRS(),
      ButtonData.football(),
    ];

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              buttonDataList.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: OutlineButtonWidget(
                  buttonData: buttonDataList[index],
                  index: index,
                  color: buttonDataList[index].color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonData {
  final String text;
  final Color color;

  ButtonData({required this.text, required this.color});

  factory ButtonData.news() {
    return ButtonData(text: 'Notícias', color: Colors.red);
  }

  factory ButtonData.helpRS() {
    return ButtonData(text: 'Ajude o RS', color: Colors.purple.shade700);
  }

  factory ButtonData.football() {
    return ButtonData(text: 'Futebol', color: Colors.green);
  }
}

class OutlineButtonWidget extends StatelessWidget {
  final ButtonData buttonData;
  final int index;
  final Color color;

  OutlineButtonWidget(
      {required this.buttonData, required this.index, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  'webView',
                  arguments: {'index': index, 'color': color},
                );
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(buttonData.color),
                overlayColor:
                    MaterialStateProperty.all(buttonData.color.withOpacity(.2)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                side: MaterialStateProperty.resolveWith((states) {
                  return BorderSide(
                      color: buttonData
                          .color); // Defina a cor da borda quando o botão estiver em seu estado padrão
                }),
              ),
              child: Text(buttonData.text)),
        ),
      ],
    );
  }
}
