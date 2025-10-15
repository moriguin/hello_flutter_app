# 非同期処理と await

## 基本ルール

**`async` マークがついた関数 = 非同期関数**

- `await` なし → 非同期実行（すぐ次へ進む）
- `await` あり → 同期的に待つ（完了まで待つ）

---

## Dart の例

```dart
Future<void> greetAsync(String name) async {
  await Future.delayed(Duration(seconds: 1));
  print(name);
}

// await なし
greetAsync("hoge");
print("B");
// 実行順序: B → hoge (1秒後)

// await あり
await greetAsync("hoge"); // 完了まで待つ
print("B");
// 実行順序: hoge (1秒後) → B
```

---

## JavaScript と一緒

```javascript
// 非同期関数
async function greetAsync(name) {
  await sleep(1000);
  console.log(name);
}

// await なし
greetAsync("hoge");
console.log("B");
// → B, hoge (1秒後)

// await あり
await greetAsync("hoge");
console.log("B");
// → hoge (1秒後), B
```

---

## async と Future の関係

- **`async` をつけると自動的に `Future` を返さないといけない**
- await を使いたい → async が必須
- async と Future はセット

```dart
// ✅ OK: async があれば await が使える
Future<void> method() async {
  await something();
}

// ✅ OK:async なし（手動で Future を返す）
Future<void> method() {
  return something();
}

// ❌ NG例1: async なしで await を使う
void method() {
  await something(); // エラー！async がないと await は使えない
}

// ❌ NG例2: async なしで await を使う（Future 付き）
Future<void> method() {
  await something(); // エラー！async がないと await は使えない
}
```

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
