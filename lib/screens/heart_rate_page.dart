import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../widgets/gradient_app_bar.dart';

/// 脈拍測定画面
class HeartRatePage extends StatefulWidget {
  const HeartRatePage({super.key});

  @override
  State<HeartRatePage> createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  CameraController? _cameraController;
  bool _isFlashOn = false;
  String _statusMessage = 'カメラを初期化中...';

  // 測定関連の状態
  bool _isMeasuring = false; // 測定中かどうか
  int _heartRate = 0; // 測定結果（BPM）

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    // setState() を呼ばずに直接フラッシュをOFFにする
    // _cameraController?.setFlashMode(FlashMode.off);
    _cameraController?.dispose();
    super.dispose();
  }

  /// フラッシュライトのON/OFF切り替え
  Future<void> _toggleFlash(bool turnOn) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      await _cameraController!.setFlashMode(
        turnOn ? FlashMode.torch : FlashMode.off,
      );
      setState(() {
        _isFlashOn = turnOn;
        _statusMessage = turnOn
            ? 'フラッシュとカメラに指を当ててください'
            : 'フラッシュをONにして測定を開始してください';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'フラッシュの切り替えに失敗しました: $e';
      });
    }
  }

  /// 測定開始
  void _startMeasurement() {
    if (!_isFlashOn) {
      setState(() {
        _statusMessage = '先にフラッシュをONにしてください';
      });
      return;
    }

    setState(() {
      _isMeasuring = true;
      _heartRate = 0;
      _statusMessage = '測定中... 指をカメラとフラッシュに当ててください';
    });

    print('【測定開始】');

    // 画像ストリームの取得開始
    _cameraController!.startImageStream((CameraImage image) {
      // 赤色成分の抽出
      double redValue = _extractRedAverage(image);
      print('【赤色平均】$redValue');
      // TODO: 次のステップでデータを蓄積
    });
  }

  /// 測定停止
  void _stopMeasurement() {
    // 画像ストリームの停止
    _cameraController!.stopImageStream();

    setState(() {
      _isMeasuring = false;
      _statusMessage = '測定を停止しました';
    });

    print('【測定停止】');
  }

  /// 画像から赤色の平均値を抽出
  double _extractRedAverage(CameraImage image) {
    // YUVフォーマットのY平面（明度）を使用
    final Uint8List yPlane = image.planes[0].bytes;
    final int totalPixels = image.width * image.height;

    int sum = 0;
    for (int i = 0; i < yPlane.length; i++) {
      sum += yPlane[i];
    }

    // 平均値を返す（0〜255）
    return sum / totalPixels;
  }

  /// カメラの初期化
  Future<void> _initializeCamera() async {
    try {
      // 利用可能なカメラを取得
      final cameras = await availableCameras();

      // 背面カメラを選択
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      // カメラコントローラーを初期化
      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.low, // 脈拍測定には低解像度で十分
        enableAudio: false,
      );

      await _cameraController!.initialize();

      setState(() {
        _statusMessage = 'フラッシュをONにして測定を開始してください';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'カメラの初期化に失敗しました: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: '脈拍測定'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // カメラプレビュー
            if (_cameraController?.value.isInitialized == true)
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
            const SizedBox(height: 20),
            // ステータスメッセージ
            Text(
              _statusMessage,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // 心拍数表示
            if (_heartRate > 0)
              Text(
                '$_heartRate BPM',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            const SizedBox(height: 20),
            // フラッシュON/OFFボタン（測定中は非表示）
            if (_cameraController?.value.isInitialized == true && !_isMeasuring)
              ElevatedButton(
                onPressed: () => _toggleFlash(!_isFlashOn),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFlashOn ? Colors.orange : Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: Text(_isFlashOn ? 'フラッシュOFF' : 'フラッシュON'),
              ),
            const SizedBox(height: 10),
            // 測定開始/停止ボタン
            if (_cameraController?.value.isInitialized == true)
              ElevatedButton(
                onPressed: _isMeasuring ? _stopMeasurement : _startMeasurement,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isMeasuring ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  _isMeasuring ? '測定停止' : '測定開始',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            const SizedBox(height: 10),
            // 戻るボタン
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
