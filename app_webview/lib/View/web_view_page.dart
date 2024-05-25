import 'package:app_webview/ViewModel/web_view_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends GetView {
  WebViewPage({super.key});

  final WebViewPageController webViewPageController =
      Get.put(WebViewPageController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: webViewPageController.colored?.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  webViewPageController.onShowUserAgent();
                  Get.back();
                },
                icon: Icon(Icons.home,
                    color: webViewPageController.coloredIcon?.value),
              ),
              Obx(
                () => Row(
                  children: [
                    webViewPageController.customIconButton(() async {
                      if (await webViewPageController.webViewController
                          .canGoBack()) {
                        await webViewPageController.webViewController.goBack();
                      } else {
                        webViewPageController.defaultGetSnackbar(
                            message: "Não há páginas para voltar",
                            position: SnackPosition.BOTTOM);
                      }
                    }, Icons.arrow_back,
                        webViewPageController.coloredIcon!.value),
                    webViewPageController.customIconButton(() async {
                      if (await webViewPageController.webViewController
                          .canGoForward()) {
                        await webViewPageController.webViewController
                            .goForward();
                      } else {
                        webViewPageController.defaultGetSnackbar(
                            message: "Não há páginas para avançar",
                            position: SnackPosition.BOTTOM);
                      }
                    }, Icons.arrow_forward,
                        webViewPageController.coloredIcon!.value),
                    webViewPageController.customIconButton(
                        () => webViewPageController.webViewController.reload(),
                        Icons.refresh_rounded,
                        webViewPageController.coloredIcon!.value)
                  ],
                ),
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('Flutter WebView'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            WebViewWidget(
              //Controlador
              controller: webViewPageController.webViewController,
            ),
            if (webViewPageController.loadingPercentage.value < 100)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    color: webViewPageController.colored?.value,
                    //Valor load da linha
                    value:
                        webViewPageController.loadingPercentage.value / 100.0,
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black54,
          onPressed: () async {
            //Requisição para o webview
            await webViewPageController.webViewController
                .loadRequest(Uri.parse('https://github.com/agipensador'));
          },
          child: ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(24), // Image radius
              child: Image.network(
                  'https://avatars.githubusercontent.com/u/162528483?v=4'),
            ),
          ),
        ),
      ),
    );
  }
}
