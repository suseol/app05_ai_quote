// Checkpoint 2: AI 답변 화면 표시 완료
// 복원할 때 이 파일 내용을 lib/main.dart에 복사한다.

// [S02-① 제공 starter] 고정 영어 문장과 버튼이 있는 화면부터 시작한다.
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
  // [S04-①] 화면에 남길 답변을 State에 보관한다.
  String answer = '';

  // [S02-②] 버튼에서 호출할 함수를 먼저 준비한다.
  Future<void> _explainQuote() async {
    // [S03-① → S03-②] 형식과 길이를 앱의 목적에 맞게 지정한다.
    final prompt = '''
다음 영어 명언을 한국어로 번역하고 의미를 쉽게 설명해줘.
답변은 '번역:'과 '해설:'로 나누고 해설은 두 문장 이내로 작성해줘.

명언: $sampleQuote
''';
    final result = await askAi(prompt);
    // [S04-②] 기다리는 사이 화면이 제거됐다면 UI를 갱신하지 않는다.
    if (!mounted) return;
    setState(() {
      answer = result;
    });
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
            const Text(
              sampleQuote,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('출처/작성자: $sampleAuthor'),
            const SizedBox(height: 20),
            FilledButton(
              // [S02-③] 사용자가 눌렀을 때만 요청한다.
              onPressed: _explainQuote,
              child: const Text('AI에게 물어보기'),
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
