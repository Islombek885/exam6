import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_chat/widgets/bubble.dart';

void main() {
  testWidgets('MessageBubble shows text and time correctly', (
    WidgetTester tester,
  ) async {
    const messageText = 'Salom test!';
    final DateTime testTime = DateTime(2025, 7, 7, 14, 30);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageBubble(
            text: messageText,
            isMe: true,
            timestamp: testTime,
          ),
        ),
      ),
    );

    expect(find.text(messageText), findsOneWidget);

    expect(find.text('14:30'), findsOneWidget);
  });
}
