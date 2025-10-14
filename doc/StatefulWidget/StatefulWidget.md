# StatefulWidget のライフサイクル

## 概要

`StatefulWidget` は状態を持つウィジェットで、`State` クラスを継承したクラスで状態を管理します。

```dart
class HeartRatePage extends StatefulWidget {
  @override
  State<HeartRatePage> createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  // State クラスが提供する主要メソッド:
  // - setState()
  // - initState()
  // - dispose()
  // - build()
}
```

## State クラスの主要メソッド

### 1. initState() - 初期化

**いつ呼ばれる？**
- ウィジェットが画面に表示される直前（1回だけ）

**用途:**
- API呼び出し
- カメラ/センサーの初期化
- タイマーの開始
- データの取得

**実装例:**
```dart
@override
void initState() {
  super.initState();  // 必ず最初に呼ぶ
  _initializeCamera();
}
```

**Web開発との比較:**

| Flutter | React (Class) | React (Hooks) |
|---------|---------------|---------------|
| `initState()` | `componentDidMount()` | `useEffect(() => {}, [])` |

---

### 2. dispose() - クリーンアップ

**いつ呼ばれる？**
- ウィジェットが画面から削除される直前（1回だけ）

**用途:**
- リソースの解放（カメラ、タイマー、リスナー）
- メモリリーク防止
- 接続の切断

**実装例:**
```dart
@override
void dispose() {
  _toggleFlash(false);           // フラッシュをOFF
  _cameraController?.dispose();  // カメラを停止
  super.dispose();                // 必ず最後に呼ぶ
}
```

**Web開発との比較:**

| Flutter | React (Class) | React (Hooks) |
|---------|---------------|---------------|
| `dispose()` | `componentWillUnmount()` | `useEffect` の cleanup 関数 |

```javascript
// React Hooks の例
useEffect(() => {
  return () => {  // ← cleanup関数（dispose相当）
    cameraController.dispose();
  };
}, []);
```

---

### 3. build() - UI構築

**いつ呼ばれる？**
- 初回表示時
- `setState()` が呼ばれた時
- 親ウィジェットが再構築された時

**用途:**
- ウィジェットツリーの構築
- UIの描画

**実装例:**
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('タイトル')),
    body: Center(child: Text('コンテンツ')),
  );
}
```

**Web開発との比較:**

| Flutter | React (Class) | React (Hooks) |
|---------|---------------|---------------|
| `build()` | `render()` | 関数コンポーネント本体 |

```javascript
// React Hooks の例
function MyComponent() {
  return <div>...</div>;  // ← この部分が build() 相当
}
```

---

### 4. setState() - 状態更新

**何をする？**
- 状態を変更して `build()` を再実行
- 画面を更新する唯一の方法

**実装例:**
```dart
setState(() {
  _isFlashOn = true;
  _statusMessage = '更新しました';
});
```

**重要:** `setState()` を使わないと画面は更新されない

```dart
// ❌ これでは画面は更新されない
_isFlashOn = true;

// ✅ setState() を使う必要がある
setState(() {
  _isFlashOn = true;
});
```

**Web開発との比較:**

| Flutter | React (Class) | React (Hooks) |
|---------|---------------|---------------|
| `setState()` | `this.setState()` | `setXxx()` |

```javascript
// React Hooks の例
const [isFlashOn, setIsFlashOn] = useState(false);
setIsFlashOn(true);  // ← setState() 相当
```

---

## ライフサイクルの流れ

```
1. ウィジェット作成
   ↓
2. initState() 呼ばれる  ← カメラ初期化など（1回だけ）
   ↓
3. build() 呼ばれる      ← 初回描画
   ↓
4. ユーザー操作など
   ↓
5. setState() 呼ばれる   ← 状態変更
   ↓
6. build() 再実行        ← 再描画
   ↓
   (4〜6を繰り返す)
   ↓
7. dispose() 呼ばれる    ← カメラ停止など（1回だけ）
   ↓
8. ウィジェット削除
```

## 実装例（heart_rate_page.dart）

```dart
class _HeartRatePageState extends State<HeartRatePage> {
  // 状態変数
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isFlashOn = false;
  String _statusMessage = 'カメラを初期化中...';

  // 【1回だけ】画面表示時
  @override
  void initState() {
    super.initState();
    _initializeCamera();  // カメラを起動
  }

  // 【1回だけ】画面削除時
  @override
  void dispose() {
    _toggleFlash(false);           // フラッシュOFF
    _cameraController?.dispose();  // カメラ停止
    super.dispose();
  }

