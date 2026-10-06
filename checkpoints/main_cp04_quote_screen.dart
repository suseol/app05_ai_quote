// Checkpoint 4: 외부 명언을 화면에 표시하는 단계 완료
// 복원할 때 이 파일 내용을 lib/main.dart에 복사한다.

// [S02-① 제공 starter] 고정 영어 문장과 버튼이 있는 화면부터 시작한다.
// [S07-③] JSON 문자열을 Dart 데이터로 바꾼다.
import 'dart:convert';

// [S07-①] 명언 조회에 HTTP 기능을 사용한다.
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// [S02-②] 콘솔에서 사용한 같은 함수를 앱에서도 가져온다.
import 'package:app05_ai_quote/ai_service.dart';

const sampleQuote =
    'Small steps every day can lead to meaningful progress.';
const sampleAuthor = '수업용 예문';

void main() {
  runApp(const QuoteApp());
}

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI 명언 도우미',
      home: QuotePage(),
    );
  }
}

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  // [S08-①] 처음에는 예문을 쓰고 이후 새 명언으로 바꿀 상태를 준비한다.
  String quote = sampleQuote;
  String author = sampleAuthor;
  // [S04-①] 화면에 남길 답변을 State에 보관한다.
  String answer = '';
  // [S05-①] 진행 중인지 나타내는 상태를 추가한다.
  bool isLoading = false;
  // [S06-①] 실패 안내도 화면 상태에 저장한다.
  String errorMessage = '';

  // [S02-② → S06-②] 호출, 상태 저장, 로딩 복구를 하나의 흐름으로 묶는다.
  Future<void> _explainQuote() async {
    // [S05-②] 중복 요청을 막는다.
    if (isLoading) return;
    setState(() {
      isLoading = true;
      answer = '';
      // [S06-②] 재시도할 때 이전 오류 안내를 지운다.
      errorMessage = '';
    });

    // [S03-① → S03-②] 프롬프트는 통신 함수가 아니라 앱에서 만든다.
    final prompt = '''
다음 영어 명언을 한국어로 번역하고 의미를 쉽게 설명해줘.
답변은 '번역:'과 '해설:'로 나누고 해설은 두 문장 이내로 작성해줘.

명언: $sampleQuote
''';

    // [S06-②] 성공과 실패를 나누고 항상 로딩을 정리한다.
    try {
      final result = await askAi(prompt);
      // [S04-②] 비동기 대기 뒤에는 화면이 남아 있는지 확인한다.
      if (!mounted) return;
      setState(() {
        answer = result;
      });
    } catch (error) {
      debugPrint('$error');
      if (!mounted) return;
      setState(() {
        errorMessage = 'AI 요청에 실패했습니다. 다시 눌러 주세요.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // [S07-① → S08-③] 명언 조회에도 같은 로딩과 오류 복구를 적용한다.
  Future<void> _loadQuote() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/quotes/random'),
      );
      if (response.statusCode != 200) {
        throw Exception('명언 조회 실패: HTTP ${response.statusCode}');
      }
      // [S07-③ → S08-②] 필요한 값을 현재 화면 상태에 저장한다.
      final data = jsonDecode(response.body);
      if (!mounted) return;
      setState(() {
        quote = data['quote'];
        author = data['author'];
      });
    } catch (error) {
      debugPrint('$error');
      if (!mounted) return;
      setState(() {
        errorMessage = '명언을 가져오지 못했습니다. 다시 눌러 주세요.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 명언 도우미')),
      // [S04-④] 긴 답변을 스크롤하고 시스템 영역과 겹치지 않게 한다.
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('영어 문장', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            // [S08-①] 고정 상수 대신 현재 상태를 표시한다.
            Text(
              quote,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('출처/작성자: $author'),
            const SizedBox(height: 20),
            // [S07-②] 외부 명언 조회를 별도 버튼으로 시작한다.
            OutlinedButton(
              onPressed: isLoading ? null : _loadQuote,
              child: const Text('새 명언 가져오기'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              // [S02-③ → S05-③] 요청 중에는 버튼을 비활성화한다.
              onPressed: isLoading ? null : _explainQuote,
              child: Text(isLoading ? '요청 처리 중...' : 'AI에게 물어보기'),
            ),
            // [S05-④] 요청 중일 때만 진행 표시를 추가한다.
            const SizedBox(height: 12),
            if (isLoading) const LinearProgressIndicator(),
            // [S06-①] 오류가 있을 때만 안내를 보여준다.
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            // [S04-③] 답변 상태를 화면에서 읽는다.
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              'AI 번역 및 해설',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(answer.isEmpty ? '버튼을 눌러 결과를 확인하세요.' : answer),
          ],
        ),
      ),
    );
  }
}
