# カスタム Widget の作成

## カスタム Widget とは？

Flutter が用意している標準 Widget（`AppBar`、`Button` など）をカスタマイズして、**自分専用の部品**を作ること。

**Web で例えると**: React の カスタムコンポーネントを作るのと同じ

```jsx
// React の例
function GradientAppBar({ title }) {
  return <header className="gradient">{title}</header>
}
```

## 今回作ったもの：GradientAppBar

グラデーション付きの AppBar を共通部品として作成しました。

### ファイル構成

```
lib/
├── main.dart
├── screens/
│   ├── home_page.dart
│   └── second_page.dart
└── widgets/                      # 共通部品フォルダ
    └── gradient_app_bar.dart     # カスタム AppBar
```

### 実装コード

**lib/widgets/gradient_app_bar.dart**:

```dart
import 'package:flutter/material.dart';

/// グラデーション付き AppBar
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const GradientAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
```

### 使い方

各画面で import して使う:

```dart
import '../widgets/gradient_app_bar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: 'Home'), // ← タイトルだけ指定
      body: ...,
    );
  }
}
```

## コードの解説

### 1. クラス定義

```dart
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
```

- `extends StatelessWidget`: 状態を持たない Widget として作成
- `implements PreferredSizeWidget`: AppBar として使えるようにするインターフェース

#### PreferredSizeWidget とは？

`Scaffold` は「AppBar の高さを知りたい」という要求があります。

```
┌─────────────┐
│   AppBar    │ ← この高さは何ピクセル？
├─────────────┤
│    body     │ ← AppBar の下から表示したい
└─────────────┘
```

`PreferredSizeWidget` を実装すると、「このWidgetの推奨サイズはこれです」と答えられるようになります。

**レストランの例**:
- 完成品の AppBar = マクドナルドのハンバーガー（カロリーが自動でわかる）
- 自作の GradientAppBar = 手作りハンバーガー（自分でカロリーを計算して答える必要がある）

### 2. プロパティ

```dart
final String title;

const GradientAppBar({
  super.key,
  required this.title, // title は必須パラメータ
});
```

- `title`: 外部から渡されるタイトル文字列
- `required`: 必ず指定しないといけないパラメータ

**Web で例えると**:
```jsx
// React の props
function GradientAppBar({ title }) { // title を受け取る
  return <header>{title}</header>
}

// 使うとき
<GradientAppBar title="Home" />
```

### 3. build メソッド

```dart
@override
Widget build(BuildContext context) {
  return AppBar(
    title: Text(title),
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
  );
}
```

- `build`: Widget の見た目を定義するメソッド
- `flexibleSpace`: AppBar の背景にグラデーションを配置
- `LinearGradient`: 左から右へのグラデーション

### 4. preferredSize

```dart
@override
Size get preferredSize => const Size.fromHeight(kToolbarHeight);
```

- `preferredSize`: このWidgetの推奨サイズを返す（`PreferredSizeWidget` の要求）
- `kToolbarHeight`: Flutter が用意している定数（56.0ピクセル = AppBar の標準的な高さ）

#### kToolbarHeight とは？

**Flutter が最初から用意している定数**です。

```dart
import 'package:flutter/material.dart';
//      ↑ この中に kToolbarHeight が含まれている

const double kToolbarHeight = 56.0; // 56ピクセル
```

**他にも用意されている定数**:
```dart
kToolbarHeight              // 56.0 (AppBarの高さ)
kBottomNavigationBarHeight  // 56.0 (下部ナビゲーションの高さ)
kFloatingActionButtonMargin // 16.0 (FABの余白)
kMinInteractiveDimension    // 48.0 (タップ可能な最小サイズ)
```

**Web で例えると**:
```javascript
// ブラウザが用意している定数（宣言不要）
window.innerWidth  // 画面幅
document.body      // body要素
```

## カスタム Widget のメリット

### Before（共通化前）

各画面で同じコードを繰り返し書く:

```dart
// home_page.dart
appBar: AppBar(
  title: const Text('Home'),
  flexibleSpace: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(...), // 20行のコード
    ),
  ),
)

// second_page.dart
appBar: AppBar(
  title: const Text('Second'),
  flexibleSpace: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(...), // 同じ20行のコードを繰り返し
    ),
  ),
)
```

**問題点**:
- コードの重複
- 色を変えたいとき、全ての画面を修正する必要がある

### After（共通化後）

```dart
// home_page.dart
appBar: GradientAppBar(title: 'Home'),

// second_page.dart
appBar: GradientAppBar(title: 'Second'),
```

**メリット**:
- コードがシンプル
- 色を変えたいとき、`gradient_app_bar.dart` の1箇所だけ修正すればOK
- 他の画面でも再利用できる

**Web で例えると**:
```jsx
// Before
<header style={{ background: 'linear-gradient(...)' }}>Home</header>
<header style={{ background: 'linear-gradient(...)' }}>About</header>

// After
<GradientAppBar title="Home" />
<GradientAppBar title="About" />
```

## カスタム Widget を作る流れ

1. **widgets フォルダを作成**
   ```bash
   mkdir lib/widgets
   ```

2. **Widget ファイルを作成**
   - `lib/widgets/gradient_app_bar.dart`

3. **クラスを定義**
   ```dart
   class GradientAppBar extends StatelessWidget {
     // プロパティ
     // build メソッド
   }
   ```

4. **必要なインターフェースを実装**
   - AppBar の場合: `implements PreferredSizeWidget`

5. **各画面で import して使う**
   ```dart
   import '../widgets/gradient_app_bar.dart';
   ```

## まとめ

- **カスタム Widget** = 自分専用の再利用可能な部品
- **PreferredSizeWidget** = AppBar として使えるようにするインターフェース（高さを教える必要がある）
- **kToolbarHeight** = Flutter が用意している AppBar の標準的な高さ（56px）
- **メリット** = コードの重複を減らし、メンテナンスしやすくなる

**Web で例えると**: React のカスタムコンポーネントと全く同じ考え方です。
