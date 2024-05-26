import 'package:app_webview/core/presentation/viewmodels/home_controller_page.dart';
import 'package:app_webview/core/presentation/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    // Initialize GetX Controller
    Get.put(HomeControllerPage());
  });

  tearDown(() {
    // Reset GetX
    Get.reset();
  });

  testWidgets('Botões HomePage renderizados com sucesso',
      (WidgetTester tester) async {
    // Build HomePage widget
    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomePage(),
      ),
    );

    // Verifica se tem 3 widgets de OutlineButtonWidget
    expect(find.byType(OutlineButtonWidget), findsNWidgets(3));

    // Verifica se a cor do botão 0 é vermelho
    OutlineButtonWidget firstButton = tester.widget<OutlineButtonWidget>(
      find.byType(OutlineButtonWidget).at(0),
    );
    expect(firstButton.color, Colors.red);

    // Verifica se a cor do botão 3 é verde
    OutlineButtonWidget secondButton = tester.widget<OutlineButtonWidget>(
      find.byType(OutlineButtonWidget).at(2),
    );
    expect(secondButton.color, Colors.green);
  });
}
