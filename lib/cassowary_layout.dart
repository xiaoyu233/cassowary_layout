library cassowary_layout;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cassowary/cassowary.dart';

/// 存储需要重新计算固有尺寸的wrap模式组件信息
class _WrapComponent {
  final RenderBox child;
  final CassowaryConstraints childConstraints;
  final Variable widthVar;
  final Variable heightVar;
  final bool isWidthWrap;
  final bool isHeightWrap;

  _WrapComponent({
    required this.child,
    required this.childConstraints,
    required this.widthVar,
    required this.heightVar,
    required this.isWidthWrap,
    required this.isHeightWrap,
  });
}

/// CassowaryLayout 组件的尺寸计算模式枚举
enum CassowaryLayoutSizeMode {
  /// 自适应内容尺寸
  wrap,

  /// 扩展到父组件约束的最大值
  expand,

  /// 使用固定尺寸
  fixed,
}

/// CassowaryPositioned 子组件的尺寸计算模式枚举
enum CassowaryPositionedSizeMode {
  /// 自适应内容尺寸
  wrap,

  /// 使用固定尺寸
  fixed,

  /// 由约束完全决定尺寸
  match,
}

/// 约束锚点类型
enum ConstraintAnchor {
  left,
  right,
  top,
  bottom,
}

/// 子组件约束信息
class CassowaryConstraints {
  const CassowaryConstraints({
    this.id,
    this.widthMode = CassowaryPositionedSizeMode.wrap,
    this.width = 0.0,
    this.heightMode = CassowaryPositionedSizeMode.wrap,
    this.height = 0.0,
    this.leftToLeft,
    this.leftToRight,
    this.rightToRight,
    this.rightToLeft,
    this.topToTop,
    this.topToBottom,
    this.bottomToBottom,
    this.bottomToTop,
    this.marginLeft = 0.0,
    this.marginRight = 0.0,
    this.marginTop = 0.0,
    this.marginBottom = 0.0,
  });

  /// 子组件唯一标识符
  final String? id;

  /// 宽度模式
  final CassowaryPositionedSizeMode widthMode;

  /// 固定宽度值
  final double width;

  /// 高度模式
  final CassowaryPositionedSizeMode heightMode;

  /// 固定高度值
  final double height;

  /// 左边缘约束
  final String? leftToLeft;
  final String? leftToRight;

  /// 右边缘约束
  final String? rightToRight;
  final String? rightToLeft;

  /// 上边缘约束
  final String? topToTop;
  final String? topToBottom;

  /// 下边缘约束
  final String? bottomToBottom;
  final String? bottomToTop;

  /// 边距
  final double marginLeft;
  final double marginRight;
  final double marginTop;
  final double marginBottom;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CassowaryConstraints &&
        other.id == id &&
        other.widthMode == widthMode &&
        other.width == width &&
        other.heightMode == heightMode &&
        other.height == height &&
        other.leftToLeft == leftToLeft &&
        other.leftToRight == leftToRight &&
        other.rightToRight == rightToRight &&
        other.rightToLeft == rightToLeft &&
        other.topToTop == topToTop &&
        other.topToBottom == topToBottom &&
        other.bottomToBottom == bottomToBottom &&
        other.bottomToTop == bottomToTop &&
        other.marginLeft == marginLeft &&
        other.marginRight == marginRight &&
        other.marginTop == marginTop &&
        other.marginBottom == marginBottom;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      widthMode,
      width,
      heightMode,
      height,
      leftToLeft,
      leftToRight,
      rightToRight,
      rightToLeft,
      topToTop,
      topToBottom,
      bottomToBottom,
      bottomToTop,
      marginLeft,
      marginRight,
      marginTop,
      marginBottom,
    );
  }
}

/// 子组件包装器
class CassowaryPositioned extends ParentDataWidget<CassowaryParentData> {
  CassowaryPositioned({
    super.key,
    required super.child,
    this.id,
    this.widthMode = CassowaryPositionedSizeMode.wrap,
    this.width = 0.0,
    this.heightMode = CassowaryPositionedSizeMode.wrap,
    this.height = 0.0,
    this.leftToLeft,
    this.leftToRight,
    this.rightToRight,
    this.rightToLeft,
    this.topToTop,
    this.topToBottom,
    this.bottomToBottom,
    this.bottomToTop,
    this.marginLeft = 0.0,
    this.marginTop = 0.0,
    this.marginRight = 0.0,
    this.marginBottom = 0.0,
  }) {
    // 检查左右边缘约束
    final leftConstraints = [leftToLeft, leftToRight].where((c) => c != null).length;
    final rightConstraints = [rightToRight, rightToLeft].where((c) => c != null).length;

    // 检查上下边缘约束
    final topConstraints = [topToTop, topToBottom].where((c) => c != null).length;
    final bottomConstraints = [bottomToBottom, bottomToTop].where((c) => c != null).length;

    // 规则1: 水平方向约束校验
    // 必须至少存在左或右边缘的一条约束
    assert(leftConstraints != 0 || rightConstraints != 0);
    // 最多允许左右边缘各一条约束
    assert (leftConstraints <= 1 && rightConstraints <= 1);

    // 规则2: 垂直方向约束校验
    // 必须至少存在上或下边缘的一条约束
    assert (topConstraints != 0 || bottomConstraints != 0);
    // 最多允许上下边缘各一条约束
    assert (topConstraints <= 1 && bottomConstraints <= 1);

    // 规则3: match模式的特殊校验
    if (widthMode == CassowaryPositionedSizeMode.match) {
      assert (leftConstraints != 0 && rightConstraints != 0);
    }
    if (heightMode == CassowaryPositionedSizeMode.match) {
      assert (topConstraints != 0 && bottomConstraints != 0);
    }
  }

