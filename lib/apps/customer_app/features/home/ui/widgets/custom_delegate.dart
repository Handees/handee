import 'package:flutter/material.dart';
import '../../../../../../shared/res/shapes.dart';

class CustomDelegate extends SliverPersistentHeaderDelegate {
  CustomDelegate({
    required this.height,
    required this.child,
    this.shape = Shapes.bigShape,
    this.padding = const EdgeInsets.symmetric(
      vertical: 16,
    ),
    this.elevation = 4.0,
  });

  final double height;
  final Widget child;
  final ShapeBorder shape;
  final EdgeInsets padding;
  final double elevation;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      child: Padding(
        padding: padding,
        child: Material(
          elevation: elevation,
          shape: shape,
          clipBehavior: Clip.hardEdge,
          shadowColor: Theme.of(context).colorScheme.shadow,
          child: child,
        ),
      ),
    );
  }

  @override
  double get maxExtent => height + padding.vertical;

  @override
  double get minExtent => height + padding.vertical;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}


