# Phase 계획

Brain Tracy MVP: 목표 입력 → 핵심 목표 선택 → 7단계 실행 체크리스트, 로컬 저장

---

## Phase 0: 프로젝트 셋업
상태: ⏳ 대기

### Step 0.1: Flutter 프로젝트 생성
- 구현: `flutter create --org com.braintracy --project-name brain_tracy .` 실행
- 완료 기준: `flutter analyze` 성공

### Step 0.2: 핵심 패키지 의존성 추가
- 구현: pubspec.yaml에 flutter_riverpod, hive_flutter, go_router, freezed, freezed_annotation, riverpod_annotation, riverpod_generator, hive_generator, json_annotation, json_serializable, build_runner, mocktail 추가
- 완료 기준: `flutter pub get` 성공

### Step 0.3: 기본 폴더 구조 생성
- 구현: lib/ 하위에 core/(constants, theme, utils, widgets), features/(goal_input, goal_selection, action_plan), routing/ 디렉토리 생성 + 각 feature 하위에 domain, application, infrastructure, presentation 디렉토리 생성
- 완료 기준: ARCHITECTURE.md 폴더 구조와 일치

### Step 0.4: 앱 테마 설정
- 구현: lib/core/theme/app_theme.dart에 Material 3 ColorScheme.fromSeed() 기반 테마 클래스 생성
- 완료 기준: `flutter analyze` 성공

### Step 0.5: Riverpod ProviderScope 적용
- 구현: main.dart에서 ProviderScope으로 앱 래핑
- 완료 기준: `flutter analyze` 성공

### Step 0.6: Hive 초기화
- 구현: main.dart에서 Hive.initFlutter() 호출, Box 이름 상수를 core/constants/에 정의
- 완료 기준: 앱 시작 시 Hive 정상 초기화, `flutter analyze` 성공

### Step 0.7: GoRouter 라우팅 설정
- 구현: lib/routing/app_router.dart에 GoRouter 인스턴스 정의, 빈 홈 화면 라우트 추가, app.dart에서 MaterialApp.router 사용
- 완료 기준: 앱 실행 시 빈 홈 화면 표시, `flutter analyze` 성공

---

## Phase 1: 목표 데이터 모델
상태: ⏳ 대기

Goal Entity, Repository 인터페이스, Hive 저장소 구현. 데이터 레이어 완성.

예상 Step:
- GoalEntity freezed 모델 정의
- GoalRepository 인터페이스(abstract class) 정의
- Hive TypeAdapter 구현
- GoalRepositoryImpl 구현

---

## Phase 2: 목표 입력 기능
상태: ⏳ 대기

목표 10개를 입력하는 화면과 비즈니스 로직. goal_input feature 완성.

예상 Step:
- GoalListNotifier 구현 (Application 레이어)
- GoalInputScreen UI 구현 (Presentation 레이어)
- 목표 추가/삭제/수정 동작 연결

---

## Phase 3: 핵심 목표 선택
상태: ⏳ 대기

마법의 지팡이 질문으로 핵심 목표 1개를 선택하는 화면. goal_selection feature 완성.

예상 Step:
- GoalSelectionNotifier 구현
- GoalSelectionScreen UI 구현
- 선택 결과 저장

---

## Phase 4: 실행 계획 (ActionPlan)
상태: ⏳ 대기

7단계 실행 체크리스트 화면. action_plan feature 완성.

예상 Step:
- ActionPlan Entity 정의
- ActionPlanRepository 인터페이스 및 구현
- ActionPlanNotifier 구현
- ActionPlanScreen UI 구현 (기한 설정, 할 일 목록, 체크리스트, 매일 실행 체크)

---

## Phase 5: 마무리
상태: ⏳ 대기

에러 처리 보강, UI 개선, 최종 빌드 검증.

예상 Step:
- 에러 상태 처리 보강
- UI/UX 개선
- 최종 빌드 검증 (iOS + Android)
