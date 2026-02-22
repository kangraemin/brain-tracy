# Phase 계획

Brain Tracy MVP: 목표 입력 → 핵심 목표 선택 → 7단계 실행 체크리스트, 로컬 저장

---

## Phase 0: 프로젝트 셋업
상태: 완료 ✅

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
상태: 완료 ✅

Goal Entity, Repository 인터페이스, Hive 저장소 구현. goal_input feature 데이터 레이어 완성.

### Step 1.1: GoalEntity freezed 모델 정의
- 구현: lib/features/goal_input/domain/entities/goal_entity.dart 생성. @freezed 어노테이션으로 immutable 모델 정의 (id, title, createdAt, isSelected). build_runner 실행하여 .freezed.dart 생성.
- 완료 기준: `dart run build_runner build` 성공, `flutter analyze` 성공

### Step 1.2: GoalRepository 인터페이스 정의
- 구현: lib/features/goal_input/domain/repositories/goal_repository.dart 생성. abstract class로 CRUD 메서드 정의 (getAll, add, update, delete).
- 완료 기준: `flutter analyze` 성공

### Step 1.3: GoalHiveModel 정의
- 구현: lib/features/goal_input/infrastructure/goal_hive_model.dart 생성. @HiveType/@HiveField 어노테이션으로 Hive 저장용 모델 정의. GoalEntity ↔ GoalHiveModel 변환 메서드 포함. build_runner 실행하여 .g.dart 생성.
- 완료 기준: `dart run build_runner build` 성공, `flutter analyze` 성공

### Step 1.4: Hive TypeAdapter 등록
- 구현: main.dart에서 GoalHiveModelAdapter 등록, goal Box open 호출 추가.
- 완료 기준: 앱 시작 시 Hive Box 정상 오픈, `flutter analyze` 성공

### Step 1.5: GoalRepositoryImpl 구현
- 구현: lib/features/goal_input/infrastructure/goal_repository_impl.dart 생성. GoalRepository 인터페이스를 구현하여 Hive Box로 CRUD 수행.
- 완료 기준: `flutter analyze` 성공

### Step 1.6: GoalRepository Provider 정의
- 구현: lib/features/goal_input/application/ 에 goal_providers.dart 생성. Riverpod Provider로 GoalRepositoryImpl을 GoalRepository 인터페이스에 바인딩.
- 완료 기준: `flutter analyze` 성공, `flutter test` 성공

---

## Phase 2: 목표 입력 기능
상태: 완료 ✅

목표 10개를 입력하는 화면과 비즈니스 로직. goal_input feature 완성.

### Step 2.1: GoalListNotifier 구현
- 구현: lib/features/goal_input/application/goal_list_notifier.dart 생성. AsyncNotifier<List<GoalEntity>>로 목표 목록 상태 관리. loadGoals, addGoal, deleteGoal, updateGoal 메서드 정의. goalListNotifierProvider 정의.
- 완료 기준: `flutter analyze` 성공

### Step 2.2: GoalInputScreen 기본 화면
- 구현: lib/features/goal_input/presentation/goal_input_screen.dart 생성. ConsumerWidget으로 goalListNotifierProvider를 watch하여 목표 리스트 표시. app_router.dart 라우트 업데이트.
- 완료 기준: 앱 실행 시 목표 리스트 화면 표시, `flutter analyze` 성공

### Step 2.3: 목표 추가 기능
- 구현: GoalInputScreen에 텍스트 입력 필드와 추가 버튼 구현. GoalListNotifier.addGoal 연결.
- 완료 기준: 목표 텍스트 입력 후 추가 동작 확인, `flutter analyze` 성공

### Step 2.4: 목표 삭제 기능
- 구현: GoalInputScreen 목표 항목에 삭제 동작 추가 (스와이프 또는 삭제 버튼). GoalListNotifier.deleteGoal 연결.
- 완료 기준: 목표 삭제 동작 확인, `flutter analyze` 성공

### Step 2.5: 목표 수정 기능
- 구현: GoalInputScreen 목표 항목 탭 시 텍스트 편집 기능. GoalListNotifier.updateGoal 연결.
- 완료 기준: 목표 수정 동작 확인, `flutter analyze` 성공

### Step 2.6: 목표 개수 제한
- 구현: GoalListNotifier에서 10개 최대 제한 로직 추가. UI에 현재 목표 개수 카운터 표시. 10개 도달 시 추가 버튼 비활성화.
- 완료 기준: 11번째 목표 추가 차단 확인, `flutter analyze` 성공

---

## Phase 3: 핵심 목표 선택
상태: 완료 ✅

마법의 지팡이 질문으로 핵심 목표 1개를 선택하는 화면. goal_selection feature 완성.

### Step 3.1: GoalSelectionNotifier 구현
- 구현: lib/features/goal_selection/application/goal_selection_notifier.dart 생성. 목표 목록 로드 (goalRepositoryProvider 활용), selectGoal(String id) 메서드로 선택 상태 관리. goalSelectionNotifierProvider 정의.
- 완료 기준: `flutter analyze` 성공

### Step 3.2: GoalSelectionScreen 화면 구현
- 구현: lib/features/goal_selection/presentation/goal_selection_screen.dart 생성. 마법의 지팡이 질문 텍스트 표시 ("24시간 안에 단 하나의 목표만 이룰 수 있다면?"). 목표 리스트를 선택 가능한 카드로 표시. 선택된 목표 하이라이트.
- 완료 기준: 화면에 목표 리스트 표시, 탭 시 선택 하이라이트, `flutter analyze` 성공

