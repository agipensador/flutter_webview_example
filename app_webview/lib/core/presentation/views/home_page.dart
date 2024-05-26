import 'package:app_webview/core/presentation/viewmodels/home_controller_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeControllerPage> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildButtonList(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildButtonList() {
    return List.generate(
      controller.buttonDataList.length,
      (index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: OutlineButtonWidget(
          buttonData: controller.buttonDataList[index],
          index: index,
          color: controller.buttonDataList[index].color,
        ),
      ),
    );
  }
}

class OutlineButtonWidget extends StatelessWidget {
  final ButtonData buttonData;
  final int index;
  final Color color;

  OutlineButtonWidget({
    required this.buttonData,
    required this.index,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            key: const Key('btnWeb'),
            onPressed: () {
              Get.toNamed(
                '/webView',
                arguments: {
                  'index': index, 'color': color,
                },
              );

            },
            style: _buildButtonStyle(),
            child: Text(buttonData.text),
          ),
        ),
      ],
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ButtonStyle(
      foregroundColor: MaterialStateProperty.all(buttonData.color),
      overlayColor: MaterialStateProperty.all(buttonData.color.withOpacity(.2)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      side: MaterialStateProperty.resolveWith((states) {
        return BorderSide(color: buttonData.color);
      }),
    );
  }
}
