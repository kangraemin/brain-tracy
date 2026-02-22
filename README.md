# Brain Tracy

Brian Tracy의 목표 설정 7단계 방법론을 앱으로 구현한 Flutter 프로젝트.

## 앱 흐름

1. **목표 입력** — 12개월 내 달성할 목표 10개를 현재형으로 작성
2. **핵심 목표 선택** — "24시간 안에 단 하나만 이룰 수 있다면?" 질문으로 1개 선택
3. **7단계 실행 계획** — 선택한 목표를 위한 실행 체크리스트 작성 및 매일 실행

## 기술 스택

| 항목 | 선택 |
|------|------|
| 프레임워크 | Flutter 3.27+ |
| 상태 관리 | Riverpod |
| 로컬 DB | Hive |
| 라우팅 | GoRouter |
| 모델 | Freezed |
| 아키텍처 | Clean Architecture |

## 프로젝트 구조

```
lib/
├── core/              # 공통 (상수, 테마, 유틸, 위젯)
├── features/
│   ├── goal_input/    # 목표 입력 (10개)
│   ├── goal_selection/# 핵심 목표 선택
│   └── action_plan/   # 7단계 실행 체크리스트
└── routing/           # GoRouter 설정
```

각 feature는 Clean Architecture 4레이어로 구성:
`domain/` → `application/` → `infrastructure/` → `presentation/`

## 실행

```bash
# 의존성 설치
flutter pub get

# 코드 생성 (freezed)
dart run build_runner build --delete-conflicting-outputs

# 실행
flutter run

# 테스트
flutter test

# 빌드
flutter build apk --debug
```

## 개발 방식: Claude Code Agent Teams

이 프로젝트는 [Claude Code](https://claude.com/claude-code)의 에이전트 팀 기능으로, 사람이 직접 코드를 작성하지 않고 **AI 에이전트 3명이 협업하여 개발**했습니다.

사람의 역할은 방향 설정과 Phase 승인뿐이었고, 설계 → 구현 → 검증의 전체 사이클을 에이전트들이 자율적으로 수행했습니다.

### 팀 구성과 역할 분담

```
┌─────────────────────────────────────────────────┐
│                   사용자 (Human)                  │
│         방향 설정, Phase 계획 승인/거부             │
└──────────────────────┬──────────────────────────┘
                       │ 승인/지시
          ┌────────────▼────────────┐
          │      Lead (아키텍트)      │
          │                         │
          │  - Phase/Step 설계       │
          │  - 태스크 생성 및 배정     │
          │  - Step 자가 검증         │
          │  - 완료 판정 및 조율       │
          └────┬───────────┬────────┘
               │ 배정       │ 배정
        ┌──────▼──────┐ ┌──▼──────────┐
        │  Dev (개발자) │ │  QA (검증자)  │
        │             │ │              │
        │ - 코드 구현   │ │ - 정적 분석   │
        │ - 컨벤션 준수 │ │ - 테스트 실행  │
        │ - 커밋+푸시   │ │ - 빌드 검증   │
        │ - 워크로그    │ │ - 통과/반려   │
        └─────────────┘ └──────────────┘
```

### 개발 루프: 자동화된 품질 게이트

각 Phase는 다음 루프를 반복합니다. **QA를 통과하지 못하면 다음 Phase로 넘어갈 수 없는 구조**입니다.

```
1. Lead: Phase 설계
   └→ Step 자가 검증 ("A하고 B" 패턴 → 무조건 분리)
   └→ 사용자 승인

2. Lead: Step별 태스크 생성 + 의존성 설정 + Dev 배정

3. Dev: 태스크 순차 구현
   └→ 각 Step마다: 구현 → flutter analyze → 워크로그 → 커밋+푸시
   └→ Phase 전체 완료 보고

4. QA: Phase 단위 검증
   └→ flutter analyze (warning 0)
   └→ flutter test (전체 통과)
   └→ 코드 리뷰 (아키텍처, DI, 컨벤션)
   └→ 통과 or 반려 (반려 시 Dev에게 수정 요청)

5. Lead: Phase 완료 판정 → PHASES.md 업데이트 → 다음 Phase 설계
```

### 에이전트 협업이 효과적이었던 점

**Step 세분화 규칙이 품질을 보장했습니다.**
Lead가 Step을 설계할 때 "한 Step = 하나의 커밋으로 완결되는 최소 작업 단위" 규칙을 적용했습니다. "A하고 B한다" 같은 복합 Step은 자가 검증으로 자동 분리되어, Dev가 한 번에 하나의 관심사만 구현하게 됩니다.

**QA가 게이트키퍼 역할을 했습니다.**
Dev가 Phase를 완료하면 QA가 `flutter analyze`, `flutter test`, 코드 구조를 모두 검증합니다. Phase 4에서 QA가 DI 패턴 문제(Hive Box 직접 참조 → 생성자 주입)를 발견하여 리팩토링이 이루어진 사례가 있습니다.

**병렬 가능한 의존성 설계로 속도를 높였습니다.**
Lead가 태스크 간 `blockedBy` 의존성을 설정할 때, 병렬 진행 가능한 Step을 식별했습니다. 예: Phase 1에서 GoalRepository 인터페이스(1.2)와 GoalHiveModel(1.3)은 GoalEntity(1.1) 완료 후 동시 진행 가능하도록 설계되었습니다.

**문서 기반 규칙 공유로 일관성을 유지했습니다.**
`DEVELOPMENT_GUIDE.md`를 허브로, `docs/` 하위에 아키텍처·코딩 컨벤션·테스트 가이드를 배치하여 모든 에이전트가 동일한 규칙으로 작업했습니다. 에이전트가 시작할 때 이 문서들을 먼저 읽도록 지시하여, 프로젝트 전체에 걸쳐 Clean Architecture 4레이어, Riverpod Provider 네이밍, Freezed 모델 패턴이 일관되게 적용되었습니다.

### Phase 진행 이력

| Phase | 내용 | Steps | 주요 결과물 |
|-------|------|-------|------------|
| 0 | 프로젝트 셋업 | 7 | Flutter 프로젝트, 의존성, 폴더 구조, 테마, Riverpod, Hive, GoRouter |
| 1 | 목표 데이터 모델 | 6 | GoalEntity, GoalRepository, Hive 저장소, Provider |
| 2 | 목표 입력 기능 | 6 | 목표 10개 입력 화면, 추가/삭제/수정, 개수 제한 |
| 3 | 핵심 목표 선택 | 4 | 마법의 지팡이 질문 화면, 선택 저장, 네비게이션 |
| 4 | 실행 계획 | 12 | ActionPlan 데이터 모델, 7단계 체크리스트 화면 |
| 5 | 마무리 | 6 | null 안전, 예외 처리, 재시도 UI, 삭제 확인, 로딩 피드백 |
| **합계** | | **41** | **빈 프로젝트 → 동작하는 MVP** |