  final String? id;
  final CassowaryPositionedSizeMode widthMode;
  final double width;
  final CassowaryPositionedSizeMode heightMode;
  final double height;
  final String? leftToLeft;
  final String? leftToRight;
  final String? rightToRight;
  final String? rightToLeft;
  final String? topToTop;
  final String? topToBottom;
  final String? bottomToBottom;
  final String? bottomToTop;
  final double marginLeft;
  final double marginTop;
  final double marginRight;
  final double marginBottom;

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData as CassowaryParentData;
    bool needsLayout = false;

    final newConstraints = CassowaryConstraints(
      id: id,
      widthMode: widthMode,
      width: width,
      heightMode: heightMode,
      height: height,
      leftToLeft: leftToLeft,
      leftToRight: leftToRight,
      rightToRight: rightToRight,
      rightToLeft: rightToLeft,
      topToTop: topToTop,
      topToBottom: topToBottom,
      bottomToBottom: bottomToBottom,
      bottomToTop: bottomToTop,
      marginLeft: marginLeft,
      marginTop: marginTop,
      marginRight: marginRight,
      marginBottom: marginBottom,
    );

    if (parentData.constraints != newConstraints) {
      parentData.constraints = newConstraints;
      needsLayout = true;
    }

    if (needsLayout) {
      final targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => CassowaryLayout;
}

/// 父数据类
class CassowaryParentData extends ContainerBoxParentData<RenderBox> {
  CassowaryConstraints? constraints;

  // 约束求解相关变量
  Variable? leftVar;
  Variable? rightVar;
  Variable? topVar;
  Variable? bottomVar;
  Variable? widthVar;
  Variable? heightVar;

  void initializeVariables() {
    leftVar ??= Variable(0.0);
    rightVar ??= Variable(0.0);
    topVar ??= Variable(0.0);
    bottomVar ??= Variable(0.0);
    widthVar ??= Variable(0.0);
    heightVar ??= Variable(0.0);
  }

  void disposeVariables() {
    leftVar = null;
    rightVar = null;
    topVar = null;
    bottomVar = null;
    widthVar = null;
    heightVar = null;
  }
}

/// CassowaryLayout 主组件
class CassowaryLayout extends MultiChildRenderObjectWidget {
  const CassowaryLayout({
    super.key,
    this.widthMode = CassowaryLayoutSizeMode.expand,
    this.width = 0.0,
    this.heightMode = CassowaryLayoutSizeMode.expand,
    this.height = 0.0,
    super.children,
  });

  /// 宽度模式
  final CassowaryLayoutSizeMode widthMode;

  /// 固定宽度值
  final double width;

  /// 高度模式
  final CassowaryLayoutSizeMode heightMode;

  /// 固定高度值
  final double height;

  @override
  RenderCassowaryLayout createRenderObject(BuildContext context) {
    return RenderCassowaryLayout(
      widthMode: widthMode,
      width: width,
      heightMode: heightMode,
      height: height,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderCassowaryLayout renderObject) {
    renderObject
      ..widthMode = widthMode
      ..width = width
      ..heightMode = heightMode
      ..height = height;
  }
}

class RenderCassowaryLayout extends RenderBox with
    ContainerRenderObjectMixin<RenderBox, CassowaryParentData>,
    RenderBoxContainerDefaultsMixin<RenderBox, CassowaryParentData> {
  RenderCassowaryLayout({
    required CassowaryLayoutSizeMode widthMode,
    double? width,
    required CassowaryLayoutSizeMode heightMode,
    double? height,
  })  : _widthMode = widthMode,
        _width = width,
        _heightMode = heightMode,
        _height = height;

  CassowaryLayoutSizeMode _widthMode;

  CassowaryLayoutSizeMode get widthMode => _widthMode;

  set widthMode(CassowaryLayoutSizeMode value) {
    if (_widthMode != value) {
      _widthMode = value;
      markNeedsLayout();
    }
  }

  double? _width;

  double? get width => _width;

  set width(double? value) {
    if (_width != value) {
      _width = value;
      markNeedsLayout();
    }
  }

  CassowaryLayoutSizeMode _heightMode;

  CassowaryLayoutSizeMode get heightMode => _heightMode;

  set heightMode(CassowaryLayoutSizeMode value) {
    if (_heightMode != value) {
      _heightMode = value;
      markNeedsLayout();
    }
  }

  double? _height;

  double? get height => _height;

  set height(double? value) {
    if (_height != value) {
      _height = value;
      markNeedsLayout();
    }
  }

  Solver _solver = Solver();
  final Map<String, CassowaryParentData> _childrenById = {};

  // 存储需要重新计算固有尺寸的wrap模式组件
  final List<_WrapComponent> _wrapComponents = [];

  // 父容器的约束变量
  late Variable _parentLeftVar;
  late Variable _parentRightVar;
  late Variable _parentTopVar;
  late Variable _parentBottomVar;
  late Variable _parentWidthVar;
  late Variable _parentHeightVar;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! CassowaryParentData) {
      child.parentData = CassowaryParentData();
    }
  }

