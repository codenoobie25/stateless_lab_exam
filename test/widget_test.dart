import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stateless_lab_exam/main.dart';
import 'package:stateless_lab_exam/shopping_cart_page.dart';

void main() {
  testWidgets('ShoppingCartPage smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify title and main elements are present
    expect(find.text('My Cart'), findsOneWidget);
    expect(find.text('CAMPUS STORE'), findsOneWidget);
    expect(find.text('Ready for checkout'), findsOneWidget);
    expect(find.text('Wireless Mouse'), findsOneWidget);
    expect(find.text('USB-C Hub'), findsOneWidget);
    expect(find.text('Laptop Stand'), findsOneWidget);
    expect(find.byType(CartItemCard), findsNWidgets(3));
    expect(find.text('Place Order'), findsOneWidget);
  });

  testWidgets('ShoppingCartPage button callback logs test', (
    WidgetTester tester,
  ) async {
    final List<String> logs = [];
    final originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) logs.add(message);
    };

    try {
      await tester.pumpWidget(const MyApp());

      // Back arrow
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();
      expect(logs.contains('Back clicked'), isTrue);

      // Shopping bag
      await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
      await tester.pump();
      expect(logs.contains('Cart clicked'), isTrue);

      // Change delivery address
      await tester.tap(find.text('Change'));
      await tester.pump();
      expect(logs.contains('Change delivery address clicked'), isTrue);

      // Plus button on first item (Wireless Mouse)
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pump();
      expect(logs.contains('Increase quantity: Wireless Mouse'), isTrue);

      // Minus button on first item (Wireless Mouse)
      await tester.tap(find.byIcon(Icons.remove).first);
      await tester.pump();
      expect(logs.contains('Decrease quantity: Wireless Mouse'), isTrue);

      // Delete button on first item (Wireless Mouse)
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pump();
      expect(logs.contains('Remove item: Wireless Mouse'), isTrue);

      // Place order button
      await tester.ensureVisible(find.text('Place Order'));
      await tester.tap(find.text('Place Order'));
      await tester.pump();
      expect(
        logs.contains('Place order clicked! Total: PHP 1850.00'),
        isTrue,
      );
    } finally {
      debugPrint = originalDebugPrint;
    }
  });
}
