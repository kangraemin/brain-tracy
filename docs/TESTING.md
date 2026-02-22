# Testing

Brain Tracy 프로젝트의 테스트 가이드.

---

## 1. 테스트 프레임워크

| 종류 | 패키지 |
|------|--------|
| Unit Test | `flutter_test` (기본) |
| Mocking | `mocktail` |
| Riverpod 테스트 | `riverpod` (ProviderContainer) |
| Widget Test | `flutter_test` |

---

## 2. 테스트 구조

```
test/
├── features/
│   ├── goal_input/
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── goal_entity_test.dart
│   │   ├── application/
│   │   │   └── goal_list_notifier_test.dart
│   │   └── infrastructure/
│   │       └── goal_repository_impl_test.dart
│   ├── goal_selection/
│   │   └── ...
│   └── action_plan/
│       └── ...
└── core/
    └── ...
```

- `lib/` 구조를 그대로 미러링한다.
- 테스트 파일명: `{원본}_test.dart`

---

## 3. 테스트 작성 규칙

### 네이밍

```dart
group('GoalListNotifier', () {
  test('목표 추가 시 리스트에 포함된다', () { ... });
  test('10개 초과 목표 추가 시 실패한다', () { ... });
});
```

- `group`은 테스트 대상 클래스/기능명.
- `test`는 **한글로** 동작을 설명한다.

### AAA 패턴

```dart
test('목표 추가 시 리스트에 포함된다', () {
  // Arrange
  final notifier = GoalListNotifier();

  // Act
  notifier.addGoal('월 500만원 벌기');

  // Assert
  expect(notifier.goals, contains('월 500만원 벌기'));
});
```

### Mock 규칙

- `mocktail` 사용: `class MockGoalRepository extends Mock implements GoalRepository {}`
- Mock은 테스트 파일 상단에 정의.
- 공통 Mock이 많아지면 `test/mocks/` 디렉토리로 분리.

---

## 4. 빌드 검증 명령

```bash
# 전체 테스트
flutter test

# 특정 파일
flutter test test/features/goal_input/application/goal_list_notifier_test.dart

# 커버리지
flutter test --coverage

# 빌드 확인 (Android)
flutter build apk --debug

# 빌드 확인 (iOS)
flutter build ios --debug --no-codesign

# 정적 분석
flutter analyze
```

---

## 5. 단계 완료 기준

- `flutter test` 전체 통과
- `flutter analyze` warning 0
- 핵심 비즈니스 로직(Domain, Application) 테스트 커버리지 확보
