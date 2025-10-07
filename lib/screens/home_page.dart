import 'package:flutter/material.dart';
import 'second_page.dart';
import '../widgets/gradient_app_bar.dart';

// ページ1: ホーム画面
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    print('【HomePage】build()が呼ばれました');
    return Scaffold(
      appBar: const GradientAppBar(title: 'Home'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ナビゲーション方法1: Named Route
            ElevatedButton(
              onPressed: () {
                print('【HomePage】Named Routeボタンがタップされました');
                Navigator.pushNamed(context, '/second');
              },
              child: const Text('2ページ目へ（Named Route）'),
            ),
            const SizedBox(height: 10),
            // ナビゲーション方法2: MaterialPageRoute
            ElevatedButton(
              onPressed: () {
                print('【HomePage】Direct Pushボタンがタップされました');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
              child: const Text('2ページ目へ（Direct Push）'),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
