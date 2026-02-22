# Flutter Guide

Brain Tracy 프로젝트의 Flutter 관련 컨벤션.

---

## 1. 최소 버전

- **Flutter**: 3.27+
- **Dart**: 3.6+
- **Android minSdk**: 24 (Android 7.0)
- **iOS Deployment Target**: 16.0

---

## 2. 핵심 패키지

| 패키지 | 용도 |
|--------|------|
| `flutter_riverpod` | 상태 관리 |
| `riverpod_annotation` + `riverpod_generator` | Provider 코드 생성 |
| `hive_flutter` | 로컬 저장소 |
| `hive_generator` | Hive TypeAdapter 코드 생성 |
| `go_router` | 라우팅 |
| `freezed` + `freezed_annotation` | Immutable 모델 |
| `json_annotation` + `json_serializable` | JSON 직렬화 |
| `build_runner` | 코드 생성 실행 |
| `mocktail` | 테스트 Mocking |

---

## 3. 코드 생성

```bash
# 일회성 생성
dart run build_runner build --delete-conflicting-outputs

# 파일 변경 감지 자동 생성
dart run build_runner watch --delete-conflicting-outputs
```

- `*.g.dart`, `*.freezed.dart` 파일은 git에 포함한다.
- 코드 생성 파일을 수동 편집하지 않는다.

---

## 4. Freezed 모델 규칙

```dart
@freezed
class GoalEntity with _$GoalEntity {
  const factory GoalEntity({
    required String id,
    required String title,
    required DateTime createdAt,
    @Default(false) bool isSelected,
  }) = _GoalEntity;
}
```

- Domain Entity는 `freezed`로 immutable하게 정의한다.
- `@Default` 활용하여 기본값 명시.
- `copyWith`로 상태 변경.

---

## 5. 테마 & 디자인

### 컬러

- Material 3 기반 테마 사용.
- `ColorScheme.fromSeed()`로 일관된 컬러 생성.
- 하드코딩 색상 금지. 항상 `Theme.of(context).colorScheme` 참조.

### 텍스트

- `Theme.of(context).textTheme` 사용.
- 직접 `TextStyle` 생성 최소화.

### 반응형

- `MediaQuery` 또는 `LayoutBuilder`로 화면 크기 대응.
- 고정 픽셀 값 최소화, 비율 기반 레이아웃 활용.

---

## 6. 앱 흐름 (MVP)

```
앱 시작
  → 온보딩 (선택)
  → 목표 10개 입력 (GoalInput)
  → 핵심 목표 1개 선택 (GoalSelection)
  → 7단계 실행 계획 (ActionPlan)
    → 기한 설정
    → 할 일 목록 작성
    → 체크리스트 정리
    → 매일 실행 체크
```
