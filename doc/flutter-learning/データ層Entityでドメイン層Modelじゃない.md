# Entity と Model の違い - Clean Architecture における層の理解

このドキュメントでは、MoodWave プロジェクトにおける **Entity（エンティティ）** と **Model（モデル）** の違いと、それぞれがどの層に属するかを解説します。

---

## 正しい対応関係

| 層                       | 使うデータ構造 | 特徴                                     |
| ------------------------ | -------------- | ---------------------------------------- |
| **ドメイン層** (domain/) | **Entity**     | ビジネスロジック用、フレームワーク非依存 |
| **データ層** (data/)     | **Model**      | データベース/API 用、フレームワーク依存  |

---

## MoodWave プロジェクトの実際のファイル構成

```
lib/features/entry/
├── domain/
│   └── entities/
│       └── mood_entry.dart          ← Entity（ドメイン層）
│
└── data/
    └── models/
        └── mood_entry_model.dart    ← Model（データ層）
```

---

## Entity（エンティティ）- ドメイン層

### ファイル: `lib/features/entry/domain/entities/mood_entry.dart`

```dart
class MoodEntry {
  const MoodEntry({
    required this.id,
    required this.emotionLevel,
    required this.weatherTypes,
    required this.recordedAt,
    this.memo,
  });

  final int id;
  final int emotionLevel;
  final List<String> weatherTypes;
  final String? memo;
  final DateTime recordedAt;
}
```

### 特徴

- **目的**: ビジネスロジックで使う純粋な Dart オブジェクト
- **依存関係**: Isar、Firebase 等の外部フレームワークに**依存しない**
- **不変性**: `const` コンストラクタを使った不変オブジェクト
- **利点**: 将来 DB を変更しても影響を受けない

### どこで使われる？

- UseCase（ビジネスロジック）
- Presentation 層（UI）
- Repository interface（抽象）

---

## Model（モデル）- データ層

### ファイル: `lib/features/entry/data/models/mood_entry_model.dart`

```dart
@collection  // ← Isarに依存！
class MoodEntryModel {
  /// Isar auto-increment ID
  Id id = Isar.autoIncrement;  // ← Isarの型

  /// 感情レベル（インデックス付き）
  @Index()  // ← Isarのアノテーション
  late int emotionLevel;

  /// 天気タイプリスト
  late List<String> weatherTypes;

  /// メモ（任意）
  String? memo;

  /// 記録日時（インデックス付き）
  @Index()
  late DateTime recordedAt;

  /// Entity → Model 変換
  static MoodEntryModel fromEntity(MoodEntry entity) {
    return MoodEntryModel()
      ..id = entity.id == 0 ? Isar.autoIncrement : entity.id
      ..emotionLevel = entity.emotionLevel
      ..weatherTypes = entity.weatherTypes
      ..memo = entity.memo
      ..recordedAt = entity.recordedAt;
  }

  /// Model → Entity 変換
  MoodEntry toEntity() {
    return MoodEntry(
      id: id,
      emotionLevel: emotionLevel,
      weatherTypes: weatherTypes,
      memo: memo,
      recordedAt: recordedAt,
    );
  }
}
```

### 特徴

- **目的**: データベース（Isar）とのやり取りに特化
- **依存関係**: Isar のアノテーション（`@collection`, `@Index()`）を使う
- **可変性**: `late` キーワードを使った可変オブジェクト（DB のため）
- **利点**: DB に最適化された形でデータを保存・検索

### どこで使われる？

- Repository 実装（MoodEntryRepository）
- Isar データベース操作

---

## データ変換の流れ

### 保存時（Entity → Model → DB）

```
1. Presentation層
   ↓
2. UseCase (SaveMoodEntry)
   ↓ MoodEntry (Entity)
3. Repository.save(entry)
   ↓
4. MoodEntryModel.fromEntity(entry)  ← Entity → Model 変換
   ↓ MoodEntryModel
5. isar.moodEntryModels.put(model)
   ↓
6. Isar DB
```

