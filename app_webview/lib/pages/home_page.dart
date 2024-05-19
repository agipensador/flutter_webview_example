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
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: OutlineButtonWidget(
                  buttonData: buttonDataList[index],
                  index: index,
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
    return ButtonData(text: 'Ajude o RS', color: Colors.purple);
  }

  factory ButtonData.football() {
    return ButtonData(text: 'Futebol', color: Colors.green);
  }
}

class OutlineButtonWidget extends StatelessWidget {
  final ButtonData buttonData;
  final int index;

  OutlineButtonWidget({required this.buttonData, required this.index});

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
                  arguments: index,
                );
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(buttonData.color),
                overlayColor:
                    MaterialStateProperty.all(buttonData.color.withOpacity(.2)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
              child: Text(buttonData.text)),
        ),
      ],
    );
  }
}
