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
  bool _isInitialized = false;
  bool _isFlashOn = false;
  String _statusMessage = 'カメラを初期化中...';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _toggleFlash(false); // フラッシュをOFFにする
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
        _isInitialized = true;
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
            const SizedBox(height: 20),
            // ステータスメッセージ
            Text(
              _statusMessage,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // フラッシュON/OFFボタン
            if (_isInitialized)
              ElevatedButton(
                onPressed: () => _toggleFlash(!_isFlashOn),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFlashOn ? Colors.orange : Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: Text(_isFlashOn ? 'フラッシュOFF' : 'フラッシュON'),
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