### 読み込み時（DB → Model → Entity）

```
1. Isar DB
   ↓
2. isar.moodEntryModels.findAll()
   ↓ MoodEntryModel
3. model.toEntity()  ← Model → Entity 変換
   ↓ MoodEntry (Entity)
4. Repository.getAll()
   ↓
5. UseCase
   ↓
6. Presentation層
```

---

## Clean Architecture の依存関係ルール

```
外側（インフラ層）
  ↓
データ層 (Model) ← フレームワークに依存してOK
  ↓ 依存の方向
ドメイン層 (Entity) ← フレームワークに依存してはダメ
  ↓
内側（ビジネスロジック）
```

### 鉄則: 「内側は外側に依存しない」

- ✅ **OK**: Model は Entity に依存できる（`fromEntity`, `toEntity`）
- ❌ **NG**: Entity は Model に依存できない

---

## なぜこの分離が重要か？

### 1. フレームワークの交換が容易

```dart
// 将来Isarから別のDBに変更しても...
// Entity（ドメイン層）は変更不要！
// Model（データ層）だけ書き換えればOK
```

**変更前: Isar**

```dart
@collection
class MoodEntryModel { ... }
```

**変更後: Hive（仮）**

```dart
@HiveType(typeId: 0)
class MoodEntryModel { ... }
```

### 2. テストが容易

```dart
// ドメイン層のテストではDBを使わない
test('感情レベルの検証', () {
  final entry = MoodEntry(
    id: 1,
    emotionLevel: 5,
    weatherTypes: [],
    recordedAt: DateTime.now(),
  );

  expect(entry.emotionLevel, 5);
});
```

### 3. ビジネスロジックの再利用

- Entity を使ったビジネスロジックは、Web 版・モバイル版で共有可能
- データ層（Model）だけ各プラットフォームに最適化

---

## 実例: fromEntity メソッドの役割

### 問題（修正前）

```dart
static MoodEntryModel fromEntity(MoodEntry entity) {
  return MoodEntryModel()
    ..id = entity.id  // ← id=0 をそのまま設定
    ..emotionLevel = entity.emotionLevel
    // ...
}
```

**何が起きたか:**

- `entity.id = 0` をそのまま設定
- Isar は「id=0」を正当な ID として扱う
- 毎回同じ id=0 のレコードを上書き
- → 1 件しか保存されない！

### 解決（修正後）

```dart
static MoodEntryModel fromEntity(MoodEntry entity) {
  return MoodEntryModel()
    ..id = entity.id == 0 ? Isar.autoIncrement : entity.id  // ← 修正！
    ..emotionLevel = entity.emotionLevel
    // ...
}
```

**ロジック:**

- `entity.id == 0` → 新規作成 → `Isar.autoIncrement` で自動採番
- `entity.id > 0` → 更新 → 既存の ID を使用

---

## まとめ

| 項目           | Entity（ドメイン層）     | Model（データ層）            |
| -------------- | ------------------------ | ---------------------------- |
| **ファイル名** | `mood_entry.dart`        | `mood_entry_model.dart`      |
| **パス**       | `domain/entities/`       | `data/models/`               |
| **目的**       | ビジネスロジック         | データベース操作             |
| **依存**       | フレームワーク非依存     | Isar 等に依存                |
| **不変性**     | `const` 不変オブジェクト | `late` 可変オブジェクト      |
| **使用場所**   | UseCase, Presentation    | Repository 実装              |
| **変換**       | -                        | `fromEntity()`, `toEntity()` |

---

## 参考資料

- [Clean Architecture（書籍）](https://www.amazon.co.jp/dp/B07FSBHS2V)
- [Flutter Clean Architecture Guide](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)
- [Isar Documentation](https://isar.dev/)

---

**作成日**: 2025-10-30
**対象プロジェクト**: MoodWave
