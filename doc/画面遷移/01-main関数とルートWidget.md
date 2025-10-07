# Q1: main 関数とルート Widget

## 質問

```
void main() {
  runApp(const MyApp());
}
```

この部分だけど、絶対に MyApp を一つ返す感じ？基本的なアプリでは。

## 回答

はい、その通りです！**基本的にアプリ全体で 1 つのルート Widget（MyApp）だけを返します**。

### 🎯 main 関数の役割

```dart
void main() {
  runApp(const MyApp());  // アプリのルートは必ず1つ
}
```

```dart
// ❌ これはできない
void main() {
  runApp(const MyApp());
  runApp(const AnotherApp());  // 2つ目は無視される
}

// ❌ これもダメ
void main() {
  runApp(
    Column(  // 複数Widgetを直接入れられない
      children: [MyApp(), AnotherApp()],
    ),
  );
}
```

- **runApp()** = アプリケーション全体の起点を 1 つ決める
- MaterialApp/CupertinoApp 自体が「アプリケーション」を表す
- 複数のアプリを同時に起動する概念がない

**まとめ**:

- `main()` → `runApp()` → `MyApp()` は固定パターン
- MyApp の**中で**複数画面を管理する
- Web の`<div id="root">`に 1 つの React アプリをマウントするのと同じ概念！
