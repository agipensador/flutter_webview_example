import 'package:app_webview/pages/home_page.dart';
import 'package:app_webview/pages/web_view_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      routes: {
        '/': (context) => const HomePage(),
        'webView': (context) => WebViewApp()
      },
    ),
  );
}