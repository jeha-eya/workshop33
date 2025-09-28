import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:waiting_app/main.dart';
import 'package:waiting_app/queue_provider.dart';

void main() {
  testWidgets('should add a new client to the list on button tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => QueueProvider(),
        child: const MaterialApp(home: WaitingRoomScreen()),
      ),
    );

    final nameField = find.byType(TextField);
    final addButton = find.byKey(const Key('addButton'));

    await tester.enterText(nameField, 'Alice');
    await tester.tap(addButton);
    await tester.pump();

    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Clients in Queue: 1'), findsOneWidget);
  });

  testWidgets('should remove a client from the list when the delete button is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => QueueProvider(),
        child: const MaterialApp(home: WaitingRoomScreen()),
      ),
    );

    final nameField = find.byType(TextField);
    final addButton = find.byKey(const Key('addButton'));

    await tester.enterText(nameField, 'Bob');
    await tester.tap(addButton);
    await tester.pump();

    final deleteButton = find.byIcon(Icons.delete);
    await tester.tap(deleteButton);
    await tester.pump();

    expect(find.text('Bob'), findsNothing);
    expect(find.text('Clients in Queue: 0'), findsOneWidget);
  });

  testWidgets('should remove the first client when "Next Client" is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => QueueProvider(),
        child: const MaterialApp(home: WaitingRoomScreen()),
      ),
    );

    final nameField = find.byType(TextField);
    final addButton = find.byKey(const Key('addButton'));
    final nextButton = find.byKey(const Key('nextClientButton'));

    await tester.enterText(nameField, 'Client A');
    await tester.tap(addButton);
    await tester.pump();

    await tester.enterText(nameField, 'Client B');
    await tester.tap(addButton);
    await tester.pump();

    await tester.tap(nextButton);
    await tester.pump();

    expect(find.text('Client A'), findsNothing);
    expect(find.text('Client B'), findsOneWidget);
    expect(find.text('Clients in Queue: 1'), findsOneWidget);
  });
}
