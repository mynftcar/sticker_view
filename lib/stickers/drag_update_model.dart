import 'dart:ui';

/// {@template drag_update}
/// Drag update model which includes the position and size.
/// {@endtemplate}
class DragUpdate {
  /// {@macro drag_update}
  const DragUpdate({
    required this.angle,
    required this.position,
    required this.size,
    required this.constraints,
    required this.scale,
  });

  /// The angle of the draggable asset.
  final double angle;

  /// The position of the draggable asset.
  final Offset position;

  /// The size of the draggable asset.
  final Size size;

  /// The constraints of the parent view.
  final Size constraints;

  /// The scale of the draggable asset.
  final double scale;
}
