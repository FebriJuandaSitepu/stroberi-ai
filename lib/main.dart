import 'package:flutter/material.dart';

import 'pages/splash_page.dart';

import 'services/history_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await HistoryService.loadHistory();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      home: const SplashPage(),
    );
  }
}