# CassowaryLayout

A Flutter constraint layout widget that uses the Cassowary constraint solving algorithm to create flexible and responsive layouts.

## Features

- **Flexible Size Modes**: Support for wrap, expand, and fixed sizing modes for both the layout container and child widgets
- **Constraint-Based Positioning**: Define relationships between widgets using left, right, top, and bottom anchors
- **Margin Support**: Full margin control for all four sides of child widgets
- **Match Parent Sizing**: Child widgets can automatically size themselves to match parent constraints
- **Multi-Child Layouts**: Support for complex layouts with multiple interdependent child widgets
- **Boundary Condition Handling**: Robust handling of edge cases and constraint conflicts
- **Performance Optimized**: Uses the efficient Cassowary constraint solver algorithm

## Getting Started

### Installation

Add `constraint_layout` to your `pubspec.yaml` file:

```yaml
dependencies:
  constraint_layout: ^0.0.1
```

### Import

```dart
import 'package:constraint_layout/cassowary_layout.dart';
```

## Usage

### Basic Layout

Create a simple layout with a child widget positioned at the top-left:

```dart
CassowaryLayout(
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
        color: Colors.red,
        child: Text('Hello World'),
      ),
    ),
  ],
)
```

### Center Alignment

Center a widget both horizontally and vertically:

```dart
CassowaryLayout(
  widthMode: CassowaryLayoutSizeMode.expand,
  heightMode: CassowaryLayoutSizeMode.expand,
  children: [
    CassowaryPositioned(
      id: 'centered',
      leftToLeft: 'parent',
      rightToRight: 'parent',
      topToTop: 'parent',
      bottomToBottom: 'parent',
      widthMode: CassowaryPositionedSizeMode.fixed,
      width: 200,
      heightMode: CassowaryPositionedSizeMode.fixed,
      height: 100,
      child: Container(
        color: Colors.blue,
        child: Center(child: Text('Centered')),
      ),
    ),
  ],
)
```

### Multiple Widgets with Constraints

Create a layout with multiple widgets that depend on each other:

```dart
CassowaryLayout(
  widthMode: CassowaryLayoutSizeMode.expand,
  heightMode: CassowaryLayoutSizeMode.expand,
  children: [
    // First widget
    CassowaryPositioned(
      id: 'widget1',
      leftToLeft: 'parent',
      topToTop: 'parent',
      widthMode: CassowaryPositionedSizeMode.fixed,
      width: 100,
      heightMode: CassowaryPositionedSizeMode.fixed,
      height: 80,
      child: Container(color: Colors.red),
    ),
    // Second widget positioned to the right of the first
    CassowaryPositioned(
      id: 'widget2',
      leftToRight: 'widget1',
      topToTop: 'parent',
      widthMode: CassowaryPositionedSizeMode.fixed,
      width: 120,
      heightMode: CassowaryPositionedSizeMode.fixed,
      height: 60,
      marginLeft: 20,
      child: Container(color: Colors.green),
    ),
  ],
)
```

### Match Parent Size

Create a widget that fills the entire parent container with margins:

```dart
CassowaryLayout(
  widthMode: CassowaryLayoutSizeMode.expand,
  heightMode: CassowaryLayoutSizeMode.expand,
  children: [
    CassowaryPositioned(
      id: 'fullscreen',
      leftToLeft: 'parent',
      rightToRight: 'parent',
      topToTop: 'parent',
      bottomToBottom: 'parent',
      widthMode: CassowaryPositionedSizeMode.match,
      heightMode: CassowaryPositionedSizeMode.match,
      marginLeft: 16,
      marginRight: 16,
      marginTop: 24,
      marginBottom: 24,
      child: Container(
        color: Colors.purple,
        child: Center(child: Text('Full Screen with Margins')),
      ),
    ),
  ],
)
```

## API Reference

### CassowaryLayout

The main layout widget that contains positioned children.

**Properties:**
- `widthMode`: How the layout calculates its width (`wrap`, `expand`, `fixed`)
- `heightMode`: How the layout calculates its height (`wrap`, `expand`, `fixed`)
- `width`: Fixed width value (used when `widthMode` is `fixed`)
- `height`: Fixed height value (used when `heightMode` is `fixed`)
- `children`: List of `CassowaryPositioned` widgets

### CassowaryPositioned

A widget that positions its child using constraints.

**Properties:**
- `id`: Unique identifier for referencing in constraints
- `widthMode`/`heightMode`: Size calculation mode (`wrap`, `fixed`, `match`)
- `width`/`height`: Fixed size values
- `leftToLeft`/`leftToRight`: Left edge constraints
- `rightToLeft`/`rightToRight`: Right edge constraints
- `topToTop`/`topToBottom`: Top edge constraints
- `bottomToTop`/`bottomToBottom`: Bottom edge constraints
- `marginLeft`/`marginRight`/`marginTop`/`marginBottom`: Margin values

### Size Modes

**CassowaryLayoutSizeMode:**
- `wrap`: Size adapts to content
- `expand`: Expands to fill available space
- `fixed`: Uses specified fixed size

**CassowaryPositionedSizeMode:**
- `wrap`: Size adapts to child content
- `fixed`: Uses specified fixed size
- `match`: Size determined by constraints