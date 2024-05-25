import 'package:app_webview/core/presentation/views/home_page.dart';
import 'package:app_webview/core/presentation/views/web_view_page.dart';
import 'package:app_webview/core/presentation/viewmodels/home_controller_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {

  // Inicializa o GetX
  WidgetsFlutterBinding.ensureInitialized();

  runApp(GetMaterialApp(
    initialBinding: BindingsBuilder(() {
      Get.put(HomeControllerPage());
    }),
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => const HomePage()),
      GetPage(name: '/webView', page: () => const WebViewPage()),
    ],
  ));
}
