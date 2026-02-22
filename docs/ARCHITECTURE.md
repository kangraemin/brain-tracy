# Architecture

Brain Tracy 앱의 아키텍처 가이드.

---

## 1. 아키텍처 패턴

**Clean Architecture + Riverpod**

```
Presentation (UI)
    ↓ depends on
Application (Use Cases / Notifiers)
    ↓ depends on
Domain (Entities / Repository Interfaces)
    ↑ implements
Infrastructure (Repository Impl / Data Sources)
```

### 의존성 방향

- 안쪽 레이어는 바깥쪽을 모른다.
- Domain은 어떤 레이어에도 의존하지 않는다.
- Infrastructure는 Domain의 인터페이스를 구현한다.

---

## 2. 프로젝트 폴더 구조

```
lib/
├── app.dart                    # MaterialApp, 라우팅, 테마
├── main.dart                   # 엔트리포인트
├── core/                       # 공통 유틸, 상수, 테마
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── widgets/                # 공통 위젯
├── features/                   # 기능별 모듈
│   ├── goal_input/             # 목표 10개 입력
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/   # abstract class
│   │   ├── application/        # Notifier, UseCase
│   │   ├── infrastructure/     # Repository impl, Hive adapter
│   │   └── presentation/       # Screen, Widget
│   ├── goal_selection/         # 핵심 목표 1개 선택
│   │   └── ...
│   └── action_plan/            # 7단계 실행 체크리스트
│       └── ...
└── routing/                    # GoRouter 설정
```

### 폴더 규칙

- **feature 단위로 모듈화**: 기능별로 domain/application/infrastructure/presentation 4개 레이어.
- **cross-feature 의존 금지**: feature 간 직접 import 하지 않는다. 필요하면 core로 올린다.
- **파일 하나에 클래스 하나**: 파일명은 클래스명의 snake_case.

---

## 3. 상태 관리: Riverpod

### Provider 종류 사용 기준

| Provider | 용도 |
|----------|------|
| `Provider` | 단순 값, Repository 인스턴스 |
| `NotifierProvider` | 비즈니스 로직이 있는 상태 |
| `FutureProvider` | 비동기 데이터 로딩 |
| `StreamProvider` | 실시간 데이터 스트림 |

### 규칙

- Provider는 각 feature의 `application/` 디렉토리에 정의한다.
- `ref.watch`는 build 메서드에서만, `ref.read`는 콜백에서만 사용한다.
- Provider 이름은 `{기능}{역할}Provider` 형식 (예: `goalListNotifierProvider`).

---

## 4. 로컬 저장소: Hive

### 규칙

- Hive Adapter는 `infrastructure/` 레이어에 둔다.
- TypeAdapter는 Entity별로 하나씩 생성한다.
- Box 이름은 상수로 관리한다 (`core/constants/`).
- Domain 레이어는 Hive를 직접 참조하지 않는다 (Repository 인터페이스를 통해서만 접근).

---

## 5. 라우팅: GoRouter

### 규칙

- 라우트 정의는 `lib/routing/`에 집중한다.
- 각 Screen은 `static const routePath`를 가진다.
- Deep link 대비 path parameter 사용.

---

## 6. DI (의존성 주입)

- Riverpod Provider를 DI 컨테이너로 활용한다.
- Repository 인터페이스 → Provider로 구현체를 바인딩.
- 테스트 시 `ProviderScope`의 `overrides`로 Mock 주입.
