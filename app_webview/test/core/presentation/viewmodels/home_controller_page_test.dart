
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:app_webview/core/presentation/viewmodels/home_controller_page.dart';

void main() {
  setUp(() {
    Get.put(HomeControllerPage());
  });

  tearDown(() {
    // Reseta o GetX
    Get.reset();
  });

  group("TDD Home Page Controller", () {

    test('O primeiro botão deve retornar o texto Notícias', () {
      final result = HomeControllerPage().buttonDataList[0].text;
      expect(result, equals('Notícias'));
    });

    test('O primeiro botão deve retornar o texto Ajude o RS', () {
      final result = HomeControllerPage().buttonDataList[1].text;
      expect(result, equals('Ajude o RS'));
    });

  });
}
