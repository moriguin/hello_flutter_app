# 非同期処理と await

## 基本ルール

**`async` マークがついた関数 = 非同期関数**

- `await` なし → 非同期実行（すぐ次へ進む）
- `await` あり → 同期的に待つ（完了まで待つ）

---

## Dart の例

```dart
// 非同期関数（Future を返す）
Future<void> greetAsync(String name) async {
  await Future.delayed(Duration(seconds: 1));
  print(name);
}

// await なし = 待たない
greetAsync("hoge"); // すぐ次へ
print("B");
// 実行順序: B → hoge (1秒後)

// await あり = 待つ
await greetAsync("hoge"); // 完了まで待つ
print("B");
// 実行順序: hoge (1秒後) → B
```

---

## JavaScript の例

```javascript
// 非同期関数
async function greetAsync(name) {
  await sleep(1000);
  console.log(name);
}

// await なし = 待たない
greetAsync("hoge");
console.log("B");
// → B, hoge (1秒後)

// await あり = 待つ
await greetAsync("hoge");
console.log("B");
// → hoge (1秒後), B
```

---

## 見分け方

| Dart | JavaScript |
|------|-----------|
| `Future<void> method() async` | `async function method()` |
| `Future<int> calculate() async` | `async function calculate()` |

---

## dispose() での注意点

```dart
// ❌ 問題あり
dispose() {
  setFlashMode(FlashMode.off); // await なし = 待たない
  _cameraController?.dispose(); // すぐ実行
  // → setFlashMode がまだ実行中なのにカメラが破棄される
}

// ✅ 解決策
dispose() {
  // カメラを破棄すれば自動的にフラッシュもOFFになる
  _cameraController?.dispose();
  super.dispose();
}
```
