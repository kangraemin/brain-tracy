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

이 프로젝트는 [Claude Code](https://claude.com/claude-code)의 에이전트 팀 기능으로 개발되었습니다.

### 팀 구성

| 역할 | 담당 |
|------|------|
| **Lead** | Phase/Step 설계, 태스크 생성 및 배정, 품질 관리 |
| **Dev** | 기능 구현, 커밋/푸시 |
| **QA** | 정적 분석, 테스트, 빌드 검증, 통과/반려 판정 |

### 개발 루프

```
Lead: Phase 설계 → 사용자 승인 → Step별 태스크 생성
  ↓
Dev: 태스크 구현 → 커밋+푸시 → 완료 보고
  ↓
QA: flutter analyze + test + 코드 검증 → 통과/반려
  ↓
Lead: Phase 완료 판정 → 다음 Phase 설계
```

### Phase 진행 이력

| Phase | 내용 | Steps |
|-------|------|-------|
| 0 | 프로젝트 셋업 | 7 |
| 1 | 목표 데이터 모델 | 6 |
| 2 | 목표 입력 기능 | 6 |
| 3 | 핵심 목표 선택 | 4 |
| 4 | 실행 계획 (ActionPlan) | 12 |
| 5 | 마무리 (에러 처리, UI, 빌드) | 6 |
| **합계** | | **41 Steps** |