  @override
  void performLayout() {
    _initializeParentVariables();
    _setupChildrenVariables();
    _setupConstraints();

    _solveConstraints();
    _layoutChildren();
    _calculateSize();
  }

  void _initializeParentVariables() {
    _parentLeftVar = Variable(0.0);
    _parentRightVar = Variable(0.0);
    _parentTopVar = Variable(0.0);
    _parentBottomVar = Variable(0.0);
    _parentWidthVar = Variable(0.0);
    _parentHeightVar = Variable(0.0);
  }

  void _setupChildrenVariables() {
    _childrenById.clear();

    RenderBox? child = firstChild;
    int index = 0;

    while (child != null) {
      final parentData = child.parentData as CassowaryParentData;
      parentData.initializeVariables();

      final id = parentData.constraints?.id ?? 'child_$index';
      _childrenById[id] = parentData;

      child = parentData.nextSibling;
      index++;
    }
  }

  void _setupConstraints() {
    _clearConstraints();

    // 设置父容器约束
    _setupParentConstraints();

    _wrapComponents.clear();
    // 设置子组件约束
    RenderBox? child = firstChild;
    while (child != null) {
      final parentData = child.parentData as CassowaryParentData;
      _setupChildConstraints(child, parentData);
      child = parentData.nextSibling;
    }
  }

  void _clearConstraints() {
    _solver = Solver();
  }

