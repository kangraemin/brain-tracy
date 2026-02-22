# Coding Conventions

Brain Tracy 프로젝트의 코딩 컨벤션.

---

## 1. 네이밍

| 대상 | 규칙 | 예시 |
|------|------|------|
| 클래스/enum | UpperCamelCase | `GoalEntity`, `ActionStep` |
| 변수/함수 | lowerCamelCase | `goalList`, `selectPrimaryGoal()` |
| 상수 | lowerCamelCase (static const) | `maxGoalCount` |
| 파일명 | snake_case | `goal_entity.dart` |
| Provider | lowerCamelCase + Provider | `goalListNotifierProvider` |
| private | `_` prefix | `_internalState` |

### 네이밍 원칙

- 축약 금지: `btn` → `button`, `mgr` → `manager`
- boolean은 `is/has/can/should` prefix: `isCompleted`, `hasDeadline`
- 컬렉션은 복수형: `goals`, `actionSteps`

---

## 2. 파일 구조

```dart
// 1. dart/flutter imports
import 'dart:async';
import 'package:flutter/material.dart';

// 2. 패키지 imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

// 3. 프로젝트 imports
import 'package:brain_tracy/core/constants/app_constants.dart';
```

- import 그룹 사이에 빈 줄 하나.
- 각 그룹 내에서 알파벳 순 정렬.

---

## 3. 클래스 구조

```dart
class GoalInputScreen extends ConsumerWidget {
  // 1. static 상수
  static const routePath = '/goal-input';

  // 2. 생성자
  const GoalInputScreen({super.key});

  // 3. build (또는 public 메서드)
  @override
  Widget build(BuildContext context, WidgetRef ref) { ... }

  // 4. private 메서드
  Widget _buildGoalItem() { ... }
}
```

---

## 4. Widget 규칙

- **StatelessWidget 우선**: 상태가 필요하면 `ConsumerWidget` 또는 `ConsumerStatefulWidget`.
- **build 메서드는 30줄 이하**: 넘으면 private 메서드나 별도 Widget으로 분리.
- **const 생성자 적극 활용**: `const Text('목표')`.
- **Magic number 금지**: 패딩, 크기 등은 테마나 상수로 관리.

---

## 5. Dart 스타일

- **trailing comma**: 항상 사용 (자동 포맷팅 도움).
- **`final` 우선**: 변경 불필요한 변수는 항상 `final`.
- **`const` 우선**: 컴파일 타임 상수 가능하면 `const`.
- **null safety**: `!` 연산자 사용 최소화. null check 또는 `?.` 사용.
- **early return**: 중첩 줄이기 위해 조건 불만족 시 조기 반환.

---

## 6. 주석

- **why 주석만 작성**: 코드가 "왜" 이렇게 되어있는지만 적는다.
- **what 주석 금지**: 코드를 읽으면 알 수 있는 내용은 적지 않는다.
- **TODO**: `// TODO(이름): 설명` 형식.

---

## 7. 에러 처리

- Repository는 예외를 throw하지 않고 `Result` 패턴 또는 nullable 반환.
- UI에서 에러 상태는 `AsyncValue.error`로 처리.
- catch에서 에러를 삼키지 않는다 (최소 로그).
