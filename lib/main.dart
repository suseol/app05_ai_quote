import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 명언 도우미')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              onPressed: () {},
              child: const Text('AI에게 물어보기'),
            ),
          ],
        ),
      ),
    );
  }
}
