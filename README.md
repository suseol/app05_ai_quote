# App 05 | AI Quote Helper

모바일프로그래밍 6주차 실습에서 사용하는 학생용 Flutter 프로젝트 `app05_ai_quote`입니다.

이 저장소는 **Android 실습 기준**으로 구성되어 있으며, clone 후 `flutter pub get`을 실행하면 starter 앱을 바로 실행할 수 있습니다.

## 1. 프로젝트 받기

```bash
git clone https://github.com/suseol/app05_ai_quote.git
cd app05_ai_quote
flutter pub get
```

Android Studio에서 `app05_ai_quote` 폴더를 열어도 됩니다.

## 2. Starter 실행

기본 실행 파일은 다음입니다.

```text
lib/main.dart
```

처음에는 고정 영어 문장과 **AI에게 물어보기** 버튼만 있는 starter 화면이 실행됩니다. 아직 AI 요청 코드는 없으므로 API 키 없이 실행할 수 있습니다.

```bash
flutter run
```

수업에서는 먼저 `lib/ai_service.dart`와 `tool/ai_test.dart`를 직접 만들고, Future와 async/await를 확인한 뒤 실제 OpenAI API 호출로 확장합니다.

## 3. OpenAI API를 사용하는 단계

S01부터 실제 OpenAI API를 호출합니다. API 키를 소스 파일에 직접 작성하지 않습니다.

PowerShell 예:

```powershell
$env:OPENAI_API_KEY = "자신의_API_KEY"
dart run --define=OPENAI_API_KEY=$env:OPENAI_API_KEY tool/ai_test.dart
```

S02 이후 Flutter 앱 실행:

```powershell
flutter run --dart-define=OPENAI_API_KEY=$env:OPENAI_API_KEY
```

Android Studio의 Run 버튼을 사용할 경우 Run Configuration의 Additional run args에 `--dart-define=OPENAI_API_KEY=...`를 추가해야 합니다.

> `--dart-define`은 배포 앱의 비밀 키를 보호하는 보안 기능이 아닙니다. 이 실습의 직접 호출 방식은 비공개 로컬 수업용입니다. API 키가 포함된 APK나 실행 파일을 배포하거나 제출하지 마세요.

## 4. Checkpoint 사용

`checkpoints/`에는 수업 중 다시 합류할 수 있는 핵심 복구 코드만 들어 있습니다.

```text
checkpoints/
├─ ai_service.dart
├─ ai_test.dart
├─ main_cp02_ai_screen.dart
├─ main_cp03_loading_error.dart
└─ main_cp04_quote_screen.dart
```

- **Checkpoint 1**: 실제 AI 콘솔 호출 완료
  - `ai_service.dart` → `lib/ai_service.dart`
  - `ai_test.dart` → `tool/ai_test.dart`
- **Checkpoint 2**: AI 답변을 앱 화면에 표시
  - `main_cp02_ai_screen.dart` → `lib/main.dart`
- **Checkpoint 3**: 로딩과 오류 처리 완료
  - `main_cp03_loading_error.dart` → `lib/main.dart`
- **Checkpoint 4**: DummyJSON에서 받은 새 명언을 화면에 표시
  - `main_cp04_quote_screen.dart` → `lib/main.dart`

Checkpoint는 정답을 미리 보는 용도가 아니라 코드 오류나 진도 차이로 다음 실습을 이어가기 어려울 때 사용하는 **복구 지점**입니다.

## 5. 이번 실습의 흐름

```text
고정 답변
→ Future<String>과 2초 지연
→ Future<void> + await
→ 실제 OpenAI API
→ JSON 응답에서 답변 추출
→ Flutter 버튼 연결
→ 프롬프트
→ State와 화면
→ 로딩과 오류 처리
→ DummyJSON 명언
→ 현재 명언을 AI 입력에 연결
```

## 6. 주의사항

- 이 저장소의 GitHub repository 이름과 Flutter project/package 이름은 모두 `app05_ai_quote`로 통일합니다.
- Android 인터넷 권한은 프로젝트에 포함되어 있습니다.
- API 키를 GitHub, 소스 코드, 과제 제출 파일에 저장하지 마세요.
- 수업이 끝나기 전에는 완성 solution을 이 공개 저장소에 제공하지 않습니다.
