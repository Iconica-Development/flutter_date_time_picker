// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

/// Custom scroll physics for locking page scroll.
class LockingPageScrollPhysics extends ScrollPhysics {
  /// Function to determine if scrolling to the next page is allowed.
  final bool Function() allowedNextPage;

  /// Function to determine if scrolling to the previous page is allowed.
  final bool Function() allowedPreviousPage;

  /// Constructs LockingPageScrollPhysics.
  const LockingPageScrollPhysics({
    required this.allowedNextPage,
    required this.allowedPreviousPage,
    ScrollPhysics? parent,
  }) : super(parent: parent);

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return LockingPageScrollPhysics(
        allowedNextPage: allowedNextPage,
        allowedPreviousPage: allowedPreviousPage,
        parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    bool movingLeft = value > position.pixels;
    if (movingLeft && allowedNextPage()) {
      return super.applyBoundaryConditions(position, value);
    }
    if (!movingLeft && allowedPreviousPage()) {
      return super.applyBoundaryConditions(position, value);
    }
    return value - position.pixels;
  }
}