  void _setupParentConstraints() {
    // parent.left = 0
    _solver.addConstraint(Constraint(
      Expression([Term(_parentLeftVar, 1.0)], 0.0),
      Relation.equalTo,
    ));
    debugPrint("add parent basic constraint: parent.left = 0 [ _parentLeftVar == 0 ]");

    // parent.top = 0
    _solver.addConstraint(Constraint(
      Expression([Term(_parentTopVar, 1.0)], 0.0),
      Relation.equalTo,
    ));
    debugPrint("add parent basic constraint: parent.top = 0 [ _parentTopVar == 0 ]");

    // parent.right = parent.left + parent.width
    _solver.addConstraint(Constraint(
      Expression([
        Term(_parentRightVar, 1.0),
        Term(_parentLeftVar, -1.0),
        Term(_parentWidthVar, -1.0),
      ], 0.0),
      Relation.equalTo,
    ));
    debugPrint("add parent basic constraint: "
        "parent.right = parent.left + parent.width "
        "[ _parentRightVar - _parentLeftVar + _parentWidthVar == 0 ]"
    );

    // parent.bottom = parent.top + parent.height
    _solver.addConstraint(Constraint(
      Expression([
        Term(_parentBottomVar, 1.0),
        Term(_parentTopVar, -1.0),
        Term(_parentHeightVar, -1.0),
      ], 0.0),
      Relation.equalTo,
    ));
    debugPrint("add parent basic constraint: "
        "parent.bottom = parent.top + parent.height "
        "[ _parentBottomVar - _parentTopVar - _parentHeightVar == 0 ]"
    );

    switch (_widthMode) {
      case CassowaryLayoutSizeMode.wrap:
        debugPrint("parent width mode is wrap: ");

        for (final entry in _childrenById.entries) {
          final childData = entry.value;
          final childConstraints = childData.constraints;
          final rightVar = childData.rightVar;
          if (childConstraints != null && rightVar != null) {
            if(childConstraints.widthMode == CassowaryPositionedSizeMode.match){
              continue;
            }

            if (childConstraints.bottomToBottom == 'parent') {
              // child.right + child.marginRight <= parent.width
              _solver.addConstraint(Constraint(
                Expression([
                  Term(rightVar, 1.0),
                  Term(_parentWidthVar, -1.0),
                ], childConstraints.marginRight),
                Relation.lessThanOrEqualTo,
              ));
              debugPrint("  add parent size constraint with child:\n"
                  "    child.right + child.marginRight <= parent.width\n"
                  "    [ ${entry.key}.rightVar - _parentWidthVar + ${entry.key}.marginRight(${childConstraints.marginRight}) <= 0 ]");
            } else {
              // child.right <= parent.width
              _solver.addConstraint(Constraint(
                Expression([
                  Term(rightVar, 1.0),
                  Term(_parentWidthVar, -1.0),
                ], 0.0),
                Relation.lessThanOrEqualTo,
              ));
              debugPrint("  add parent size constraint with child:\n"
                  "    child.right <= parent.width\n"
                  "    [ ${entry.key}.rightVar - _parentWidthVar <= 0 ]");
            }
          }
        }
      case CassowaryLayoutSizeMode.expand:
        debugPrint("parent width mode is expand: ");

        // parent.width = constraints.maxWidth
        _solver.addConstraint(Constraint(
          Expression([Term(_parentWidthVar, 1.0)], -constraints.maxWidth),
          Relation.equalTo,
        ));
        debugPrint("  add parent size constraint: "
            "parent.width = constraints.maxWidth "
            "[ _parentWidthVar - constraints.maxWidth(${constraints.maxWidth}) == 0 ]"
        );
      case CassowaryLayoutSizeMode.fixed:
        debugPrint("parent width mode is fixed: ");

        final fixedWidth = _width ?? 0.0;
        final targetWidth = fixedWidth.clamp(constraints.minWidth, constraints.maxWidth);

        // parent.width = fixedWidth.clamp(constraints.minWidth, constraints.maxWidth)
        _solver.addConstraint(Constraint(
          Expression([Term(_parentWidthVar, 1.0)], -targetWidth),
          Relation.equalTo,
        ));
        debugPrint("  add parent size constraint: "
            "parent.width = fixedWidth.clamp(constraints.minWidth, constraints.maxWidth) "
            "[ _parentWidthVar - _width(${_width}).clamp(constraints.minWidth(${constraints.minWidth}), "
            "constraints.maxWidth(${constraints.maxWidth})) == 0 ]"
        );
    }

    switch (_heightMode) {
      case CassowaryLayoutSizeMode.wrap:
        debugPrint("parent height mode is wrap: ");
        for (final entry in _childrenById.entries) {
          final childData = entry.value;
          final childConstraints = childData.constraints;
          final bottomVar = childData.bottomVar;
          if (childConstraints != null && bottomVar != null) {
            if(childConstraints.heightMode == CassowaryPositionedSizeMode.match){
              continue;
            }

            if (childConstraints.bottomToBottom == 'parent') {
              // child.bottom + child.marginBottom <= parent.height
              _solver.addConstraint(Constraint(
                Expression([
                  Term(bottomVar, 1.0),
                  Term(_parentHeightVar, -1.0),
                ], childConstraints.marginBottom),
                Relation.lessThanOrEqualTo,
              ));
              debugPrint("  add parent size constraint with child:\n"
                  "    child.bottom + child.marginBottom <= parent.height\n"
                  "    [ ${entry.key}.bottomVar - _parentHeightVar + ${entry.key}.marginBottom(${childConstraints.marginBottom}) <= 0 ]");
            } else {
              // child.bottom <= parent.height
              _solver.addConstraint(Constraint(
                Expression([
                  Term(bottomVar, 1.0),
                  Term(_parentHeightVar, -1.0),
                ], 0.0),
                Relation.lessThanOrEqualTo,
              ));
              debugPrint("  add parent size constraint with child:\n"
                  "    child.bottom <= parent.height\n"
                  "    [ ${entry.key}.bottomVar - _parentHeightVar <= 0 ]");
            }
          }
        }
      case CassowaryLayoutSizeMode.expand:
        debugPrint("parent height mode is expand: ");
        _solver.addConstraint(Constraint(
          Expression([Term(_parentHeightVar, 1.0)], -constraints.maxHeight),
          Relation.equalTo,
        ));
        debugPrint("  add parent size constraint: "
            "parent.height = constraints.maxHeight "
            "[ _parentHeightVar - constraints.maxHeight(${constraints.maxHeight}) == 0 ]"
        );
      case CassowaryLayoutSizeMode.fixed:
        debugPrint("parent width mode is fixed: ");
        final fixedHeight = _height ?? 0.0;
        final targetHeight = fixedHeight.clamp(constraints.minHeight, constraints.maxHeight);
        _solver.addConstraint(Constraint(
          Expression([Term(_parentHeightVar, 1.0)], -targetHeight),
          Relation.equalTo,
        ));
        debugPrint("  add parent size constraint: "
            "parent.height = fixedHeight.clamp(constraints.minHeight, constraints.maxHeight) "
            "[ _parentHeightVar - _height(${_height}).clamp(constraints.minHeight(${constraints.minHeight}), "
            "constraints.maxHeight(${constraints.maxHeight})) == 0 ]"
        );
    }
  }

  void _setupChildConstraints(RenderBox child, CassowaryParentData parentData) {
    final childConstraints = parentData.constraints;
    if (childConstraints == null) {
      return;
    }

    final childId = parentData.constraints?.id ?? 'unknown';
    debugPrint("${childId}'s constraints: "
        "widthMode=${childConstraints.widthMode}, heightMode=${childConstraints.heightMode}\n"
        "  width=${childConstraints.width}, height=${childConstraints.height}\n"
        "  marginLeft=${childConstraints.marginLeft}, marginTop=${childConstraints.marginTop}\n"
        "  marginRight=${childConstraints.marginRight}, marginBottom=${childConstraints.marginBottom}"
    );

    final leftVar = parentData.leftVar!;
    final rightVar = parentData.rightVar!;
    final topVar = parentData.topVar!;
    final bottomVar = parentData.bottomVar!;
    final widthVar = parentData.widthVar!;
    final heightVar = parentData.heightVar!;

    // child.right = child.left + child.width
    _solver.addConstraint(Constraint(
      Expression([
        Term(rightVar, 1.0),
        Term(leftVar, -1.0),
        Term(widthVar, -1.0),
      ], 0.0),
      Relation.equalTo,
    ));
    debugPrint("add child basic constraint: "
        "child.right = child.left + child.width "
        "[ ${childId}.rightVar - ${childId}.leftVar - ${childId}.widthVar == 0 ]"
    );

    // child.bottom = child.top + child.height
    _solver.addConstraint(Constraint(
      Expression([
        Term(bottomVar, 1.0),
        Term(topVar, -1.0),
        Term(heightVar, -1.0),
      ], 0.0),
      Relation.equalTo,
    ));
    debugPrint("add child basic constraint: "
        "child.bottom = child.top + child.height "
        "[ ${childId}.bottomVar - ${childId}.topVar - ${childId}.heightVar == 0 ]"
    );

    _setupChildSizeConstraints(child, childConstraints, widthVar, heightVar);
    _setupChildPositionConstraints(
      childConstraints,
      leftVar,
      rightVar,
      topVar,
      bottomVar,
      widthVar,
      heightVar,
    );
  }

