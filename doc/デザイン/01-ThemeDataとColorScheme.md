# ThemeData と ColorScheme の解説

## ThemeData とは？

**アプリ全体のデザインルール（色、フォント、ボタンの形など）を一箇所でまとめて設定するもの**

**Web で例えると**: CSS の変数や Tailwind の config ファイルのようなもの

```javascript
// Web の例（CSS変数）
:root {
  --primary-color: #6366F1;
  --background: white;
  --font-size: 16px;
}

// Tailwind config
module.exports = {
  theme: {
    colors: {
      primary: '#6366F1',
    }
  }
}
```

## Flutter での ThemeData

### 基本構造

```dart
return MaterialApp(
  title: 'Hello Flutter App',
  theme: ThemeData(  // ← アプリ全体のテーマ設定
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6366F1),
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  ),
  // ...
);
```

### 階層構造

```
MaterialApp (アプリ全体)
├─ theme: ThemeData(...) ← ここで設定したルールが全画面に適用される
│   ├─ colorScheme: 色のセット（primary, surface など）
│   ├─ useMaterial3: デザインシステムのバージョン
│   ├─ appBarTheme: AppBar のデフォルト設定（追加可能）
│   ├─ buttonTheme: ボタンのデフォルト設定（追加可能）
│   └─ textTheme: フォントのデフォルト設定（追加可能）
│
├─ HomePage
│   └─ AppBar ← theme で設定した色を使う
│       backgroundColor: Theme.of(context).colorScheme.inversePrimary
│                         ↑ ThemeData の colorScheme から色を取得
│
└─ SecondPage
    └─ AppBar ← 同じく theme の設定を使う
```

## ColorScheme（カラースキーム）

### 20〜30色システム

`ColorScheme.fromSeed()` で **seedColor（種の色）を1つ指定** すると、**役割別に20〜30色が自動生成**されます。

```dart
ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1))
↓ これで約30色が自動生成される
```

**Web で例えると**:
```javascript
// Tailwind CSS のイメージ
indigo-500 を指定
↓
indigo-50, indigo-100, indigo-200, ... indigo-900 が自動で使える
```

### 主要な色（よく使う）

| 色の名前 | 役割 | 具体例 | 実際の色（Indigo の場合） |
|---------|------|--------|------------------------|
| `primary` | メインカラー | ボタン、強調部分 | `#6366F1` (濃い青紫) |
| `onPrimary` | primary の上のテキスト | ボタンの文字 | `#FFFFFF` (白) |
| `primaryContainer` | primary の背景 | カード、薄い背景 | `#E0E7FF` (すごく薄い青紫) |
| `onPrimaryContainer` | primaryContainer の上のテキスト | カード内の文字 | `#1E1B4B` (濃い紫) |
| `surface` | 基本の背景色 | 画面背景、カード | `#FFFFFF` (白) |
| `onSurface` | surface の上のテキスト | 通常のテキスト | `#1C1B1F` (黒っぽい) |
| `inversePrimary` | primary の補色 | AppBar のデフォルト | `#A5B4FC` (中間の薄い青紫) |

### 全30色のリスト

#### メイン色（6色）
1. `primary` - メインカラー
2. `onPrimary` - primary の上の文字色
3. `primaryContainer` - primary の薄い背景
4. `onPrimaryContainer` - primaryContainer の上の文字色
5. `inversePrimary` - primary の補色
6. `primaryFixed` / `primaryFixedDim` (Material 3 用)

#### サブ色（4色）
7. `secondary` - サブカラー
8. `onSecondary`
9. `secondaryContainer`
10. `onSecondaryContainer`

#### 第3の色（4色）
11. `tertiary` - 第3のアクセントカラー
12. `onTertiary`
13. `tertiaryContainer`
14. `onTertiaryContainer`

#### エラー色（2色）
15. `error` - エラー表示
16. `onError`

#### 背景・サーフェス色（4色以上）
17. `surface` - 基本背景
18. `onSurface` - surface 上の文字
19. `surfaceVariant` - 別の背景色
20. `onSurfaceVariant`
21. `inverseSurface`
22. `onInverseSurface`

#### その他
23. `outline` - 境界線
24. `outlineVariant`
25. `shadow` - 影
26. `scrim` - オーバーレイ
27. `surfaceTint` - サーフェス着色

### 「on〇〇」の命名ルール

**重要**: `on` が付く色は「〇〇の上に乗せるテキスト色」という意味

```dart
// 例1: primary（濃い青紫）の上に白文字
Container(
  color: Theme.of(context).colorScheme.primary,  // 背景: 濃い青紫
  child: Text(
    'Hello',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,  // 文字: 白
    ),
  ),
)

// 例2: surface（白）の上に黒文字
Container(
  color: Theme.of(context).colorScheme.surface,  // 背景: 白
  child: Text(
    'Hello',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSurface,  // 文字: 黒っぽい
    ),
  ),
)
```

**Web で例えると**:
```css
.primary-button {
  background: var(--primary);  /* 濃い青紫 */
  color: var(--on-primary);    /* 白 */
}
```

## seedColor の変え方

### 方法1: カラーコードで指定

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF6366F1), // Indigo
),
```

### 方法2: Flutter の定義済み色

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue,     // 青
  // seedColor: Colors.red,    // 赤
  // seedColor: Colors.green,  // 緑
  // seedColor: Colors.purple, // 紫
  // seedColor: Colors.teal,   // ティール
  // seedColor: Colors.orange, // オレンジ
),
```

### 色の例

```dart
// ピンク系
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFFEC4899), // Pink
),

// 緑系
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF10B981), // Emerald
),

// オレンジ系
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFFF97316), // Orange
),
```

## ThemeData の使い方

### 各画面で色を使う

```dart
// テキストに色を適用
Text(
  'Hello',
  style: TextStyle(
    color: Theme.of(context).colorScheme.primary,
  ),
)

// Container に背景色を適用
Container(
  color: Theme.of(context).colorScheme.surface,
  child: Text('Content'),
)
```

`Theme.of(context)` = 「このアプリの ThemeData を取得して」という意味

### ThemeData に追加設定

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6366F1),
  ),
  useMaterial3: true,

  // AppBar のデフォルトを設定
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF6366F1),
    foregroundColor: Colors.white,
    elevation: 0,
  ),

  // ボタンのデフォルトを設定
  elevatedButtonTheme: ElevatedButtonThemeData(...),

  // フォントのデフォルトを設定
  textTheme: TextTheme(...),
),
```

## 参考リンク

### 公式ドキュメント
- [ColorScheme クラス](https://api.flutter.dev/flutter/material/ColorScheme-class.html) - 全ての色名が載っている
- [Material Design 3 色システム](https://m3.material.io/styles/color/roles) - 図解付き解説

### カラーパレット生成ツール
- [Material Theme Builder](https://m3.material.io/theme-builder#/custom) - seedColor を選ぶと全色が視覚的に確認できる（おすすめ）
- [Coolors](https://coolors.co/) - カラーパレット作成
- [Tailwind CSS Colors](https://tailwindcss.com/docs/customizing-colors) - 色の参考に

## まとめ

1. **ThemeData** = アプリ全体のデザインルールブック（一箇所で設定、全画面に適用）
2. **ColorScheme** = 1色（seedColor）から約30色を自動生成するシステム
3. **on〇〇** = 「〇〇の上に乗せる文字色」という命名ルール
4. **Theme.of(context)** = 各画面で ThemeData の設定を取得して使う
5. **seedColor 変更** = カラーコード変えるだけで全体の雰囲気が変わる
