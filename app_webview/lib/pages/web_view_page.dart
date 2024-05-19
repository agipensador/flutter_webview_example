import 'package:app_webview/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewApp extends StatefulWidget {
  WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  final webViewController = WebViewController();
  int loadingPercentage = 0;
  int? index = 1;
  Map<int, String> urls = {
    0: Strings.webNotices,
    1: Strings.webRS,
    2: Strings.webFootball
  };

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use o índice recebido aqui após a construção do widget
      index = ModalRoute.of(context)!.settings.arguments as int;

      // inicia as URL
      String selectedUrl = urls[index] ?? Strings.webNotices;

      //webView
      webViewController
      //O navigationRequest é a parte que podemos rastrear o que nosso usuário está fazendo nas navegações do APP
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
            final String host = Uri.parse(navigationRequest.url).host;
            //Podemos proibir de nosso usuário acessar um site específico
            if (host.contains("https://chatgpt.com/")) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("A navegação para $host está bloqueada")));

              return NavigationDecision.prevent;
            } else {
              // Navegação permitida

              return NavigationDecision.navigate;
            }
          },
        ))

        // Solicitação de carregamento do flutter da visualização da web é usado para fazer
        // uma solicitação HTTP específica e carregar a resposta na visualização da web
        ..loadRequest(
          // Url
          Uri.parse(selectedUrl),
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
