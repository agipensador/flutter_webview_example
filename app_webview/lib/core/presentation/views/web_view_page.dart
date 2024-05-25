import 'package:app_webview/core/presentation/viewmodels/web_view_page_controller.dart';
import 'package:app_webview/core/presentation/widgets/icon_button_widget.dart';
import 'package:app_webview/core/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final WebViewPageController controller = Get.put(WebViewPageController());

    return Obx(
      () => Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: controller.colored?.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  controller.onShowUserAgent();
                  Get.back();
                },
                icon: Icon(Icons.home, color: controller.coloredIcon?.value),
              ),
              Obx(
                () => Row(
                  children: [
                    IconButtonWidget(
                        function: () async {
                          if (await controller.webViewController.canGoBack()) {
                            await controller.webViewController.goBack();
                          } else {
                            controller.defaultGetSnackbar(
                                message: "Não há páginas para voltar",
                                position: SnackPosition.BOTTOM);
                          }
                        },
                        icon: Icons.arrow_back,
                        coloredIcon: controller.coloredIcon!.value),
                    IconButtonWidget(
                        function: () async {
                          if (await controller.webViewController
                              .canGoForward()) {
                            await controller.webViewController.goForward();
                          } else {
                            controller.defaultGetSnackbar(
                                message: "Não há páginas para avançar",
                                position: SnackPosition.BOTTOM);
                          }
                        },
                        icon: Icons.arrow_forward,
                        coloredIcon: controller.coloredIcon!.value),
                    IconButtonWidget(
                        function: () => controller.webViewController.reload(),
                        icon: Icons.refresh_rounded,
                        coloredIcon: controller.coloredIcon!.value)
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
              controller: controller.webViewController,
            ),
            if (controller.loadingPercentage.value < 100)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    color: controller.colored?.value,
                    //Valor load da linha
                    value: controller.loadingPercentage.value / 100.0,
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black54,
          onPressed: () async {
            //Requisição para o webview
            await controller.webViewController
                .loadRequest(Uri.parse('https://github.com/agipensador'));
            controller.webViewController.runJavaScript(
              Strings.githubHTML,
            );
          },
          child: ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(24), // Image radius
              child: Image.network(Strings.linkImage),
            ),
          ),
        ),
      ),
    );
  }
}