  // カメラ初期化（非同期処理）
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.low,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    // 状態更新（画面を再描画）
    setState(() {
      _isInitialized = true;
      _statusMessage = 'フラッシュをONにして測定を開始してください';
    });
  }

  // フラッシュON/OFF
  Future<void> _toggleFlash(bool turnOn) async {
    await _cameraController!.setFlashMode(
      turnOn ? FlashMode.torch : FlashMode.off,
    );

    // 状態更新（画面を再描画）
    setState(() {
      _isFlashOn = turnOn;
      _statusMessage = turnOn
          ? 'フラッシュとカメラに指を当ててください'
          : 'フラッシュをONにして測定を開始してください';
    });
  }

  // 【何度も】setState() や親の変更で呼ばれる
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: '脈拍測定'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // カメラプレビュー or ローディング
            if (_isInitialized && _cameraController != null)
              SizedBox(
                width: 300,
                height: 300,
                child: CameraPreview(_cameraController!),
              )
            else
              const SizedBox(
                width: 300,
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              ),

            // ステータスメッセージ
            Text(_statusMessage),

            // フラッシュON/OFFボタン
            if (_isInitialized)
              ElevatedButton(
                onPressed: () => _toggleFlash(!_isFlashOn),
                child: Text(_isFlashOn ? 'フラッシュOFF' : 'フラッシュON'),
              ),
          ],
        ),
      ),
    );
  }
}
```

## よくあるミス

### ❌ dispose() を忘れる

```dart
// カメラを止めずに画面を閉じる
// → カメラが動きっぱなし
// → バッテリー消費
// → メモリリーク
```

**解決策:** 必ず `dispose()` でリソースを解放する

---

### ❌ initState() で async/await を直接使う

```dart
// ❌ 間違い
@override
void initState() async {  // async は付けられない！
  await _initializeCamera();
}

// ✅ 正しい
@override
void initState() {
  super.initState();
  _initializeCamera();  // async関数を呼ぶだけ
}
```

---

### ❌ setState() を忘れる

```dart
// ❌ 間違い
void _toggleFlash(bool turnOn) async {
  await _cameraController!.setFlashMode(
    turnOn ? FlashMode.torch : FlashMode.off,
  );
  _isFlashOn = turnOn;  // ← setState() を忘れている！
  // 結果: フラッシュは切り替わるけど、ボタンの表示は変わらない
}

// ✅ 正しい
void _toggleFlash(bool turnOn) async {
  await _cameraController!.setFlashMode(
    turnOn ? FlashMode.torch : FlashMode.off,
  );
  setState(() {
    _isFlashOn = turnOn;  // ← setState() で囲む
  });
  // 結果: フラッシュも切り替わり、ボタンの表示も更新される
}
```

---

### ❌ super.initState() / super.dispose() を忘れる

```dart
// ❌ 間違い
@override
void initState() {
  // super.initState() を忘れている
  _initializeCamera();
}

// ✅ 正しい
@override
void initState() {
  super.initState();  // 必ず最初に呼ぶ
  _initializeCamera();
}

@override
void dispose() {
  _cameraController?.dispose();
  super.dispose();  // 必ず最後に呼ぶ
}
```

---

## StatelessWidget との使い分け

### StatelessWidget を使う場合
- 状態が変わらない
- 親から受け取ったデータを表示するだけ
- 例: 固定のヘッダー、アイコン

```dart
class MyStaticWidget extends StatelessWidget {
  final String title;

  const MyStaticWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
```

### StatefulWidget を使う場合
- 状態が変わる
- ユーザー入力、タイマー、API呼び出しなど
- 例: フォーム、カメラ画面、カウンター

```dart
class MyDynamicWidget extends StatefulWidget {
  @override
  State<MyDynamicWidget> createState() => _MyDynamicWidgetState();
}

class _MyDynamicWidgetState extends State<MyDynamicWidget> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => setState(() => _counter++),
      child: Text('$_counter'),
    );
  }
}
```

---

## まとめ

### StatefulWidget の3大メソッド

| メソッド | 呼ばれるタイミング | 用途 |
|---------|------------------|------|
| `initState()` | 画面表示時（1回） | 初期化 |
| `dispose()` | 画面削除時（1回） | クリーンアップ |
| `build()` | 初回 & `setState()` 時 | UI構築 |

### 重要ポイント

1. **状態を変更するときは必ず `setState()` で囲む**
   - これを忘れると画面が更新されない

2. **`dispose()` でリソースを必ず解放する**
   - メモリリーク防止

3. **`initState()` / `dispose()` で `super` を呼ぶ**
   - `super.initState()` は最初
   - `super.dispose()` は最後

4. **`initState()` に `async` は付けられない**
   - async 関数を呼ぶだけにする

### Web開発との対応表

| Flutter | React (Hooks) | 説明 |
|---------|---------------|------|
| `StatefulWidget` | `useState` を使うコンポーネント | 状態を持つコンポーネント |
| `initState()` | `useEffect(() => {}, [])` | 初回のみ実行 |
| `dispose()` | `useEffect` の cleanup | クリーンアップ |
| `setState()` | `setXxx()` | 状態更新 |
| `build()` | 関数コンポーネント本体 | UI描画 |
