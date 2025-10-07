# const の使い方

## const とは？

`const` = **コンパイル時に確定する、絶対に変わらない値**

Flutter の `const` も同じ考え方ですが、Widget にも適用できます。

## const の基本ルール

### const にできる = 変わらないもの

```dart
const Text('Hello')                      // 固定テキスト
const Icon(Icons.home)                   // アイコン
const SizedBox(height: 20)               // 固定サイズの空白
const GradientAppBar(title: 'Home')      // タイトルだけ指定、中身は変わらない
const Color(0xFFEC4899)                  // 色
const TextStyle(fontSize: 24)            // スタイル
```

**ポイント**: 作成時に全ての値が確定していて、実行中に変わらない

### const にできない = 変わるもの・動的なもの

#### 1. ボタン（タップ時の処理がある）

```dart
// NG: const にできない
const ElevatedButton(
  onPressed: () {           // ← タップ時に実行される = 動的
    print('タップされた');
    Navigator.push(...);
  },
  child: Text('ボタン'),
)

// OK: const なし
ElevatedButton(
  onPressed: () { ... },
  child: const Text('ボタン'),  // ← 子要素は const にできる
)
```

#### 2. ユーザー入力

```dart
// NG: const にできない
const TextField(
  onChanged: (text) { ... },  // ← 入力で変わる = 動的
)
```

#### 3. 状態によって変わるもの

```dart
// NG: const にできない
final userName = 'Taro';
const Text(userName)  // ← userName は変数 = 実行時に決まる

// OK: 直接値を指定
const Text('Taro')
```

#### 4. 動的な処理を含む Widget

```dart
// NG: const にできない
const Scaffold(
  body: Column(
    children: [
      ElevatedButton(
        onPressed: () { ... },  // ← 動的な処理
      ),
    ],
  ),
)

// OK: Scaffold は const なし、一部だけ const
Scaffold(
  appBar: const GradientAppBar(title: 'Home'),  // ← これは const
  body: Column(
    children: [
      ElevatedButton(
        onPressed: () { ... },  // ← 動的
      ),
    ],
  ),
)
```

## const を使うメリット

### パフォーマンス向上

Flutter は `const` を見つけると、**1 回だけ作成して再利用**します。

```dart
// const あり: 1回だけ作成、画面が再描画されても再利用
const Text('Hello')

// const なし: 画面が再描画されるたびに新しく作成
Text('Hello')
```

**イメージ**:

```
const あり:
初回: Text('Hello') を作成 ✓
再描画: 前に作ったものを再利用 ✓（高速）

const なし:
初回: Text('Hello') を作成 ✓
再描画: Text('Hello') を新しく作成 ✓（やや遅い）
```

### メモリ節約

同じ `const` Widget は**メモリ上で 1 つだけ**存在します。

```dart
// これらは全て同じメモリ上のオブジェクトを参照
const Icon(Icons.home)
const Icon(Icons.home)
const Icon(Icons.home)
```

## 実際のエラー例

### エラーが出たコード

```dart
return const Scaffold(  // ← Scaffold 全体を const にした
  appBar: GradientAppBar(title: 'Home'),
  body: Center(
    child: Column(
      children: [
        ElevatedButton(
          onPressed: () {  // ← この中で動的な処理
            print('【HomePage】Named Routeボタンがタップされました');
            Navigator.pushNamed(context, '/second');
          },
          child: const Text('2ページ目へ（Named Route）'),
        ),
      ],
    ),
  ),
)
```

### エラーメッセージ

```
lib/screens/home_page.dart:21:17: Error: Method invocation is not a constant expression.
                print('【HomePage】Named Routeボタンがタップされました');
                ^^^^^
```

**エラーの意味**:

- **Method invocation is not a constant expression** = 「メソッド呼び出しは定数式じゃない」
- つまり、「`const` の中で `print()` や `Navigator.push()` のような**動的な処理**は使えないよ」

### 修正後のコード

```dart
return Scaffold(  // ← const を外した（動的な処理があるから）
  appBar: const GradientAppBar(title: 'Home'),  // ← AppBar だけ const
  body: Center(
    child: Column(
      children: [
        ElevatedButton(
          onPressed: () {  // ← 動的な処理（OK）
            print('【HomePage】Named Routeボタンがタップされました');
            Navigator.pushNamed(context, '/second');
          },
          child: const Text('2ページ目へ（Named Route）'),  // ← 子要素は const
        ),
      ],
    ),
  ),
)
```

## const の付け方のコツ

### 1. できるだけ部分的に const を付ける

```dart
Scaffold(
  appBar: const GradientAppBar(title: 'Home'),  // ← これは const
  body: Column(
    children: [
      const Text('固定テキスト'),               // ← これも const
      const SizedBox(height: 20),              // ← これも const
      ElevatedButton(
        onPressed: () { ... },                 // ← これは const にできない
        child: const Text('ボタン'),           // ← 子要素は const
      ),
    ],
  ),
)
```

### 2. リスト全体を const にする

```dart
const Column(
  children: [
    Text('タイトル'),
    SizedBox(height: 20),
    Text('説明文'),
  ],
)
```

**条件**: リストの中身が**全て const** のときだけ

### 3. コンストラクタを const にする

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});  // ← const コンストラクタ

  @override
  Widget build(BuildContext context) {
    return const Text('Hello');
  }
}

// 使うとき
const MyWidget()  // ← const を付けられる
```

## const が必要ない場合

動的な処理が**1 つでも**含まれていたら、その親 Widget は `const` にできません。

```dart
// NG: onPressed があるので const にできない
const Column(
  children: [
    Text('こんにちは'),
    ElevatedButton(
      onPressed: () { ... },  // ← これがあるから NG
    ),
  ],
)

// OK: Column は const なし、Text だけ const
Column(
  children: [
    const Text('こんにちは'),  // ← これは const
    ElevatedButton(
      onPressed: () { ... },
      child: const Text('ボタン'),  // ← これも const
    ),
  ],
)
```

## const のチェックリスト

Widget に `const` を付けられるか判断する:

- [ ] 全ての値がコンパイル時に確定している？
- [ ] `onPressed`、`onChanged` などのコールバックがない？
- [ ] 変数を参照していない（または変数も `const`）？
- [ ] 子 Widget も全て `const`？

**全て YES なら `const` を付けられます！**

## まとめ

1. **const = 絶対に変わらない値**（コンパイル時に確定）
2. **const にできる**: 固定テキスト、アイコン、色、サイズなど
3. **const にできない**: ボタンの処理、ユーザー入力、状態が変わるもの
4. **メリット**: パフォーマンス向上、メモリ節約
5. **コツ**: できるだけ部分的に `const` を付ける
6. **エラー**: 「Method invocation is not a constant expression」= 動的な処理を `const` の中で使おうとしている

**基本方針**: 迷ったら付けてみて、エラーが出たら外す。Flutter が教えてくれます！
