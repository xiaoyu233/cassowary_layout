import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cassowary_layout/cassowary_layout.dart';

void main() {
  group('CassowaryLayout Tests', () {
    testWidgets('Basic Layout - Expand Mode Test', (WidgetTester tester) async {
      const testKey = Key('cassowary_layout');
      const childKey = Key('test_child');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CassowaryLayout(
                key: testKey,
                widthMode: CassowaryLayoutSizeMode.expand,
                heightMode: CassowaryLayoutSizeMode.expand,
                children: [
                  CassowaryPositioned(
                    id: 'child1',
                    leftToLeft: 'parent',
                    topToTop: 'parent',
                    widthMode: CassowaryPositionedSizeMode.fixed,
                    width: 100,
                    heightMode: CassowaryPositionedSizeMode.fixed,
                    height: 50,
                    child: Container(
                      key: childKey,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify parent container size
      final layoutFinder = find.byKey(testKey);
      expect(layoutFinder, findsOneWidget);

      final layoutSize = tester.getSize(layoutFinder);
      expect(layoutSize.width, equals(400.0));
      expect(layoutSize.height, equals(300.0));

      // Verify child component size and position
      final childFinder = find.byKey(childKey);
      expect(childFinder, findsOneWidget);

      final childSize = tester.getSize(childFinder);
      expect(childSize.width, equals(100.0));
      expect(childSize.height, equals(50.0));

      final childOffset = tester.getTopLeft(childFinder);
      expect(childOffset.dx, equals(0.0));
      expect(childOffset.dy, equals(0.0));
    });

    testWidgets('Basic Layout - Fixed Mode Test', (WidgetTester tester) async {
      const testKey = Key('cassowary_layout');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              child: CassowaryLayout(
                key: testKey,
                widthMode: CassowaryLayoutSizeMode.fixed,
                width: 200,
                heightMode: CassowaryLayoutSizeMode.fixed,
                height: 150,
                children: [
                  CassowaryPositioned(
                    id: 'child1',
                    leftToLeft: 'parent',
                    topToTop: 'parent',
                    widthMode: CassowaryPositionedSizeMode.fixed,
                    width: 50,
                    heightMode: CassowaryPositionedSizeMode.fixed,
                    height: 30,
                    child: Container(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify parent container fixed size
      final layoutSize = tester.getSize(find.byKey(testKey));
      expect(layoutSize.width, equals(200.0));
      expect(layoutSize.height, equals(150.0));
    });

    testWidgets('Basic Layout - Wrap Mode Test', (WidgetTester tester) async {
      const testKey = Key('cassowary_layout');
      const childKey = Key('test_child');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CassowaryLayout(
              key: testKey,
              widthMode: CassowaryLayoutSizeMode.wrap,
              heightMode: CassowaryLayoutSizeMode.wrap,
              children: [
                CassowaryPositioned(
                  id: 'child1',
                  leftToLeft: 'parent',
                  topToTop: 'parent',
                  widthMode: CassowaryPositionedSizeMode.fixed,
                  width: 120,
                  heightMode: CassowaryPositionedSizeMode.fixed,
                  height: 80,
                  child: Container(
                    key: childKey,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify parent container adapts to child component size
      final layoutSize = tester.getSize(find.byKey(testKey));
      expect(layoutSize.width, equals(120.0));
      expect(layoutSize.height, equals(80.0));
    });

    testWidgets('Child Component Constraint Test - leftToLeft and rightToRight', (WidgetTester tester) async {
      const child1Key = Key('child1');
      const child2Key = Key('child2');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CassowaryLayout(
                widthMode: CassowaryLayoutSizeMode.expand,
                heightMode: CassowaryLayoutSizeMode.expand,
                children: [
                  CassowaryPositioned(
                    id: 'child1',
                    leftToLeft: 'parent',
                    topToTop: 'parent',
                    widthMode: CassowaryPositionedSizeMode.fixed,
                    width: 100,
                    heightMode: CassowaryPositionedSizeMode.fixed,
                    height: 50,
                    child: Container(
                      key: child1Key,
                      color: Colors.red,
                    ),
                  ),
                  CassowaryPositioned(
                    id: 'child2',
                    leftToRight: 'child1',
                    topToTop: 'parent',
                    widthMode: CassowaryPositionedSizeMode.fixed,
                    width: 80,
                    heightMode: CassowaryPositionedSizeMode.fixed,
                    height: 40,
                    marginLeft: 10,
                    child: Container(
                      key: child2Key,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify first child component position
      final child1Offset = tester.getTopLeft(find.byKey(child1Key));
      expect(child1Offset.dx, equals(0.0));
      expect(child1Offset.dy, equals(0.0));

      // Verify second child component position (should be to the right of first child, plus margin)
      final child2Offset = tester.getTopLeft(find.byKey(child2Key));
      expect(child2Offset.dx, equals(110.0)); // 100 + 10 (marginLeft)
      expect(child2Offset.dy, equals(0.0));
    });

    testWidgets('Child Component Constraint Test - topToTop and bottomToBottom', (WidgetTester tester) async {
      const child1Key = Key('child1');
      const child2Key = Key('child2');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CassowaryLayout(
                widthMode: CassowaryLayoutSizeMode.expand,
                heightMode: CassowaryLayoutSizeMode.expand,
                children: [
                  CassowaryPositioned(
                    id: 'child1',
                    leftToLeft: 'parent',
                    topToTop: 'parent',
                    widthMode: CassowaryPositionedSizeMode.fixed,
                    width: 100,
                    heightMode: CassowaryPositionedSizeMode.fixed,
                    height: 80,
                    child: Container(
                      key: child1Key,
                      color: Colors.red,
                    ),
                  ),
                  CassowaryPositioned(
                    id: 'child2',
                    leftToLeft: 'parent',
                    topToBottom: 'child1',
                    widthMode: CassowaryPositionedSizeMode.fixed,
                    width: 120,
                    heightMode: CassowaryPositionedSizeMode.fixed,
                    height: 60,
                    marginTop: 15,
                    child: Container(
                      key: child2Key,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify first child component position
      final child1Offset = tester.getTopLeft(find.byKey(child1Key));
      expect(child1Offset.dx, equals(0.0));
      expect(child1Offset.dy, equals(0.0));

      // Verify second child component position (should be below first child, plus margin)
      final child2Offset = tester.getTopLeft(find.byKey(child2Key));
      expect(child2Offset.dx, equals(0.0));
      expect(child2Offset.dy, equals(95.0)); // 80 + 15 (marginTop)
    });

    testWidgets('Child Component Size Mode Test - Match Mode', (WidgetTester tester) async {
      const childKey = Key('match_child');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CassowaryLayout(
                widthMode: CassowaryLayoutSizeMode.expand,
                heightMode: CassowaryLayoutSizeMode.expand,
                children: [
                  CassowaryPositioned(
                    id: 'match_child',
                    leftToLeft: 'parent',
                    rightToRight: 'parent',
                    topToTop: 'parent',
                    bottomToBottom: 'parent',
                    widthMode: CassowaryPositionedSizeMode.match,
                    heightMode: CassowaryPositionedSizeMode.match,
                    marginLeft: 20,
                    marginRight: 30,
                    marginTop: 10,
                    marginBottom: 40,
                    child: Container(
                      key: childKey,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify child component size (should fill parent container minus margins)
      final childSize = tester.getSize(find.byKey(childKey));
      expect(childSize.width, equals(350.0)); // 400 - 20 - 30
      expect(childSize.height, equals(250.0)); // 300 - 10 - 40

      // Verify child component position
      final childOffset = tester.getTopLeft(find.byKey(childKey));
      expect(childOffset.dx, equals(20.0)); // marginLeft
      expect(childOffset.dy, equals(10.0)); // marginTop
    });

    testWidgets('Child Component Size Mode Test - Wrap Mode', (WidgetTester tester) async {
      const childKey = Key('wrap_child');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CassowaryLayout(
                widthMode: CassowaryLayoutSizeMode.expand,
                heightMode: CassowaryLayoutSizeMode.expand,
                children: [
                  CassowaryPositioned(
                    id: 'wrap_child',
                    leftToLeft: 'parent',
                    topToTop: 'parent',
                    widthMode: CassowaryPositionedSizeMode.wrap,
                    heightMode: CassowaryPositionedSizeMode.wrap,
                    child: Container(
                      key: childKey,
                      width: 150,
                      height: 100,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify child component adapts to content size
      final childSize = tester.getSize(find.byKey(childKey));
      expect(childSize.width, equals(150.0));
      expect(childSize.height, equals(100.0));
    });

    testWidgets('Margin Test - All Direction Margins', (WidgetTester tester) async {
      const childKey = Key('margin_child');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CassowaryLayout(
                widthMode: CassowaryLayoutSizeMode.expand,
                heightMode: CassowaryLayoutSizeMode.expand,
                children: [
                  CassowaryPositioned(
                    id: 'margin_child',
                    leftToLeft: 'parent',
                    topToTop: 'parent',
                    widthMode: CassowaryPositionedSizeMode.fixed,
                    width: 100,
                    heightMode: CassowaryPositionedSizeMode.fixed,
                    height: 80,
                    marginLeft: 25,
                    marginTop: 35,
                    marginRight: 15,
                    marginBottom: 20,
                    child: Container(
                      key: childKey,
                      color: Colors.cyan,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify margin effect on position
      final childOffset = tester.getTopLeft(find.byKey(childKey));
      expect(childOffset.dx, equals(25.0)); // marginLeft
      expect(childOffset.dy, equals(35.0)); // marginTop

      // Verify size is not affected by margins
      final childSize = tester.getSize(find.byKey(childKey));
      expect(childSize.width, equals(100.0));
      expect(childSize.height, equals(80.0));
    });

    testWidgets('Complex Layout Test - Multiple Child Components with Mutual Constraints', (WidgetTester tester) async {
      const child1Key = Key('child1');
      const child2Key = Key('child2');
      const child3Key = Key('child3');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CassowaryLayout(
                widthMode: CassowaryLayoutSizeMode.expand,
                heightMode: CassowaryLayoutSizeMode.expand,
                children: [
                  // Top-left component
                  CassowaryPositioned(
                    id: 'child1',
                    leftToLeft: 'parent',
                    topToTop: 'parent',
                    widthMode: CassowaryPositionedSizeMode.fixed,
                    width: 100,
                    heightMode: CassowaryPositionedSizeMode.fixed,
                    height: 80,
                    child: Container(
                      key: child1Key,
                      color: Colors.red,
                    ),
                  ),
                  // Top-right component
                  CassowaryPositioned(
                    id: 'child2',
                    rightToRight: 'parent',
                    topToTop: 'parent',
                    widthMode: CassowaryPositionedSizeMode.fixed,
                    width: 120,
                    heightMode: CassowaryPositionedSizeMode.fixed,
                    height: 60,
                    child: Container(
                      key: child2Key,
                      color: Colors.blue,
                    ),
                  ),
                  // Bottom-center component
                  CassowaryPositioned(
                    id: 'child3',
                    leftToLeft: 'parent',
                    rightToRight: 'parent',
                    bottomToBottom: 'parent',
                    widthMode: CassowaryPositionedSizeMode.fixed,
                    width: 200,
                    heightMode: CassowaryPositionedSizeMode.fixed,
                    height: 50,
                    child: Container(
                      key: child3Key,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify top-left component
      final child1Offset = tester.getTopLeft(find.byKey(child1Key));
      expect(child1Offset.dx, equals(0.0));
      expect(child1Offset.dy, equals(0.0));

      // Verify top-right component
      final child2Offset = tester.getTopLeft(find.byKey(child2Key));
      expect(child2Offset.dx, equals(280.0)); // 400 - 120
      expect(child2Offset.dy, equals(0.0));

      // Verify bottom-center component
      final child3Offset = tester.getTopLeft(find.byKey(child3Key));
      expect(child3Offset.dx, equals(100.0)); // (400 - 200) / 2
      expect(child3Offset.dy, equals(250.0)); // 300 - 50
    });

    testWidgets('Center Alignment Test', (WidgetTester tester) async {
      const childKey = Key('center_child');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CassowaryLayout(
                widthMode: CassowaryLayoutSizeMode.expand,
                heightMode: CassowaryLayoutSizeMode.expand,
                children: [
                  CassowaryPositioned(
                    id: 'center_child',
                    leftToLeft: 'parent',
                    rightToRight: 'parent',
                    topToTop: 'parent',
                    bottomToBottom: 'parent',
                    widthMode: CassowaryPositionedSizeMode.fixed,
                    width: 100,
                    heightMode: CassowaryPositionedSizeMode.fixed,
                    height: 80,
                    child: Container(
                      key: childKey,
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify component is centered
      final childOffset = tester.getTopLeft(find.byKey(childKey));
      expect(childOffset.dx, equals(150.0)); // (400 - 100) / 2
      expect(childOffset.dy, equals(110.0)); // (300 - 80) / 2
    });

    testWidgets('Boundary Condition Test - Minimum Size Constraints', (WidgetTester tester) async {
      const childKey = Key('min_size_child');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 50,
              height: 30,
              child: CassowaryLayout(
                widthMode: CassowaryLayoutSizeMode.fixed,
                width: 200,
                // Exceeds parent container constraints
                heightMode: CassowaryLayoutSizeMode.fixed,
                height: 150,
                // Exceeds parent container constraints
                children: [
                  CassowaryPositioned(
                    id: 'min_size_child',
                    leftToLeft: 'parent',
                    topToTop: 'parent',
                    widthMode: CassowaryPositionedSizeMode.fixed,
                    width: 20,
                    heightMode: CassowaryPositionedSizeMode.fixed,
                    height: 15,
                    child: Container(
                      key: childKey,
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify parent container is limited by external constraints
      final layoutSize = tester.getSize(find.ancestor(
        of: find.byKey(childKey),
        matching: find.byType(CassowaryLayout),
      ));
      expect(layoutSize.width, equals(50.0)); // Limited by parent container constraints
      expect(layoutSize.height, equals(30.0)); // Limited by parent container constraints
    });

    testWidgets('CassowaryConstraints Equality Test', (WidgetTester tester) async {
      const constraints1 = CassowaryConstraints(
        id: 'test',
        widthMode: CassowaryPositionedSizeMode.fixed,
        width: 100,
        heightMode: CassowaryPositionedSizeMode.wrap,
        leftToLeft: 'parent',
        topToTop: 'parent',
        marginLeft: 10,
        marginTop: 20,
      );

      const constraints2 = CassowaryConstraints(
        id: 'test',
        widthMode: CassowaryPositionedSizeMode.fixed,
        width: 100,
        heightMode: CassowaryPositionedSizeMode.wrap,
        leftToLeft: 'parent',
        topToTop: 'parent',
        marginLeft: 10,
        marginTop: 20,
      );

      const constraints3 = CassowaryConstraints(
        id: 'test',
        widthMode: CassowaryPositionedSizeMode.fixed,
        width: 200,
        // Different value
        heightMode: CassowaryPositionedSizeMode.wrap,
        leftToLeft: 'parent',
        topToTop: 'parent',
        marginLeft: 10,
        marginTop: 20,
      );

      // Test equality
      expect(constraints1, equals(constraints2));
      expect(constraints1, isNot(equals(constraints3)));

      // Test hashCode
      expect(constraints1.hashCode, equals(constraints2.hashCode));
      expect(constraints1.hashCode, isNot(equals(constraints3.hashCode)));
    });
  });
}
