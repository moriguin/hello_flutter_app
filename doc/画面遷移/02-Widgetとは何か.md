# Q2: Widget とは何か

## 質問

ルート Widget って言ってたけど、Widget とは何？

## 回答

### 🧩 Widget = UI を構成するすべての部品

**Widget（ウィジェット）**は、Flutter における**UI の最小単位**です。画面に表示されるものはすべて Widget！

- Widget = UI 部品の総称
- 文字も、ボタンも、レイアウトも、画面全体も、**すべて Widget**
- HTML タグ + React コンポーネントを統一した概念と考えるとわかりやすい！

### 📦 Widget の種類

#### 基本 Widget（HTML 要素相当）

```dart
Text('Hello')           // <span>Hello</span>
Container()             // <div></div>
Image.asset('pic.png')  // <img src="pic.png">
```

#### レイアウト Widget（CSS 相当）

```dart
Row()                   // display: flex; flex-direction: row;
Column()                // display: flex; flex-direction: column;
Padding()               // padding: 16px;
Center()                // display: flex; justify-content: center;
```

#### 複合 Widget（コンポーネント相当）

```dart
Scaffold()              // ページレイアウト全体
AppBar()                // ヘッダーコンポーネント
Card()                  // カードUI
```

### 🌲 Widget ツリー

```dart
MyApp                   // ルートWidget
 └── MaterialApp        // アプリWidget
      └── HomePage      // ページWidget
           └── Scaffold // レイアウトWidget
                ├── AppBar     // Widget
                └── Center     // Widget
                     └── Text  // Widget
```

### 💡 重要な特徴

| 特徴                  | 説明                                      | Web 相当                   |
| --------------------- | ----------------------------------------- | -------------------------- |
| **すべてが Widget**   | ボタンも、余白も、配置も Widget           | すべてがコンポーネント     |
| **不変（Immutable）** | 一度作った Widget は変更不可              | React の関数コンポーネント |
| **組み合わせ可能**    | Widget を組み合わせて新しい Widget を作る | コンポーネントの組み合わせ |
| **再利用可能**        | 自作 Widget を何度でも使える              | React コンポーネント       |

### 🎯 カスタム Widget の作成

```dart
// 自作Widget = Reactコンポーネント作成と同じ
class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(      // Widget
      child: Text('Click'), // Widget
    );
  }
}

// 使用
MyButton()  // 新しいWidget！
```