  void _setupChildSizeConstraints(
      RenderBox child,
      CassowaryConstraints childConstraints,
      Variable widthVar,
      Variable heightVar,
      ) {
    final childId = childConstraints.id ?? 'unknown';

    bool isWidthWrap = childConstraints.widthMode == CassowaryPositionedSizeMode.wrap;
    bool isHeightWrap = childConstraints.heightMode == CassowaryPositionedSizeMode.wrap;

    if (isWidthWrap && isHeightWrap) {
      debugPrint("${childId}'s widthMode: wrap, heightMode: wrap");

      final intrinsicSize = child.getDryLayout(constraints.loosen());
      debugPrint("  ${childId}'s dryLayout constraint: "
          "minWidth=0, maxWidth=${constraints.maxWidth}, "
          "minHeight=0, maxHeight=${constraints.maxHeight}"
      );
      debugPrint("  ${childId}'s intrinsic size: "
          "width=${intrinsicSize.width}, height=${intrinsicSize.height}"
      );

      // child.width = intrinsicSize.width
      _solver.addConstraint(Constraint(
        Expression([Term(widthVar, 1.0)], -intrinsicSize.width),
        Relation.equalTo,
      ));
      debugPrint("  add child(${childId}) constraint: "
          "child.width = intrinsicSize.width "
          "[ ${childId}.widthVar - intrinsicSize.width(${intrinsicSize.width}) == 0 ]"
      );

      // child.height = intrinsicSize.height
      _solver.addConstraint(Constraint(
        Expression([Term(heightVar, 1.0)], -intrinsicSize.height),
        Relation.equalTo,
      ));
      debugPrint("  add child(${childConstraints.id}) constraint: "
          "child.height = intrinsicSize.height "
          "[ ${childId}.heightVar - intrinsicSize.width(${height}) == 0 ]"
      );
    } else if (isWidthWrap || isHeightWrap) {
      if (childConstraints.heightMode == CassowaryPositionedSizeMode.fixed) {
        debugPrint("${childId}'s widthMode: wrap, heightMode: fixed");

        final availableHeight = childConstraints.height;
        final intrinsicWidth = child.getMaxIntrinsicWidth(availableHeight);
        debugPrint("  ${childId}'s intrinsic size: "
            "availableHeight=${availableHeight} "
            "intrinsicWidth=${intrinsicWidth}"
        );

        // child.width = intrinsicWidth
        _solver.addConstraint(Constraint(
          Expression([Term(widthVar, 1.0)], -intrinsicWidth),
          Relation.equalTo,
        ));
        debugPrint("  add child(${childId}) constraint: "
            "child.width = intrinsicWidth "
            "[ ${childId}.widthVar - intrinsicWidth(${intrinsicWidth}) == 0 ]"
        );
      } else if (childConstraints.widthMode == CassowaryPositionedSizeMode.fixed) {
        debugPrint("${childId}'s widthMode: fixed, heightMode: wrap");

        final availableWidth = childConstraints.width;
        final intrinsicHeight = child.getMaxIntrinsicHeight(availableWidth);
        debugPrint("  ${childId}'s intrinsic size: "
            "availableWidth=${availableWidth} "
            "intrinsicHeight=${intrinsicHeight}"
        );

        // child.height = intrinsicHeight
        _solver.addConstraint(Constraint(
          Expression([Term(heightVar, 1.0)], -intrinsicHeight),
          Relation.equalTo,
        ));
        debugPrint("  add child(${childId}) constraint: "
            "child.height = intrinsicHeight "
            "[ ${childId}.heightVar - intrinsicHeight(${intrinsicHeight}) == 0 ]"
        );
      } else {
        debugPrint("${childId}'s widthMode & heightMode = [ wrap & match ]");

        _wrapComponents.add(_WrapComponent(
          child: child,
          childConstraints: childConstraints,
          widthVar: widthVar,
          heightVar: heightVar,
          isWidthWrap: isWidthWrap,
          isHeightWrap: isHeightWrap,
        ));
      }
    }

    if (childConstraints.widthMode == CassowaryPositionedSizeMode.fixed) {
      debugPrint("${childId}'s widthMode: fixed");

      // child.width = fixedWidth
      _solver.addConstraint(Constraint(
        Expression([Term(widthVar, 1.0)], -childConstraints.width),
        Relation.equalTo,
      ));
      debugPrint("  add child(${childId}) constraint: "
          "child.width = fixedWidth "
          "[ ${childId}.widthVar - fixedWidth(childConstraints.width) == 0 ]"
      );
    }

    if (childConstraints.heightMode == CassowaryPositionedSizeMode.fixed) {
      debugPrint("${childId}'s heightMode: fixed");

      // child.height = fixedHeight
      _solver.addConstraint(Constraint(
        Expression([Term(heightVar, 1.0)], -childConstraints.height),
        Relation.equalTo,
      ));
      debugPrint("  add child(${childId}) constraint: "
          "child.height = fixedHeight "
          "[ ${childId}.heightVar - fixedHeight(childConstraints.height) == 0 ]"
      );
    }
  }

