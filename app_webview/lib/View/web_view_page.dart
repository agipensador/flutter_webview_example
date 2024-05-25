import 'package:app_webview/ViewModel/web_view_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends GetView {
  WebViewPage({super.key});

  final WebViewPageController webViewPageController = Get.put(WebViewPageController());

  @override
  Widget build(BuildContext context) {

    return Obx(() => Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: webViewPageController.colored?.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                  webViewPageController.onShowUserAgent();
                },
                icon: Icon(Icons.home, color: webViewPageController.coloredIcon?.value),
              ),
              Obx(() => Row(
                  children: [
                    webViewPageController.customIconButton(() async {
                      if (await webViewPageController.webViewController.canGoBack()) {
                        await webViewPageController.webViewController.goBack();
                      } else {
                        const GetSnackBar(title: 'Não há páginas para voltar');
                      }
                    }, Icons.arrow_back, webViewPageController.coloredIcon!.value),
                    webViewPageController.customIconButton(() async {
                      if (await webViewPageController.webViewController.canGoForward()) {
                        await webViewPageController.webViewController.goForward();
                      } else {
                        const GetSnackBar(title: 'Não há páginas para avançar');
                      }
                    }, Icons.arrow_forward, webViewPageController.coloredIcon!.value),
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
            if (webViewPageController.loadingPercentage < 100)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    color: webViewPageController.colored?.value,
                    //Valor load da linha
                    value: webViewPageController.loadingPercentage / 100.0,
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
          child: const Text(
            "GIT",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
