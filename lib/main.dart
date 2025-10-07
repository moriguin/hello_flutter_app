import 'package:flutter/material.dart';

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
      // ルート設定方式1: routesを使う方法
      initialRoute: '/', // 最初に表示するルート
      routes: {
        '/': (context) => const HomePage(),
        '/second': (context) => const SecondPage(),
      },
    );
  }
}

// ページ1: ホーム画面
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    print('【HomePage】build()が呼ばれました');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFEC4899), // 強めのピンク
                Color(0xFFA855F7), // 紫
              ],
            ),
          ),
        ),
      ),
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

// ページ2: セカンド画面
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('【SecondPage】build()が呼ばれました');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFEC4899), // 強めのピンク
                Color(0xFFA855F7), // 紫
              ],
            ),
          ),
        ),
        // 戻るボタンは自動で追加される
      ),
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
