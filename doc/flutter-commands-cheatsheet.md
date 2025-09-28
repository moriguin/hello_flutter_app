# Flutter & ADB コマンド チートシート

## 📱 Flutter コマンド

### 基本的なコマンド

#### プロジェクト管理
```bash
# 新規プロジェクト作成
flutter create my_app

# 依存関係インストール（npm install相当）
flutter pub get

# 依存関係の更新（npm update相当）
flutter pub upgrade

# 古い依存関係の確認
flutter pub outdated

# キャッシュクリア（node_modules削除相当）
flutter clean
```

#### 開発・実行
```bash
# アプリ実行（npm run dev相当）
flutter run

# リリースモードで実行（最適化済み）
flutter run --release

# デバッグモードで実行（デフォルト）
flutter run --debug

# プロファイルモードで実行（パフォーマンス分析用）
flutter run --profile

# ホットリロード（実行中に「r」キー）
# ホットリスタート（実行中に「R」キー）
# 終了（実行中に「q」キー）
```

#### デバイス指定実行
```bash
# 利用可能なデバイス一覧
flutter devices

# Chrome で実行
flutter run -d chrome

# Windowsアプリとして実行
flutter run -d windows

# 特定のエミュレータで実行
flutter run -d emulator-5554

# すべてのデバイスで同時実行
flutter run -d all
```

### ビルド関連

#### Android ビルド
```bash
# APKファイル作成（Android向け）
flutter build apk

# 分割APK作成（サイズ最適化）
flutter build apk --split-per-abi

# App Bundle作成（Google Play推奨）
flutter build appbundle

# デバッグ版APK作成
flutter build apk --debug
```

#### iOS ビルド（Mac必須）
```bash
# iOSアプリビルド
flutter build ios

# iOS Simulator向けビルド
flutter build ios --simulator

# IPAファイル作成
flutter build ipa
```

#### Web ビルド
```bash
# Web版ビルド（dist/相当を生成）
flutter build web

# 特定のレンダラーを使用
flutter build web --web-renderer html    # HTML renderer
flutter build web --web-renderer canvaskit # CanvasKit renderer

# base hrefを指定（サブディレクトリ配置用）
flutter build web --base-href /myapp/
```

#### デスクトップビルド
```bash
# Windows実行ファイル作成
flutter build windows

# macOSアプリ作成
flutter build macos

# Linuxアプリ作成
flutter build linux
```

### テスト・品質管理

```bash
# すべてのテスト実行（npm test相当）
flutter test

# 特定のテストファイル実行
flutter test test/widget_test.dart

# カバレッジ付きテスト
flutter test --coverage

# 継続的にテスト実行（--watch相当）
flutter test --watch

# 静的解析（ESLint相当）
flutter analyze

# コードフォーマット（Prettier相当）
dart format .

# 修正可能な問題を自動修正
dart fix --apply
```

### プロジェクト情報・診断

```bash
# Flutter環境診断
flutter doctor

# 詳細な診断情報
flutter doctor -v

# Flutter/Dartバージョン確認
flutter --version

# プロジェクトの依存関係ツリー表示
flutter pub deps

# チャンネル切り替え（安定版/ベータ版など）
flutter channel stable
flutter channel beta
flutter channel master

# Flutterアップデート
flutter upgrade
```

## 🤖 ADB (Android Debug Bridge) コマンド

### デバイス管理

```bash
# 接続中のデバイス一覧
adb devices

# デバイスの詳細情報
adb devices -l

# Wi-Fi経由でデバイス接続
adb connect 192.168.1.100:5555

# デバイス切断
adb disconnect

# USB経由の接続に戻す
adb usb

# デバイス再起動
adb reboot

# リカバリーモードで再起動
adb reboot recovery

# ブートローダーで再起動
adb reboot bootloader
```

### アプリ管理

```bash
# APKインストール
adb install app.apk

# 再インストール（データ保持）
adb install -r app.apk

# アンインストール
adb uninstall com.example.app

# インストール済みパッケージ一覧
adb shell pm list packages

# サードパーティアプリのみ表示
adb shell pm list packages -3

# 特定アプリの詳細情報
adb shell pm dump com.example.app

# アプリ強制終了
adb shell am force-stop com.example.app

# アプリ起動
adb shell am start -n com.example.app/.MainActivity

# アプリのデータクリア
adb shell pm clear com.example.app
```

### ファイル操作

```bash
# デバイスからファイル取得（pull）
adb pull /sdcard/file.txt ./

# デバイスへファイル送信（push）
adb push file.txt /sdcard/

# デバイス内のファイル一覧
adb shell ls /sdcard/

# スクリーンショット撮影
adb shell screencap /sdcard/screenshot.png
adb pull /sdcard/screenshot.png ./

# 画面録画（最大3分）
adb shell screenrecord /sdcard/video.mp4
# Ctrl+C で停止
adb pull /sdcard/video.mp4 ./
```