  void _setupChildPositionConstraints(
      CassowaryConstraints childConstraints,
      Variable leftVar,
      Variable rightVar,
      Variable topVar,
      Variable bottomVar,
      Variable widthVar,
      Variable heightVar,
      ) {
    final childId = childConstraints.id ?? 'unknown';

    Variable? targetLeftVar;
    Variable? targetRightVar;
    if (childConstraints.leftToLeft != null) {
      targetLeftVar = _getTargetData(childConstraints.leftToLeft!)?.leftVar;
    } else if (childConstraints.leftToRight != null) {
      targetLeftVar = _getTargetData(childConstraints.leftToRight!)?.rightVar;
    }
    if (childConstraints.rightToRight != null) {
      targetRightVar = _getTargetData(childConstraints.rightToRight!)?.rightVar;
    } else if (childConstraints.rightToLeft != null) {
      targetRightVar = _getTargetData(childConstraints.rightToLeft!)?.leftVar;
    }

    if (targetLeftVar != null && targetRightVar != null) {
      debugPrint("${childId}'s anchor: "
          "${childId}.targetLeftVar != null, "
          "${childId}.targetRightVar != null"
      );

      if (childConstraints.widthMode == CassowaryPositionedSizeMode.match) {
        debugPrint("${childId}'s widthMode: match");

        // child.width = targetRight - targetLeft - child.marginLeft - child.marginRight
        _solver.addConstraint(Constraint(
          Expression([
            Term(widthVar, 1.0),
            Term(targetRightVar, -1.0),
            Term(targetLeftVar, 1.0),
          ], childConstraints.marginLeft + childConstraints.marginRight),
          Relation.equalTo,
        ));
        debugPrint("  add child(${childId}) constraint:\n"
            "  child.width = targetRight - targetLeft - child.marginLeft - child.marginRight\n"
            "  [ ${childId}.widthVar - targetRightVar + targetLeftVar + "
            "childConstraints.marginLeft(${childConstraints.marginLeft}) + "
            "childConstraints.marginRight(${childConstraints.marginRight}) == 0 ]"
        );

        // child.left = targetLeft + child.marginLeft
        _solver.addConstraint(Constraint(
          Expression([
            Term(leftVar, 1.0),
            Term(targetLeftVar, -1.0),
          ], -childConstraints.marginLeft),
          Relation.equalTo,
        ));
        debugPrint("  add child(${childId}) constraint: "
            "child.left = targetLeft + child.marginLeft "
            "[ ${childId}.leftVar - targetLeftVar - "
            "${childId}.marginLeft(${childConstraints.marginLeft})  == 0 ]"
        );
      } else {
        debugPrint("${childId}'s widthMode: wrap or fixed");

        // 居中对齐约束：组件中心 = 可用空间中心 + 边距偏移
        // child.left + child.right = targetLeft + child.marginLeft + targetRight - child.marginRight
        _solver.addConstraint(Constraint(
          Expression([
            Term(leftVar, 1.0),
            Term(rightVar, 1.0),
            Term(targetLeftVar, -1.0),
            Term(targetRightVar, -1.0)
          ], -(childConstraints.marginLeft - childConstraints.marginRight)),
          Relation.equalTo,
        ));
        debugPrint("  add child(${childId}) constraint: "
            "child.left + child.right = targetLeft + child.marginLeft + targetRight - child.marginRight "
            "[ ${childId}.leftVar + ${childId}.rightVar - "
            "targetLeftVar - targetRightVar - ${childId}.marginLeft(${childConstraints.marginLeft}) + "
            "${childId}.marginRight(${childConstraints.marginRight}) ]"
        );
      }
    } else if (targetLeftVar != null) {
      debugPrint("${childId}'s anchor: "
          "${childId}.targetLeftVar != null"
      );

      // child.left = targetLeft + child.marginLeft
      _solver.addConstraint(Constraint(
        Expression([
          Term(leftVar, 1.0),
          Term(targetLeftVar, -1.0),
        ], -childConstraints.marginLeft),
        Relation.equalTo,
      ));
      debugPrint("  add child(${childId}) constraint: "
          "child.left = targetLeft + child.marginLeft "
          "[ ${childId}.leftVar - targetLeftVar - "
          "${childId}.marginLeft(${childConstraints.marginLeft}) == 0]"
      );
    } else if (targetRightVar != null) {
      debugPrint("${childId}'s anchor: "
          "${childId}.targetRightVar != null"
      );

      // child.right = targetRight - child.marginRight
      _solver.addConstraint(Constraint(
        Expression([
          Term(rightVar, 1.0),
          Term(targetRightVar, -1.0),
        ], childConstraints.marginRight),
        Relation.equalTo,
      ));
      debugPrint("  add child(${childId}) constraint: "
          "child.right = targetRight - child.marginRight "
          "[ ${childId}.rightVar - targetRightVar - "
          "${childId}.marginRight(${childConstraints.marginRight}) == 0]"
      );
    }

    Variable? targetTopVar;
    Variable? targetBottomVar;
    if (childConstraints.topToTop != null) {
      targetTopVar = _getTargetData(childConstraints.topToTop!)?.topVar;
    } else if (childConstraints.topToBottom != null) {
      targetTopVar = _getTargetData(childConstraints.topToBottom!)?.bottomVar;
    }
    if (childConstraints.bottomToBottom != null) {
      targetBottomVar = _getTargetData(childConstraints.bottomToBottom!)?.bottomVar;
    } else if (childConstraints.bottomToTop != null) {
      targetBottomVar = _getTargetData(childConstraints.bottomToTop!)?.topVar;
    }

    if (targetTopVar != null && targetBottomVar != null) {
      debugPrint("${childId}'s anchor: "
          "${childId}.targetTopVar != null, "
          "${childId}.targetBottomVar != null"
      );

      if (childConstraints.heightMode == CassowaryPositionedSizeMode.match) {
        debugPrint("${childId}'s heightMode: match");

        // child.height = targetBottom - targetTop - child.marginTop - child.marginBottom
        _solver.addConstraint(Constraint(
          Expression([
            Term(heightVar, 1.0),
            Term(targetBottomVar, -1.0),
            Term(targetTopVar, 1.0),
          ], childConstraints.marginTop + childConstraints.marginBottom),
          Relation.equalTo,
        ));
        debugPrint("  add child(${childId}) constraint:\n"
            "  child.height = targetBottom - targetTop - child.marginTop - child.marginBottom\n"
            "  [ ${childId}.heightVar - targetBottomVar + targetTopVar + "
            "childConstraints.marginTop(${childConstraints.marginTop}) + "
            "childConstraints.marginBottom(${childConstraints.marginBottom}) == 0 ]"
        );

        // child.top = targetTop + child.marginTop
        _solver.addConstraint(Constraint(
          Expression([
            Term(topVar, 1.0),
            Term(targetTopVar, -1.0),
          ], -childConstraints.marginTop),
          Relation.equalTo,
        ));
        debugPrint("  add child(${childId}) constraint: "
            "child.top = targetTop + child.marginTop "
            "[ ${childId}.topVar - targetTopVar - "
            "${childId}.marginTop(${childConstraints.marginTop})  == 0 ]"
        );
      } else {
        // child.top + child.bottom = targetTop + child.marginTop + targetBottom - child.marginBottom
        _solver.addConstraint(Constraint(
          Expression([
            Term(topVar, 1.0),
            Term(bottomVar, 1.0),
            Term(targetTopVar, -1.0),
            Term(targetBottomVar, -1.0)
          ], -(childConstraints.marginTop - childConstraints.marginBottom)),
          Relation.equalTo,
        ));
        debugPrint("  add child(${childId}) constraint:\n"
            "  child.top + child.bottom = targetTop + child.marginTop + targetBottom - child.marginBottom\n"
            "  [ ${childId}.topVar + ${childId}.bottomVar - "
            "targetTopVar - targetBottomVar - ${childId}.marginTop(${childConstraints.marginTop}) + "
            "${childId}.marginBottom(${childConstraints.marginBottom}) ]"
        );
      }
    } else if (targetTopVar != null) {
      debugPrint("${childId}'s anchor: "
          "${childId}.targetTopVar != null"
      );

      // child.top = targetTop + child.marginTop
      _solver.addConstraint(Constraint(
        Expression([
          Term(topVar, 1.0),
          Term(targetTopVar, -1.0),
        ], -childConstraints.marginTop),
        Relation.equalTo,
      ));
      debugPrint("  add child(${childId}) constraint: "
          "child.top = targetTop + child.marginTop "
          "[ ${childId}.topVar - targetTopVar - "
          "${childId}.marginTop(${childConstraints.marginTop}) == 0]"
      );
    } else if (targetBottomVar != null) {
      debugPrint("${childId}'s anchor: "
          "${childId}.targetBottomVar != null"
      );

      // child.bottom = targetBottom - child.marginBottom
      _solver.addConstraint(Constraint(
        Expression([
          Term(bottomVar, 1.0),
          Term(targetBottomVar, -1.0),
        ], childConstraints.marginBottom),
        Relation.equalTo,
      ));
      debugPrint("  add child(${childId}) constraint: "
          "child.bottom = targetBottom - child.marginBottom "
          "[ ${childId}.bottomVar - targetBottomVar - "
          "${childId}.marginBottom(${childConstraints.marginBottom}) == 0]"
      );
    }
  }

