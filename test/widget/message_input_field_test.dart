import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_chat/widgets/message_input_field.dart';

class MockCallbackHandler extends Mock {
  void onSend();
}

void main() {
  late TextEditingController controller;
  late MockCallbackHandler mockHandler;

  setUp(() {
    controller = TextEditingController();
    mockHandler = MockCallbackHandler();
  });

  testWidgets('Send button bosilganda onSend chaqiriladi', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageInputField(
            controller: controller,
            onSend: mockHandler.onSend, // 👈 bu yerda aynan method uzatiladi
          ),
        ),
      ),
    );

    final sendButton = find.byIcon(Icons.send);
    expect(sendButton, findsOneWidget);

    await tester.tap(sendButton);
    await tester.pump();

    verify(mockHandler.onSend()).called(1); // 👈 test bu yerda tekshiradi
  });
}
