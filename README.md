# hello_flutter_app

2 画面の Flutter サンプルアプリです。

## アプリの内容

- **ホーム画面**: 2 つのボタンで 2 ページ目へ遷移（Named Route と Direct Push の 2 つの方法を実装）
- **セカンド画面**: ホームに戻るボタンがある

**Web で例えると**: React Router や Next.js のページ遷移に似ています。`Navigator.pushNamed` は `<Link>` や `router.push()`、`Navigator.pop` は `router.back()` に相当します。

## 実機デバッグの方法

### Android の場合

1. **USB デバッグを有効化** (スマホ側)

   - 設定 → 開発者向けオプション → USB デバッグを ON
   - (開発者向けオプションが見えない場合: 設定 → デバイス情報 → ビルド番号を 7 回タップ)

2. **スマホを PC に接続**

   ```cmd
   adb devices
   ```

   - 初回接続時、スマホに許可ダイアログが出るので「許可」をタップ

3. **アプリを実行**
   ```cmd
   flutter run
   ```
   - 複数デバイスがある場合は選択画面が出ます
   - または `flutter run -d <device-id>` で指定

### iOS の場合

1. **Mac が必要** (Windows では iOS 実機デバッグは不可)
2. **Apple Developer アカウント** (無料でも可)
3. **Lightning ケーブルで接続**
   ```bash
   flutter run
   ```

### 実行中のホットリロード

- **r** キーを押す: ホットリロード（画面を即座に更新）
- **R** キーを押す: ホットリスタート（アプリを再起動）
- **q** キーを押す: デバッグ終了

# Windows 環境での Android SDK 完全セットアップガイド

このガイドでは、Android Studio なしで Android SDK のみを Windows 環境にインストールする方法を詳しく説明します。

## 📋 目次

