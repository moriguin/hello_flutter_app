# FPS (Frames Per Second)

## 基本概念

**FPS = 1秒間に何枚の画像（フレーム）を撮影・表示するか**

- **F**rames **P**er **S**econd（フレーム毎秒）
- 30 FPS = 1秒間に30枚の静止画を撮影
- 動画 = フレームを連続表示したもの

---

## 具体例

### 30 FPS の動作
```
0.00秒: 📷 (1枚目)
0.03秒: 📷 (2枚目)
0.06秒: 📷 (3枚目)
...
1.00秒: 📷 (30枚目)
```

**1フレーム = 約33ミリ秒 (1000ms ÷ 30 = 33ms)**

---

## 一般的な FPS

| FPS | 用途 | 滑らかさ |
|-----|------|---------|
| 24 FPS | 映画 | 標準 |
| 30 FPS | TV、YouTube、カメラ | 普通 |
| 60 FPS | ゲーム、スポーツ | 滑らか |
| 120 FPS | ハイエンドゲーム | 超滑らか |

---

## 脈拍測定での FPS

### なぜ 30 FPS で十分？
- 脈拍は1秒に1〜2回程度（60〜120 BPM）
- 30 FPS = 1秒に30回サンプリング → 十分検出できる

### データ量の計算
```
30 FPS × 10秒間の測定 = 300フレーム（300枚の画像データ）
```

### 最適化（間引き処理）
```
// 3フレームに1回だけ処理
30 FPS ÷ 3 = 10 FPS（実質的な処理レート）
10 FPS × 10秒 = 100回の計算

理由: 30FPSは処理が重い、10FPSでも精度は十分
```

---

## Flutter での実装

### カメラのフレーム取得
```dart
// startImageStream で各フレームを取得
_cameraController.startImageStream((CameraImage image) {
  // このコールバックが1秒に約30回呼ばれる（30 FPS）
  processFrame(image);
});
```

### フレームレート調整
```dart
int _frameCounter = 0;

void processFrame(CameraImage image) {
  _frameCounter++;

  // 3フレームに1回だけ処理（30FPS → 10FPS）
  if (_frameCounter % 3 != 0) return;

  // 実際の処理
  double red = getRedAverage(image);
}
```

---

## Web開発との対応

### JavaScript の例
```javascript
// 30 FPS = 約33ミリ秒ごとに1フレーム
setInterval(() => {
  captureFrame();
}, 33); // 1000ms ÷ 30 = 33ms

// ブラウザの requestAnimationFrame は通常60FPS
requestAnimationFrame(render); // 16ms ごと (1000 ÷ 60)
```

---

## まとめ

| 用語 | 意味 |
|------|------|
| **FPS** | Frames Per Second（フレーム毎秒） |
| **30 FPS** | 1秒間に30枚の画像を撮影・表示 |
| **1フレーム** | 1枚の静止画 |
| **動画** | フレームを連続で表示したもの |

**脈拍測定の流れ:**
```
30FPSでカメラ撮影
  ↓
各フレームから赤色成分を抽出
  ↓
時系列データとして蓄積
  ↓
ピーク検出 → BPM計算
```
