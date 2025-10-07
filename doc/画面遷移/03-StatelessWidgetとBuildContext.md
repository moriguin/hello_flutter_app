# Q3: StatelessWidget と BuildContext

## 質問

`class MyApp extends StatelessWidget {`
ってあるけど、StatelessWidget の部分はほかの値になることもあるの？あと、

```dart
@override
Widget build(BuildContext context) {
```

も決まり文句そうだけど、BuildContext を受け取るのってどんな感じ？context 変数は build 関数内部でどのように使うの？

## 回答

### 📚 Widget の種類（継承するクラス）

#### **StatelessWidget vs StatefulWidget**

```dart
// 1. 状態を持たない（現在のコード）
class MyApp extends StatelessWidget {
  // 変更されないUI
}

// 2. 状態を持つ
class MyApp extends StatefulWidget {
  // 変更可能なUI（カウンター、フォームなど）
}
```

**Web でいうと**:

```javascript
// StatelessWidget = Reactの関数コンポーネント（useState無し）
function MyComponent() {
  return <div>固定内容</div>;
}

// StatefulWidget = Reactの関数コンポーネント（useState有り）
function MyComponent() {
  const [count, setCount] = useState(0); // 状態あり
  return <div>{count}</div>;
}
```

### 🎯 @override と build メソッド

```dart
@override  // 親クラスのメソッドを上書きする印
Widget build(BuildContext context) {  // 決まり文句
  return ...;
}
```

これは**必須の決まり文句**です。すべての Widget が持つ必要があります。

### 🔧 BuildContext の使い方

**BuildContext = 現在の Widget の位置情報と環境情報**

### 📊 context で取得できる主な情報

| 用途               | コード                                    | Web 相当                 |
| ------------------ | ----------------------------------------- | ------------------------ |
| **テーマ取得**     | `Theme.of(context)`                       | CSS 変数、useTheme()     |
| **画面サイズ**     | `MediaQuery.of(context).size`             | window.innerWidth/Height |
| **ナビゲーション** | `Navigator.of(context)`                   | useNavigate()            |
| **言語設定**       | `Localizations.of(context)`               | i18n                     |
| **親 Widget 検索** | `context.findAncestorWidgetOfExactType()` | 親コンポーネント参照     |

### 💡 StatefulWidget の場合

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
    return Column(
      children: [
        Text('カウント: $count'),
        ElevatedButton(
          onPressed: () {
            setState(() {  // 状態を更新
              count++;
            });
          },
          child: Text('増やす'),
        ),
      ],
    );
  }
}
```

**まとめ**:

- **StatelessWidget**: 状態なし（表示のみ）
- **StatefulWidget**: 状態あり（インタラクティブ）
- **context**: 現在地の情報＋アプリ全体の設定にアクセスする鍵
- **build**: すべての Widget で必須のメソッド（UI を返す）