### ログ・デバッグ

```bash
# ログ表示（console.log相当）
adb logcat

# アプリ指定でログ表示
adb logcat --pid=$(adb shell pidof com.example.app)

# ログレベルでフィルタ
adb logcat *:E  # エラーのみ
adb logcat *:W  # 警告以上
adb logcat *:I  # 情報以上

# タグでフィルタ
adb logcat -s MyApp:V

# ログクリア
adb logcat -c

# ログをファイルに保存
adb logcat > logs.txt

# Flutterアプリのログ
adb logcat -s flutter
```

### シェルコマンド

```bash
# デバイスのシェルに入る
adb shell

# コマンド直接実行
adb shell getprop ro.product.model  # デバイスモデル
adb shell getprop ro.build.version.release  # Androidバージョン

# メモリ情報
adb shell dumpsys meminfo com.example.app

# バッテリー情報
adb shell dumpsys battery

# CPU情報
adb shell top

# ストレージ情報
adb shell df

# 実行中のサービス
adb shell dumpsys activity services
```

### ネットワーク関連

```bash
# ポートフォワード設定
adb forward tcp:8080 tcp:8080

# リバースポートフォワード
adb reverse tcp:3000 tcp:3000

# Wi-Fi設定確認
adb shell dumpsys wifi

# ネットワーク状態
adb shell netstat

# 機内モードON/OFF
adb shell settings put global airplane_mode_on 1
adb shell settings put global airplane_mode_on 0
```

## 🎯 Web開発者向け対応表

| 用途 | Web開発 | Flutter/ADB |
|------|---------|-------------|
| 依存関係インストール | `npm install` | `flutter pub get` |
| 開発サーバー起動 | `npm run dev` | `flutter run` |
| ビルド | `npm run build` | `flutter build web` |
| テスト実行 | `npm test` | `flutter test` |
| リンター | `npm run lint` | `flutter analyze` |
| フォーマッター | `prettier --write .` | `dart format .` |
| ログ確認 | Chrome DevTools Console | `adb logcat` |
| デバッグ | Chrome DevTools | Flutter DevTools |
| ホットリロード | HMR | Flutter Hot Reload (r) |
| パッケージ追加 | `npm install package` | `flutter pub add package` |
| パッケージ削除 | `npm uninstall package` | `flutter pub remove package` |

## 💡 便利な使い方・Tips

### よく使う組み合わせ

```bash
# クリーンビルド（完全リビルド）
flutter clean && flutter pub get && flutter run

# リリース用APK作成の流れ
flutter clean
flutter pub get
flutter build apk --release

# デバイスログを見ながら実行
# ターミナル1
adb logcat -s flutter

# ターミナル2
flutter run
```

### トラブルシューティング

```bash
# 「デバイスが見つからない」時
adb kill-server
adb start-server
flutter doctor

# キャッシュ関連の問題
flutter clean
flutter pub cache repair
flutter pub get

# iOS関連の問題（Mac）
cd ios && pod install && cd ..

# ビルドエラーの詳細表示
flutter build apk --verbose

# 古いDartコードの移行
dart migrate
```

### デバッグ用ショートカット（flutter run実行中）

| キー | 動作 |
|------|------|
| `r` | ホットリロード（状態保持） |
| `R` | ホットリスタート（状態リセット） |
| `h` | ヘルプ表示 |
| `d` | デタッチ（切断） |
| `c` | コンソールクリア |
| `q` | 終了 |
| `p` | デバッグペイント表示 |
| `o` | iOS/Android切り替え |
| `P` | パフォーマンスオーバーレイ |

### VS Code統合コマンド

```bash
# VS Codeでプロジェクト開く
code .

# Flutter拡張機能でデバッグ実行
# F5キー または
# 実行 > デバッグの開始

# コマンドパレット（Ctrl+Shift+P）
# > Flutter: Run Flutter Doctor
# > Flutter: Select Device
# > Flutter: Hot Reload
```

## 📚 参考リンク

- [Flutter公式ドキュメント](https://flutter.dev/docs)
- [ADB公式ドキュメント](https://developer.android.com/studio/command-line/adb)
- [Pub.dev（パッケージリポジトリ）](https://pub.dev/)
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools)

## 🔧 環境変数設定

```bash
# Windows (PowerShell)
$env:PATH += ";C:\flutter\bin"
$env:PATH += ";C:\android-sdk\platform-tools"

# Windows (Command Prompt)
set PATH=%PATH%;C:\flutter\bin
set PATH=%PATH%;C:\android-sdk\platform-tools

# 永続化する場合はシステム環境変数に追加
```