1. [Android SDK の基本知識](#android-sdkの基本知識)
2. [必要なファイルのダウンロード](#必要なファイルのダウンロード)
3. [ディレクトリ構成の作成](#ディレクトリ構成の作成)
4. [環境変数の設定](#環境変数の設定)
5. [sdkmanager の動作確認](#sdkmanagerの動作確認)
6. [最新バージョンの確認](#最新バージョンの確認)
7. [SDK コンポーネントのインストール](#sdkコンポーネントのインストール)
8. [ライセンス承認](#ライセンス承認)
9. [インストール確認](#インストール確認)
10. [トラブルシューティング](#トラブルシューティング)

## 🔍 Android SDK の基本知識

### Android SDK とは？

Android SDK（Software Development Kit）は、Android アプリケーションを開発するためのツール群です。主要なコンポーネントは以下の通りです：

- **Platform Tools**: `adb`、`fastboot`などのデバイス通信ツール
- **Build Tools**: アプリをコンパイルするためのツール群
- **Platforms**: 特定の Android API レベル向けの開発用ライブラリ
- **Command Line Tools**: SDK を管理する`sdkmanager`などのツール

### なぜ Android Studio なしで？

- **軽量な開発環境**: IDE が不要な場合（CI/CD サーバーなど）
- **ストレージ節約**: Android Studio は数 GB 必要、SDK のみなら数百 MB
- **カスタマイズ性**: 必要なコンポーネントのみ選択的にインストール

## 📥 必要なファイルのダウンロード

### Step 1: Command Line Tools のダウンロード

1. [Android Developer 公式サイト](https://developer.android.com/studio#command-tools)にアクセス
2. ページ下部の「Command line tools only」セクションから**Windows 版**をダウンロード
3. ファイル名例：`commandlinetools-win-XXXXXXX_latest.zip`

> **💡 補足**: Command Line Tools には`sdkmanager`が含まれており、これが Android 版の npm のような役割を果たします。

### Step 2: Platform Tools のダウンロード（オプション）

1. [Platform Tools リリースページ](https://developer.android.com/tools/releases/platform-tools)にアクセス
2. 「SDK Platform-Tools for Windows をダウンロード」をクリック
3. ファイル名例：`platform-tools_rXX.X.X-windows.zip`

> **💡 補足**: Platform Tools は後で`sdkmanager`経由でもインストールできるため、このステップはスキップ可能です。

## 📁 ディレクトリ構成の作成

### Step 3: Android SDK ディレクトリの作成

コマンドプロンプトを開いて以下を実行：

```cmd
# SDKのルートディレクトリを作成
mkdir C:\android-sdk
cd C:\android-sdk
```

> **💡 補足**: `C:\android-sdk`は任意のパスに変更可能です。スペースを含まないパスを推奨します。

### Step 4: Command Line Tools の配置

```cmd
# ダウンロードしたCommand Line Toolsを展開
# 展開後、cmdline-toolsフォルダが作成される

# 重要：latestディレクトリの作成と移動
mkdir cmdline-tools\latest
move cmdline-tools\bin cmdline-tools\latest\
move cmdline-tools\lib cmdline-tools\latest\
move cmdline-tools\NOTICE.txt cmdline-tools\latest\
move cmdline-tools\source.properties cmdline-tools\latest\
```

> **⚠️ 重要**: この`latest`フォルダへの移動は必須です。sdkmanager が期待するディレクトリ構造になります。

### Step 5: Platform Tools の配置（手動ダウンロードした場合）

```cmd
# Platform Toolsを展開してSDKディレクトリに配置
# 結果：C:\android-sdk\platform-tools\adb.exe が存在する状態
```

## 🔧 環境変数の設定

### Step 6: Windows 環境変数の設定

#### 方法 1: GUI から設定（推奨）

1. `Win + R` → `sysdm.cpl` → Enter
2. 「詳細設定」タブ → 「環境変数」ボタンをクリック
3. 「システム環境変数」で以下を追加：

**新しい環境変数を追加:**

- 変数名: `ANDROID_SDK_ROOT`
- 変数値: `C:\android-sdk`

**PATH に追加:**

- `PATH`変数を選択して「編集」
- 「新規」で以下を追加：
  - `C:\android-sdk\cmdline-tools\latest\bin`
  - `C:\android-sdk\platform-tools`

#### 方法 2: コマンドプロンプトから設定（一時的）

```cmd
set ANDROID_SDK_ROOT=C:\android-sdk
set PATH=%PATH%;C:\android-sdk\cmdline-tools\latest\bin;C:\android-sdk\platform-tools
```

> **💡 補足**: 方法 2 は現在のセッションのみ有効。永続化には方法 1 を使用してください。

### Step 7: 設定の確認

**新しいコマンドプロンプトを開いて**実行：

```cmd
# 環境変数が正しく設定されているか確認
echo %ANDROID_SDK_ROOT%
echo %PATH%
```

> **⚠️ 重要**: 環境変数を変更後は、必ず新しいコマンドプロンプトを開いてください。

## ✅ sdkmanager の動作確認

### Step 8: 基本動作確認

```cmd
# sdkmanagerのバージョン確認
sdkmanager --version
```

> **💡 補足**: このコマンドが正常に実行されれば、Command Line Tools のセットアップは成功です。

```cmd
# SDKのルートパス確認
sdkmanager --sdk_root=%ANDROID_SDK_ROOT% --version

# 現在インストール済みのパッケージ確認
sdkmanager --list_installed
```

## 🔍 最新バージョンの確認

### Step 9: 利用可能なパッケージの確認

#### すべてのパッケージを確認

```cmd
# 利用可能なすべてのSDKコンポーネントを表示
sdkmanager --list
```

#### Build Tools の最新バージョン確認

```cmd
# Build Toolsの利用可能バージョンを確認
sdkmanager --list | findstr "build-tools"
```

**出力例と解釈：**

```
build-tools;36.0.0-rc5    # リリース候補版（プレリリース）
build-tools;36.1.0        # 正式安定版 ← これを選択
build-tools;36.1.0-rc1    # 次バージョンのリリース候補版
```

> **💡 補足**: `rc`は Release Candidate（リリース候補）の略。本番開発では`rc`が付かない安定版を選択します。

#### Platforms の最新バージョン確認

```cmd
# Android Platformの利用可能バージョンを確認
sdkmanager --list | findstr "platforms;android"
```

**出力例と解釈：**

```
platforms;android-34        # Android 14 (正式リリース済み)
platforms;android-35        # Android 15 (正式リリース済み) ← 推奨
platforms;android-36        # Android 16 (開発中)
platforms;android-36-ext18  # Android 16 Extension版
```

> **💡 補足**:
>
> - **基本版** (`android-35`): 通常の開発に最適
> - **ext 版** (`android-35-ext14`): 特定機能の拡張版、通常は不要
> - **数字が大きい**: より新しい Android バージョン

### Step 10: バージョン対応関係の理解

**Build-tools vs Platforms の関係：**

- Build-tools はコンパイルツール（npm の webpack のようなもの）
- Platforms は開発対象の Android バージョン（Node.js のバージョンのようなもの）
- **新しい Build-tools は古い Platforms でも使用可能**（下位互換性）

**推奨組み合わせ：**

```
build-tools;36.1.0 + platforms;android-35
= 最新ツールで Android 15 アプリを開発
```

## 📦 SDK コンポーネントのインストール

### Step 11: 必要なコンポーネントのインストール

#### 基本セット（推奨）

```cmd
# 最新のBuild Tools（コンパイルツール）
sdkmanager "build-tools;36.1.0"

# Android 15 Platform（開発対象OS）
sdkmanager "platforms;android-35"

# Platform Tools（adb、fastbootなど）
sdkmanager "platform-tools"
```

> **💡 補足**: この 3 つが Android 開発の最小セットです。

#### オプション：複数バージョン対応

```cmd
# 複数のAndroidバージョンをサポートする場合
sdkmanager "platforms;android-34"  # Android 14もサポート
sdkmanager "platforms;android-33"  # Android 13もサポート
```

#### オプション：エミュレータ関連

```cmd
# Android Emulatorを使用する場合
sdkmanager "emulator"
sdkmanager "system-images;android-35;google_apis;x86_64"
```

### Step 12: インストール進行状況の確認

各`sdkmanager`コマンド実行時に表示される内容：

- **ダウンロード進行状況**: パッケージのダウンロード
- **展開処理**: ファイルの配置
- **Complete**: インストール完了

## 📜 ライセンス承認

### Step 13: Google ライセンスへの同意

```cmd
# ライセンス承認（対話式）
sdkmanager --licenses
```

**実行時の流れ：**

1. 各ライセンス文が表示される
2. `y` または `N` で同意・拒否を選択
3. 通常はすべて `y` で同意

**時短版（すべて自動同意）：**

```cmd
# すべてのライセンスに自動で同意
echo y | sdkmanager --licenses
```

> **💡 補足**: ライセンス同意なしでは、SDK コンポーネントが正常に動作しません。法的要件のため必須です。

## ✅ インストール確認

### Step 14: インストール成功の確認

#### SDK コンポーネントの確認

```cmd
# インストール済みパッケージの一覧表示
sdkmanager --list_installed
```

**期待される出力例：**

```
build-tools;36.1.0
platforms;android-35
platform-tools
```

#### 各ツールの動作確認

```cmd
# adbコマンドの動作確認
adb version

# Android Debug Bridge version 1.0.XX
# Version XX.X.X-XXXXXXX
```

```cmd
# fastbootコマンドの動作確認
fastboot --version

# fastboot version XX.X.X-XXXXXXX
```

#### ディレクトリ構造の確認

```cmd
# SDKディレクトリ構造を確認
dir C:\android-sdk
```

**期待される構造：**

```
C:\android-sdk\
├── build-tools\
│   └── 36.1.0\
├── cmdline-tools\
│   └── latest\
├── licenses\
├── platforms\
│   └── android-35\
└── platform-tools\
```

### Step 15: 開発環境のテスト

#### 簡単なビルドテスト（上級者向け）

```cmd
# Android プロジェクトの作成とビルドが可能か確認
# ※実際のプロジェクトがある場合のみ
cd /path/to/android/project
gradlew build
```

## 🔧 トラブルシューティング

### よくある問題と解決方法

#### 1. 「'sdkmanager' は、内部コマンドまたは外部コマンド...」エラー

**原因**: PATH 環境変数の設定が正しくない

**解決方法:**

```cmd
# 環境変数を再確認
echo %PATH%

# cmdline-tools\latest\binが含まれているか確認
# 含まれていない場合は環境変数を再設定

# 一時的な解決（現セッションのみ）
set PATH=%PATH%;C:\android-sdk\cmdline-tools\latest\bin
```

#### 2. 「SDK location not found」エラー

**原因**: ANDROID_SDK_ROOT 環境変数の設定が正しくない

**解決方法:**

```cmd
# 環境変数を確認
echo %ANDROID_SDK_ROOT%

# 手動で指定してテスト
sdkmanager --sdk_root=C:\android-sdk --list
```

#### 3. ライセンス関連エラー

**原因**: ライセンス承認が完了していない

**解決方法:**

```cmd
# 強制的にライセンスを承認
echo y | sdkmanager --licenses

# ライセンスファイルの確認
dir C:\android-sdk\licenses
```

#### 4. ダウンロードエラー

**原因**: ネットワーク接続またはプロキシの問題

**解決方法:**

```cmd
# プロキシ設定が必要な場合
sdkmanager --proxy=http --proxy_host=proxy.company.com --proxy_port=8080 --list

# より詳細なエラー情報を表示
sdkmanager --list --verbose
```

#### 5. Windows 固有の問題

**パスにスペースが含まれる場合:**

```cmd
# ダブルクォートで囲む
set ANDROID_SDK_ROOT="C:\Program Files\android-sdk"
```

**権限エラーの場合:**

- コマンドプロンプトを管理者として実行
- アンチウイルスソフトの除外設定を確認

### 更新とメンテナンス

#### 定期的な更新

```cmd
# すべてのSDKコンポーネントを最新版に更新
sdkmanager --update

# 利用可能な更新を確認
sdkmanager --list | findstr "Installed"
```

#### 不要なコンポーネントの削除

```cmd
# 特定のパッケージをアンインストール
sdkmanager --uninstall "platforms;android-30"  # 古いバージョンを削除
```

## 🎉 セットアップ完了

これで Android Studio なしでの Android SDK セットアップが完了しました！

**次のステップ:**

1. **Android プロジェクトの作成**: 選択した IDE（IntelliJ IDEA、Visual Studio Code など）でプロジェクトを作成
2. **ビルド設定**: `build.gradle` で SDK パスとバージョンを指定
3. **デバイス接続**: `adb devices` で Android デバイスの接続を確認

**便利なコマンド集:**

```cmd
# デバイス接続確認
adb devices

# インストール済みアプリの確認
adb shell pm list packages

# アプリのインストール
adb install app.apk

# ログの確認
adb logcat
```

**参考リンク:**

- [Android Developer 公式ドキュメント](https://developer.android.com/studio/command-line)
- [sdkmanager リファレンス](https://developer.android.com/studio/command-line/sdkmanager)
- [Platform Tools リリースノート](https://developer.android.com/tools/releases/platform-tools)