  CassowaryParentData? _getTargetData(String targetId) {
    if (targetId == 'parent') {
      final parentData = CassowaryParentData();
      parentData.leftVar = _parentLeftVar;
      parentData.rightVar = _parentRightVar;
      parentData.topVar = _parentTopVar;
      parentData.bottomVar = _parentBottomVar;
      parentData.widthVar = _parentWidthVar;
      parentData.heightVar = _parentHeightVar;
      return parentData;
    }
    return _childrenById[targetId];
  }

  void _solveConstraints() {
    try {
      _solver.flushUpdates();
      debugPrint("The first constraint solving completed:");
      _printSolvingResult();

      // 处理wrap模式组件
      if (_wrapComponents.isNotEmpty) {
        _processWrapComponents();
        _solver.flushUpdates();

        debugPrint("The second constraint solving completed:");
        _printSolvingResult();
      }
    } catch (e) {
      _applyDefaultLayout();
    }
  }

  void _processWrapComponents() {
    for (int i = 0; i < _wrapComponents.length; i++) {
      final wrapComponent = _wrapComponents[i];
      final childId = wrapComponent.childConstraints.id ?? 'unknown';

      if (wrapComponent.isWidthWrap) {
        debugPrint("${childId}'s widthMode: wrap");

        double availableHeight = wrapComponent.heightVar.value;
        final intrinsicWidth = wrapComponent.child.getMaxIntrinsicWidth(availableHeight);
        debugPrint("  ${childId}'s intrinsic size: "
            "availableHeight=${availableHeight} "
            "intrinsicWidth=${intrinsicWidth}"
        );

        // child.width = intrinsicWidth
        _solver.addConstraint(Constraint(
          Expression([Term(wrapComponent.widthVar, 1.0)], -intrinsicWidth),
          Relation.equalTo,
        ));
        debugPrint("  add child(${childId}) constraint: "
            "child.width = intrinsicWidth "
            "[ ${childId}.widthVar - intrinsicWidth(${intrinsicWidth}) == 0 ]"
        );
      }

      if (wrapComponent.isHeightWrap) {
        debugPrint("${childId}'s heightMode: wrap");

        double availableWidth = wrapComponent.widthVar.value;
        final intrinsicHeight = wrapComponent.child.getMaxIntrinsicHeight(availableWidth);
        debugPrint("  ${childId}'s intrinsic size: "
            "availableWidth=${availableWidth} "
            "intrinsicHeight=${intrinsicHeight}"
        );

        // child.height = intrinsicHeight
        _solver.addConstraint(Constraint(
          Expression([Term(wrapComponent.heightVar, 1.0)], -intrinsicHeight),
          Relation.equalTo,
        ));
        debugPrint("  add child(${childId}) constraint: "
            "child.height = intrinsicHeight "
            "[ ${childId}.heightVar - intrinsicHeight(${intrinsicHeight}) == 0 ]"
        );
      }
    }
  }

