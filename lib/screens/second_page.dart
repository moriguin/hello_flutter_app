import 'package:flutter/material.dart';
import '../widgets/gradient_app_bar.dart';

// ページ2: セカンド画面
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('【SecondPage】build()が呼ばれました');
    return Scaffold(
      appBar: const GradientAppBar(title: 'Second'),
      // 戻るボタンは自動で追加される
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('これは2番目のページです', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('【SecondPage】ホームに戻るボタンがタップされました');
                // 前の画面に戻る
                Navigator.pop(context);
              },
              child: const Text('ホームに戻る'),
            ),
            const SizedBox(height: 10),
            // データを渡して戻る例
            ElevatedButton(
              onPressed: () {
                print('【SecondPage】データを持って戻るボタンがタップされました');
                Navigator.pop(context, 'セカンドページから戻りました');
              },
              child: const Text('データを持って戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
