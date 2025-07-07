// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:your_app_name/widgets/message_bubble.dart'; // ← TO‘G‘RI yo‘lni yoz!

// void main() {
//   testWidgets('MessageBubble shows text and time correctly', (WidgetTester tester) async {
//     // 1. Test uchun matn va vaqt
//     const messageText = 'Hello from test!';
//     final now = DateTime(2025, 7, 7, 9, 41); // 09:41

//     // 2. Widgetni test muhiti bilan ishga tushuramiz
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: MessageBubble(
//             text: messageText,
//             isMe: true,
//             timestamp: now,
//           ),
//         ),
//       ),
//     );

//     // 3. Matn borligini tekshiramiz
//     expect(find.text(messageText), findsOneWidget);

//     // 4. Vaqt formatlangan holda ko‘rinayotganini tekshiramiz
//     expect(find.text('09:41'), findsOneWidget);
//   });
// }
