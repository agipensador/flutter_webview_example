import 'package:app_webview/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPageController extends GetxController {
  final webViewController = WebViewController();
  RxInt loadingPercentage = 0.obs;
  RxInt? index = 1.obs;
  Rx<Color>? colored = Colors.white.obs;
  Rx<Color>? coloredIcon = Colors.black54.obs;

  Map<int, String> urls = {
    0: Strings.webNotices,
    1: Strings.webRS,
    2: Strings.webFootball
  };

  @override
  void onInit() {
    webViewController;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use o índice recebido aqui após a construção do widget
      final args = Get.arguments;
      index?.value = args['index'];
      colored?.value = args['color'];
      // inicia as URLs
      String selectedUrl = urls[index?.value] ?? Strings.webNotices;

      //webView
      webViewController
        //O navigationRequest é a parte que podemos rastrear o que nosso usuário está fazendo nas navegações do APP
        ..setNavigationDelegate(NavigationDelegate(
          onPageStarted: (url) {
            debugPrint("Página Iniciada URL : $url");
            loadingPercentage.value = 0;
          },
          onProgress: (progress) {
            debugPrint("Página em Progresso : $progress");
            loadingPercentage.value = progress;
          },
          onPageFinished: (url) {
            debugPrint("Página Carregada : $url");
            loadingPercentage.value = 100;
          },
          onNavigationRequest: (navigationRequest) {
            final String host = Uri.parse(navigationRequest.url).host;
            //Podemos proibir de nosso usuário acessar um site específico
            if (host.contains("https://chatgpt.com/")) {
              GetSnackBar(
                  message: "A navegação para $host está bloqueada",
                  duration: const Duration(seconds: 5));

              return NavigationDecision.prevent;
            } else {
              // Navegação permitida

              return NavigationDecision.navigate;
            }
          },
        ))
        // Comunicação two-way com JS
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (JavaScriptMessage message) {
            GetSnackBar(
              message: message.message.toString(),
              duration: const Duration(seconds: 5),
            );
          },
        )

        // Solicitação de carregamento do flutter da visualização da web é usado para fazer
        // uma solicitação HTTP específica e carregar a resposta na visualização da web
        ..loadRequest(
          // Url
          Uri.parse(selectedUrl),
        );
    });

    coloredIcon?.value = colored?.value != null ? Colors.white : Colors.black87;

    super.onInit();
  }

  Widget customIconButton(Function function, IconData icon, Color coloredIcon) {
    return IconButton(
      onPressed: () => function(),
      icon: Icon(icon, color: coloredIcon),
    );
  }

  Future<void> onShowUserAgent() {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    return webViewController.runJavaScript(
      'Toaster.postMessage("User Agent: " + navigator.userAgent);',
    );
  }
}
