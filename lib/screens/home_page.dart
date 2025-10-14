import 'package:flutter/material.dart';
import 'heart_rate_page.dart';
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
            // 脈拍測定ページへ
            ElevatedButton(
              onPressed: () {
                print('【HomePage】脈拍測定ボタンがタップされました');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HeartRatePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('脈拍測定'),
            ),
          ],
        ),
      ),
    );
  }
}
