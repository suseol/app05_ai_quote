// Checkpoint 1: S01 실제 AI 콘솔 실습 완료
// 복원 위치: tool/ai_test.dart

// [S00-①] 처음부터 직접 작성한 askAi()를 가져온다.
import '../lib/ai_service.dart';

// [S00-①] 익숙한 void main()은 유지한다.
void main() {
  testAi();
}

// [S00-① → S00-③] 일반 void 함수에서 await를 사용하는 Future<void> 함수로 변경한다.
Future<void> testAi() async {
  const question = 'json이 뭐야?';

  print('AI에게 요청합니다.');
  // [S00-② → S00-③] Future<String>을 그대로 출력하지 않고 await로 실제 String을 받는다.
  final answer = await askAi(question);
  print(answer);
}