### Step 3.3: 선택 결과 저장
- 구현: GoalSelectionScreen에 "선택 완료" 버튼 추가. 선택된 목표의 isSelected를 true로 업데이트하여 Repository에 저장. 기존 선택이 있으면 해제 후 새로 선택.
- 완료 기준: 선택 저장 후 앱 재시작 시 선택 유지, `flutter analyze` 성공

### Step 3.4: 화면 간 네비게이션 연결
- 구현: app_router.dart에 GoalSelectionScreen 라우트 등록. GoalInputScreen에 "다음" 버튼 추가 (목표 1개 이상일 때 활성화).
- 완료 기준: GoalInputScreen → GoalSelectionScreen 네비게이션 동작, `flutter analyze` 성공

---

## Phase 4: 실행 계획 (ActionPlan)
상태: 완료 ✅

선택된 핵심 목표에 대한 7단계 실행 체크리스트. action_plan feature 완성.

### Step 4.1: ActionStepEntity freezed 모델 정의
- 구현: lib/features/action_plan/domain/entities/action_step_entity.dart 생성. @freezed 어노테이션으로 immutable 모델 정의 (id, goalId, title, isCompleted, order, createdAt). build_runner 실행하여 .freezed.dart 생성.
- 완료 기준: `dart run build_runner build` 성공, `flutter analyze` 성공

### Step 4.2: ActionPlanRepository 인터페이스 정의
- 구현: lib/features/action_plan/domain/repositories/action_plan_repository.dart 생성. abstract class로 CRUD 메서드 정의 (getByGoalId, add, update, delete).
- 완료 기준: `flutter analyze` 성공

### Step 4.3: ActionStepHiveModel 정의
- 구현: lib/features/action_plan/infrastructure/action_step_hive_model.dart 생성. Manual TypeAdapter (typeId=1)로 Hive 저장용 모델 정의. ActionStepEntity ↔ ActionStepHiveModel 변환 메서드 포함.
- 완료 기준: `flutter analyze` 성공

### Step 4.4: Hive TypeAdapter 등록
- 구현: main.dart에서 ActionStepHiveModelAdapter 등록, actionPlanBox open 호출 추가.
- 완료 기준: 앱 시작 시 Hive Box 정상 오픈, `flutter analyze` 성공

### Step 4.5: ActionPlanRepositoryImpl 구현
- 구현: lib/features/action_plan/infrastructure/action_plan_repository_impl.dart 생성. ActionPlanRepository 인터페이스를 구현하여 Hive Box로 CRUD 수행.
- 완료 기준: `flutter analyze` 성공

### Step 4.6: ActionPlan Provider 정의
- 구현: lib/features/action_plan/application/action_plan_providers.dart 생성. Riverpod Provider로 ActionPlanRepositoryImpl을 ActionPlanRepository 인터페이스에 바인딩.
- 완료 기준: `flutter analyze` 성공

### Step 4.7: ActionPlanNotifier 구현
- 구현: lib/features/action_plan/application/action_plan_notifier.dart 생성. AsyncNotifier로 액션 스텝 목록 상태 관리. loadSteps, addStep, toggleComplete, deleteStep 메서드 정의.
- 완료 기준: `flutter analyze` 성공

### Step 4.8: ActionPlanScreen 기본 화면 구현
- 구현: lib/features/action_plan/presentation/action_plan_screen.dart 생성. 선택된 목표 제목 표시, actionPlanNotifierProvider를 watch하여 액션 스텝 리스트 표시.
- 완료 기준: 위젯 빌드 성공, `flutter analyze` 성공

### Step 4.9: 액션 스텝 추가 기능
- 구현: ActionPlanScreen에 텍스트 입력 필드와 추가 버튼 구현. ActionPlanNotifier.addStep 연결.
- 완료 기준: 스텝 추가 동작 확인, `flutter analyze` 성공

### Step 4.10: 액션 스텝 완료 토글 기능
- 구현: ActionPlanScreen 스텝 항목에 체크박스 추가. ActionPlanNotifier.toggleComplete 연결.
- 완료 기준: 체크박스 토글 동작 확인, `flutter analyze` 성공

### Step 4.11: 액션 스텝 개수 제한
- 구현: ActionPlanNotifier에서 7개 최대 제한 로직 추가. UI에 현재 스텝 개수 카운터 표시. 7개 도달 시 추가 버튼 비활성화.
- 완료 기준: 8번째 스텝 추가 차단 확인, `flutter analyze` 성공

### Step 4.12: 화면 간 네비게이션 연결
- 구현: app_router.dart에 ActionPlanScreen 라우트 등록 (goalId path parameter 포함). GoalSelectionScreen "선택 완료" 후 ActionPlanScreen으로 이동.
- 완료 기준: GoalSelectionScreen → ActionPlanScreen 네비게이션 동작, `flutter analyze` 성공

---

## Phase 5: 마무리
상태: ⏳ 대기

에러 처리 보강, UI 개선, 최종 빌드 검증.

예상 Step:
- 에러 상태 처리 보강
- UI/UX 개선
- 최종 빌드 검증 (iOS + Android)
