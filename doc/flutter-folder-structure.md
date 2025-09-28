# Flutter プロジェクトのフォルダ構成解説

## 📁 フォルダ構成概要

```
hello_flutter_app/
├── lib/                 # メインのソースコード（src/相当）
├── test/                # テストコード
├── android/             # Android固有の設定
├── ios/                 # iOS固有の設定
├── web/                 # Web固有の設定
├── windows/             # Windows固有の設定
├── linux/               # Linux固有の設定
├── macos/               # macOS固有の設定
├── build/               # ビルド成果物（自動生成）
├── .dart_tool/          # Dartツールのキャッシュ
├── pubspec.yaml         # 依存関係定義
└── pubspec.lock         # 依存関係のロックファイル
```

## 🎯 主要フォルダ・ファイルの役割

### **lib/** - アプリケーションコード
**Web開発での相当**: `src/`フォルダ

Flutterアプリの心臓部。すべてのDartコードはここに配置します。

```
lib/
├── main.dart           # エントリーポイント（index.js相当）
├── screens/            # 画面コンポーネント
├── widgets/            # 再利用可能なUIコンポーネント
├── models/             # データモデル
├── services/           # API通信、データ処理
└── utils/              # ユーティリティ関数
```

### **test/** - テストコード
**Web開発での相当**: `__tests__/`や`spec/`フォルダ

ユニットテスト、ウィジェットテスト、統合テストを配置。

```
test/
├── widget_test.dart    # UIコンポーネントのテスト
├── unit_test.dart      # ロジックのユニットテスト
└── integration_test/   # E2Eテスト
```

### **pubspec.yaml** - プロジェクト設定
**Web開発での相当**: `package.json`

依存パッケージ、アプリ情報、アセット定義を管理。

```yaml
name: hello_flutter_app        # パッケージ名
version: 1.0.0+1              # バージョン番号

dependencies:                  # 本番依存（dependencies）
  flutter:
    sdk: flutter
  http: ^1.0.0                # HTTPクライアント

dev_dependencies:              # 開発依存（devDependencies）
  flutter_test:
    sdk: flutter

flutter:                       # Flutter固有の設定
  assets:                      # 静的ファイル
    - images/
  fonts:                       # フォント定義
    - family: CustomFont
```

### **pubspec.lock** - ロックファイル
**Web開発での相当**: `package-lock.json`、`yarn.lock`

実際にインストールされた依存関係の正確なバージョンを記録。チーム開発で環境を統一するために重要。

## 🖥️ プラットフォーム固有フォルダ

### **android/** - Android設定
**Web開発での相当**: Webpackの設定ファイルのような役割

```
android/
├── app/
│   ├── build.gradle.kts    # ビルド設定（webpack.config相当）
│   └── src/main/
│       ├── AndroidManifest.xml  # アプリ権限設定
│       └── kotlin/          # ネイティブコード（必要時）
└── gradle/                  # ビルドツール設定
```

### **ios/** - iOS設定
Xcodeプロジェクトファイルと設定。

```
ios/
├── Runner.xcodeproj/        # Xcodeプロジェクト
├── Runner/
│   ├── Info.plist           # アプリ情報・権限
│   └── Assets.xcassets/     # アイコン、起動画面
└── Podfile                  # CocoaPods依存（iOS版package.json）
```

### **web/** - Web設定
**Web開発での相当**: `public/`フォルダ

```
web/
├── index.html               # HTMLテンプレート
├── manifest.json            # PWA設定
└── icons/                   # Webアイコン
```

## 🚫 自動生成フォルダ（Git無視）

### **.dart_tool/**
**Web開発での相当**: `node_modules/`

Dartパッケージのキャッシュとツール設定。削除しても`flutter pub get`で再生成される。

### **build/**
**Web開発での相当**: `dist/`、`build/`

コンパイル済みのアプリケーションファイル。`flutter build`コマンドで生成。

### **.idea/** / **hello_flutter_app.iml**
**Web開発での相当**: `.vscode/`の一部

IntelliJ IDEA/Android Studioの設定ファイル。

## 📝 その他の重要ファイル

### **.gitignore**
Gitで追跡しないファイルの定義。Flutterプロジェクトでは標準で適切に設定済み。

### **analysis_options.yaml**
**Web開発での相当**: `.eslintrc.json`

Dartの静的解析ルール設定。コード品質を保つためのリンター設定。

### **.metadata**
Flutter SDKのバージョン情報。プロジェクトの互換性管理用。

## 💡 Web開発者向けの対応表

| Flutter | Web開発 | 説明 |
|---------|---------|------|
| `lib/` | `src/` | ソースコード |
| `pubspec.yaml` | `package.json` | 依存関係定義 |
| `pubspec.lock` | `package-lock.json` | 依存関係ロック |
| `.dart_tool/` | `node_modules/` | パッケージキャッシュ |
| `build/` | `dist/` | ビルド成果物 |
| `flutter pub get` | `npm install` | 依存関係インストール |
| `flutter run` | `npm run dev` | 開発サーバー起動 |
| `flutter build` | `npm run build` | 本番ビルド |
| `flutter test` | `npm test` | テスト実行 |
| `analysis_options.yaml` | `.eslintrc.json` | リンター設定 |

## 🎯 ベストプラクティス

1. **lib/フォルダの整理**
   - 機能別にサブフォルダを作成
   - screens/, widgets/, models/, services/などで分類

2. **プラットフォーム固有コードは最小限に**
   - 可能な限りDartコードで実装
   - どうしても必要な場合のみネイティブコード使用

3. **アセット管理**
   - 画像は`assets/images/`
   - フォントは`assets/fonts/`
   - pubspec.yamlで必ず宣言

4. **環境変数の管理**
   - `.env`ファイルは使わない（Flutterでは一般的でない）
   - 代わりに`--dart-define`または設定ファイルを使用

## 🔧 よく使うコマンド

```bash
# 依存関係のインストール
flutter pub get

# アプリ実行（開発モード）
flutter run

# 特定デバイスで実行
flutter run -d chrome  # Web
flutter run -d windows # Windows

# ビルド
flutter build apk      # Android APK
flutter build ios      # iOS（Mac必須）
flutter build web      # Web版

# テスト実行
flutter test

# コード整形
dart format .

# 静的解析
flutter analyze
```