  void _layoutChildren() {
    RenderBox? child = firstChild;
    while (child != null) {
      final parentData = child.parentData as CassowaryParentData;

      final left = parentData.leftVar?.value ?? 0.0;
      final top = parentData.topVar?.value ?? 0.0;
      final width = (parentData.widthVar?.value ?? 0.0).clamp(0.0, double.infinity);
      final height = (parentData.heightVar?.value ?? 0.0).clamp(0.0, double.infinity);

      // 布局子组件
      child.layout(
        BoxConstraints.tightFor(width: width, height: height),
        parentUsesSize: false,
      );

      // 设置子组件位置
      parentData.offset = Offset(left, top);

      child = parentData.nextSibling;
    }
  }

  void _calculateSize() {
    final calculatedWidth = _parentWidthVar.value;
    final calculatedHeight = _parentHeightVar.value;

    final finalWidth = calculatedWidth.clamp(constraints.minWidth, constraints.maxWidth);
    final finalHeight = calculatedHeight.clamp(constraints.minHeight, constraints.maxHeight);

    size = Size(finalWidth, finalHeight);
  }

  void _printSolvingResult(){
    debugPrint("  parent's size and position:\n"
        "    width=${_parentWidthVar.value}, height=${_parentHeightVar.value}\n"
        "    left=${_parentLeftVar.value}, right=${_parentRightVar.value}, top=${_parentTopVar.value}, bottom=${_parentBottomVar.value}"
    );
    RenderBox? child = firstChild;
    while (child != null) {
      final parentData = child.parentData as CassowaryParentData;
      debugPrint("  ${parentData.constraints?.id ?? "unknown"}'s size and position:\n"
          "    width=${parentData.widthVar?.value}, height=${parentData.heightVar?.value}\n"
          "    left=${parentData.leftVar?.value}, right=${parentData.rightVar?.value}, top=${parentData.topVar?.value}, bottom=${parentData.bottomVar?.value}"
      );
      child = parentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  void _applyDefaultLayout() {
    RenderBox? child = firstChild;
    double currentY = 0.0;

    while (child != null) {
      final parentData = child.parentData as CassowaryParentData;

      child.layout(constraints.loosen(), parentUsesSize: true);
      parentData.offset = Offset(0, currentY);

      currentY += child.size.height;
      child = parentData.nextSibling;
    }
  }

  @override
  void dispose() {
    RenderBox? child = firstChild;
    while (child != null) {
      final parentData = child.parentData as CassowaryParentData;
      parentData.disposeVariables();
      child = parentData.nextSibling;
    }

    super.dispose();
  }
}
