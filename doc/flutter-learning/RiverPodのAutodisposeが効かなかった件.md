# Riverpod の autoDispose が効かなかった件

掲題について調べている中で HIT した Zenn 記事「[Riverpod の autoDispose 深掘り](https://zenn.dev/koji_1009/articles/fa972b070eb2f4)」。これを読む中で出てきた疑問点と理解を整理。

## 1. Flutter Engine の理解

### 勘違い

- Flutter Engine が何なのかよくわからない

### 正しい理解

- **Flutter Engine = JVM + 専用グラフィックスエンジン**
- C++で書かれた低レベルレンダリングエンジン
- Dart ランタイムのホスティング、Skia による描画、プラットフォーム連携を担当
- JVM と違い、UI レンダリング機能も内包している
- 開発時は JIT、リリース時は AOT コンパイル

## 2. ProviderScope とアプリケーションライフサイクル

### 勘違い

> 「`ProviderScope`は`StatefulWidget`を継承しているため、これは`MyApp`の親に 1 つ`StatefulWidget`を置いています。`runApp`の直下は、アプリケーションの root となる Widget です。このため、起動から破棄までを管理できることになります。」

この文章の意味がわからない。StatefulWidget とアプリケーション全体の挙動の関係が不明。

### 正しい理解

**StatefulWidget のライフサイクル管理能力**

- `initState()`: Widget 生成時に 1 回実行
- `dispose()`: Widget 破棄時に 1 回実行

**ProviderScope が StatefulWidget であることの意味**

```dart
void main() {
  runApp(                    // アプリ起動
    ProviderScope(           // ← ここで生まれて
      child: MyApp(),
    ),
  );
}                            // アプリ終了時に破棄
```

- `runApp()`直下に置かれた`ProviderScope`は、アプリの起動から終了まで存在し続ける
- つまり、Riverpod の状態管理もアプリ全体のライフサイクルと同期する

## 3. Widget = UI コンポーネントという誤解

### 勘違い

- StatelessWidget/StatefulWidget = UI コンポーネント（画面に表示されるもの）
- なぜ`MyApp`が StatelessWidget なのに、アプリケーション全体を表現できるのか不明

### 正しい理解

**「すべては Widget」という Flutter の哲学**

```
MyApp (アプリの土台) ← これもWidget
 ├─ MaterialApp (設定を提供するWidget)
 │   └─ HomePage (UIコンポーネントWidget)
 │       ├─ AppBar
 │       └─ ListView
```

- Widget は「UI コンポーネント」だけでなく、**アプリ全体の構造**も表現する
- `runApp(MyApp())`の意味 = 「MyApp をアプリのルートにする」
- ルートの Widget はアプリ起動から終了まで 1 つだけ存在 = シングルトン的な振る舞い

## 4. ProviderScope vs UncontrolledProviderScope

### 勘違い

- Zenn 記事の説明と自分のコードが違うように見える
- なぜ自分のコードでは`UncontrolledProviderScope`を使っているのか不明

### 正しい理解

**Zenn 記事のパターン（通常の初期化）**

```dart
void main() {
  runApp(
    ProviderScope(           // Riverpodが自動で管理
      child: MyApp(),
    ),
  );
}
```

- 同期的に初期化できる状態管理向け
- Riverpod が`ProviderContainer`を自動作成・管理

**自分のコードのパターン（事前初期化 / pre-warming）**

```dart
void main() async {
  final container = ProviderContainer();  // 明示的に作成
  await container.read(isarProvider.future);  // Isar初期化を待つ

  runApp(
    UncontrolledProviderScope(  // 外部のcontainerを渡す
      container: container,
      child: const MyApp(),
    ),
  );
}
```

- **非同期の事前処理**が必要な場合向け
- オフラインファーストで、起動時に DB の準備が必須の場合に使用

**違いの理由**

- DayMon は Isar データベースをオフラインファーストで使用
- アプリ起動時に DB が完全に初期化されている必要がある
- 通常の`ProviderScope`だと、画面表示時にまだ DB 初期化が完了していない可能性

## 5. keepAlive: true の必要性

### 勘違い

- AutoDispose モードで自動的に Isar インスタンスが破棄されるのは理解できた
- でも、なぜ破棄時に適切に close できないのか？

### 正しい理解

**AutoDispose で問題が起きる理由**

```dart
@riverpod  // AutoDisposeモード
Future<Isar> isar(IsarRef ref) async {
  final isar = await Isar.open([...], name: 'moodwave');
  // ref.onDispose(() { isar.close(); }); ← これを書いてなかった
  return isar;
}
```

**問題 1**: close 処理の未実装

- `ref.onDispose`で close 処理を書いていなかった
- Isar インスタンスが残ったまま、新しいインスタンスを作ろうとする
- 「既にインスタンスが存在する」エラー

**問題 2**: 仮に close を実装しても

- Isar の名前付きインスタンスは、完全に close してもすぐ再 open すると問題が起きることがある
- AutoDispose のタイミングで頻繁に開閉するのは非効率
- データベースは「起動時に 1 回開いて、終了時に 1 回閉じる」が理想

**解決策: keepAlive: true**

```dart
@Riverpod(keepAlive: true)  // アプリ起動から終了まで存在
Future<Isar> isar(IsarRef ref) async {
  final isar = await Isar.open([...]);
  // close処理も不要（アプリ終了時に自動的に破棄される）
  return isar;
}
```

- データベースやファイルハンドルのような**重いリソース**には必須
- シングルトンとして管理するのが安全

## 6. Provider の役割の誤解

### 勘違い

- Provider は「インスタンスが存在するか？」をチェックする仕組み
- Java の GC とは違って、明示的にチェックが必要

### 正しい理解

**Flutter にも GC は存在する**

- Dart VM がガベージコレクションを持っている
- 不要になったメモリは自動的に破棄される（Java と同じ）

**Provider の本当の役割**

```dart
@riverpod
SaveMoodEntry saveMoodEntry(SaveMoodEntryRef ref) {
  final isar = ref.watch(isarProvider).requireValue;  // 依存関係の明示
  final repository = MoodEntryRepository(isar);
  return SaveMoodEntry(repository);
}
```

- `watch`や`requireValue`は**状態の依存関係を管理**するため
- 「この Provider が更新されたら、この Widget も再構築」という仕組み
- AutoDispose は**リソースのライフサイクル管理**（メモリだけでなく、通信や DB なども）

**Spring の DI との対比**

| Spring (Java)             | Riverpod (Flutter)             |
| ------------------------- | ------------------------------ |
| `@Service` (シングルトン) | `@Riverpod(keepAlive: true)`   |
| `@Autowired` (自動注入)   | `ref.watch()` (依存関係の明示) |
| コンパイル時/起動時に DI  | 実行時に動的に依存解決         |

**`requireValue`の意味**

- `Future<Isar>`を`Isar`に変換（main()で事前初期化済みが前提）
- 万が一初期化されていなかったら例外（開発中のバグ検出）
- **「インスタンスがあるか？」のチェックではない**

## まとめ

1. **Flutter Engine**: Dart ランタイム + グラフィックスエンジンの統合環境
2. **Widget**: UI コンポーネントだけでなく、アプリ全体の構造も表現
3. **ProviderScope**: アプリのルートに置くことで、ライフサイクル全体を管理
4. **UncontrolledProviderScope**: 事前初期化（pre-warming）が必要な場合に使用
5. **keepAlive: true**: データベースなど重いリソースには必須
6. **Provider**: メモリ管理ではなく、状態の依存関係管理とライフサイクル管理

オフラインファーストの DayMon アプリでは、Isar の事前初期化と`keepAlive: true`の組み合わせが最適解。
