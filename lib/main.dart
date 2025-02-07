import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:word_hurdle/app_provider.dart';
import 'package:word_hurdle/screens/word_hurdle_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AppProvider(),
    child: const TheApp(),
  ));
}

class TheApp extends StatelessWidget {
  const TheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 144, 111, 4),
          brightness: Brightness.dark,
        ),  
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
      home: const WordHurdleScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
