import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  print('【アプリ起動】main()が実行されました');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('【MyApp】build()が呼ばれました');
    return MaterialApp(
      title: 'Hello Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD946EF), // Fuchsia (ピンク紫)
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // グラデーション用に透明
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}
