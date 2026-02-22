# Brain Tracy - Development Guide

프로젝트 전체 규칙의 허브. 모든 에이전트(`~/.claude/agents/`)가 이 문서를 먼저 읽는다.

---

## 1. 프로젝트 개요

| 항목 | 선택 |
|------|------|
| 앱 이름 | **Brain Tracy** |
| 설명 | Brian Tracy 목표 설정 7단계 방법론 앱 |
| 플랫폼 | Flutter (iOS + Android) |
| 아키텍처 | Clean Architecture + Riverpod |
| 로컬 DB | Hive |
| 패키지명 | `com.braintracy.app` |
| Flutter 버전 | 3.27+ |
| GitHub | `kangraemin/brain-tracy` |

---

## 2. 상세 가이드

| 문서 | 내용 |
|------|------|
| [Architecture](docs/ARCHITECTURE.md) | Clean Architecture 레이어, 폴더 구조, DI |
| [Coding Conventions](docs/CODING_CONVENTIONS.md) | 네이밍, 스타일, Widget 규칙 |
| [Testing](docs/TESTING.md) | 테스트 프레임워크, AAA 패턴, 빌드 검증 |
| [Flutter Guide](docs/FLUTTER_GUIDE.md) | Flutter/Dart 컨벤션, 패키지, 코드 생성 |
| [단계별 개발 원칙](~/.claude/guides/common/phase-development.md) | Phase/Step 구조, 완료 조건 (글로벌) |
| [팀 워크플로우](~/.claude/guides/common/team-workflow.md) | Lead/Dev/QA 역할 (글로벌) |
| [Git Rules](~/.claude/rules/git-rules.md) | 커밋, 푸시, PR 규칙 (글로벌) |

---

## 3. Git 컨벤션

`~/.claude/rules/git-rules.md` 참조. 추가로 이 프로젝트에서는:

- `develop` 브랜치를 개발 통합 브랜치로 사용
- `feature/<단계명>` 브랜치로 각 Step 작업
- 단계 완료 시 `develop`에 머지 후 태그: `phase-X.step-Y`
