import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewApp extends StatefulWidget {
  WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController webViewController;
  int loadingPercentage = 0;
  late int index;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use o índice recebido aqui após a construção do widget
      index = ModalRoute.of(context)!.settings.arguments as int;

    webViewController = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          debugPrint("Página Iniciada URL : $url");
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          debugPrint("Página em Progresso : $progress");
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          debugPrint("Página Carregada : $url");
          setState(() {
            loadingPercentage = 100;
          });
        },
        onNavigationRequest: (navigationRequest) {
          // WebView provides your app with a NavigationDelegate, which enables your app to track and control the page navigation of the WebView widget. When a navigation is initiated by the WebView, for example when a user clicks on a link, the NavigationDelegate is called. The NavigationDelegate callback can be used to control whether the WebView proceeds with the navigation.
          final String host = Uri.parse(navigationRequest.url).host;
          //  This code is used to prevent the user to navigate to the youtube .
          if (host.contains("youtube.com")) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Navigation to $host is blocked")));
            // The navigation decision is the enum in which we have to call it's constant value of the name prevent which is used to Prevent the navigation from taking place.

            return NavigationDecision.prevent;
          } else {
            // Allow the navigation to take place.

            return NavigationDecision.navigate;
          }
        },
      ))

      // The load request method of the web view flutter is used to makes a specific HTTP request and loads the response in the webview.
      ..loadRequest(
        // Makes a specific HTTP request and loads the response in the webview.
        Uri.parse(index == 1
            ? 'https://g1.globo.com/'
            : index == 2
                ? 'https://emergencia.paraquemdoar.com.br/?ref=home_banner?utm_source=pirulito&utm_medium=home&utm_campaign=homeg1'
                : 'https://ge.globo.com/'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.home)),
        actions: [
          customIconButton(() async {
            if (await webViewController.canGoBack()) {
              await webViewController.goBack();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Não há páginas para voltar")));
            }
          }, Icons.arrow_back),
          customIconButton(() async {
            if (await webViewController.canGoForward()) {
              await webViewController.goForward();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Não há páginas para avançar")));
            }
          }, Icons.arrow_forward),
          customIconButton(
              () => webViewController.reload(), Icons.refresh_rounded)
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            //Controlador
            controller: webViewController,
          ),
          if (loadingPercentage < 100)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  color: Colors.black,
                  //Valor load da linha
                  value: loadingPercentage / 100.0,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //Requisição para o webview
          await webViewController
              .loadRequest(Uri.parse('https://github.com/agipensador'));
        },
        child: const Text("GIT"),
      ),
    );
  }

  Widget customIconButton(Function function, IconData icon) {
    return IconButton(
      onPressed: () => function(),
      icon: Icon(icon),
    );
  }
}
