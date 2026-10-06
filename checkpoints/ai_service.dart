// Checkpoint 1: S01 실제 AI 콘솔 실습 완료
// 복원 위치: lib/ai_service.dart

// [S01-①] 실제 HTTP 요청과 JSON 인코딩에 필요한 기능을 가져온다.
import 'dart:convert';
import 'package:http/http.dart' as http;

// [S01-①] 실행 명령으로 전달한 컴파일 환경 값을 읽는다.
const apiKey = String.fromEnvironment('OPENAI_API_KEY');

// [S00-② → S01-①] Future<String> 구조는 유지하고 내부 작업을 실제 OpenAI 요청으로 교체한다.
Future<String> askAi(String text) async {
  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/responses'),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'model': 'gpt-6-luna',
      'reasoning': {
        'effort': 'none',
      },
      'input': text,
      'max_output_tokens': 300,
    }),
  );

  // [S01-③] JSON 전체 문자열을 Dart 데이터로 바꾸고 답변 텍스트만 반환한다.
  final data = jsonDecode(response.body);

  return data['output'][0]['content'][0]['text'];
}
