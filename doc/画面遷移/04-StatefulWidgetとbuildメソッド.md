# Q4: StatefulWidget と build メソッド

## 質問

💡 StatefulWidget の場合は以下のように書いてくれましたが、
StatefulWidget の場合はクラスを二つ定義する必要があるとして、
UI を表現するクラスにはすべて`Widget build(BuildContext context) {`を定義するってことだよね？
JSX を return するみたいに

```dart
// StatefulWidgetは2つのクラスが必要
class CounterPage extends StatefulWidget {
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int count = 0;  // 状態（state）

  @override
  Widget build(BuildContext context) {  // buildは同じ
```

## 回答

### ✅ その通りです！

**UI を返すクラスには必ず `Widget build(BuildContext context)` が必要**です。

- `build` メソッド = JSX を返す部分
- **UI を表示する責任があるクラス**には必ず `build` がある
- StatefulWidget の場合、UI は`State`クラスの方に書く

### 📊 整理すると

#### **StatelessWidget**（1 クラス）

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {  // ← UIを返す
    return Text('Hello');
  }
}
```

#### **StatefulWidget**（2 クラス）

```dart
// 1. 設定クラス（UIなし）
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();  // Stateクラスを作るだけ
}

// 2. 状態＋UIクラス
class _MyPageState extends State<MyPage> {
  int count = 0;  // 状態

  @override
  Widget build(BuildContext context) {  // ← UIを返すのはこっち！
    return Text('Count: $count');
  }
}
```

### 🎯 ルール

| クラス              | build メソッド | 役割                   |
| ------------------- | -------------- | ---------------------- |
| **StatelessWidget** | **あり** ✅    | UI を返す              |
| **StatefulWidget**  | **なし** ❌    | State クラスを作るだけ |
| **State<T>**        | **あり** ✅    | UI を返す              |

### 💡 Web 開発との対比

```javascript
// React関数コンポーネント
function MyComponent() {
  const [count, setCount] = useState(0);

  return <div>Count: {count}</div>; // ← JSXを返す
}
```

```dart
// Flutter StatefulWidget
class _MyPageState extends State<MyPage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');  // ← Widgetを返す（JSXのように）
  }
}
```
