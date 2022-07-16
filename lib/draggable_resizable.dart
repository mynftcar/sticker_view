import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sticker_view/resize_point.dart';
import 'package:sticker_view/stickers/drag_update_model.dart';
import 'constants.dart';
import 'draggable_point.dart';
import 'floating_action_icon.dart';

// const _floatingActionPadding = 0.0;

/// {@template draggable_resizable}
/// A widget which allows a user to drag and resize the provided [child].
/// {@endtemplate}
class DraggableResizable extends StatefulWidget {
  /// {@macro draggable_resizable}
  DraggableResizable({
    Key? key,
    required this.child,
    required this.size,
    BoxConstraints? constraints,
    this.onUpdate,
    this.onLayerTapped,
    this.onEdit,
    this.onDelete,
    this.canTransform = false,
  })  : constraints = constraints ?? BoxConstraints.loose(Size.infinite),
        super(key: key);

  /// The child which will be draggable/resizable.
  final Widget child;

  // final VoidCallback? onTap;

  /// Drag/Resize value setter.
  final ValueSetter<DragUpdate>? onUpdate;

  /// Delete callback
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onLayerTapped;

  /// Whether or not the asset can be dragged or resized.
  /// Defaults to false.
  final bool canTransform;

  /// The child's original size.
  final Size size;

  /// The child's constraints.
  /// Defaults to [BoxConstraints.loose(Size.infinite)].
  final BoxConstraints constraints;

  @override
  _DraggableResizableState createState() => _DraggableResizableState();
}

class _DraggableResizableState extends State<DraggableResizable> {
  late Size size;
  late BoxConstraints constraints;
  late double angle;
  late double angleDelta;
  late double baseAngle;
  late double scale;

  bool get isTouchInputSupported => true;
  Offset position = Offset.zero;

  @override
  void initState() {
    super.initState();
    size = widget.size;
    //imgSize = widget.child.
    print("initState Widget " + widget.size.toString());
    constraints = const BoxConstraints.expand(width: 1, height: 1);
    angle = 0;
    baseAngle = 0;
    angleDelta = 0;
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.size.width / widget.size.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        position = position == Offset.zero
            ? Offset(
                constraints.maxWidth / 2 - (size.width / 2),
                constraints.maxHeight / 2 - (size.height / 2),
              )
            : position;

        final normalizedWidth = size.width;
        //final normalizedHeight = normalizedWidth / aspectRatio;
        final normalizedHeight = size.height;
        final newSize = Size(normalizedWidth, normalizedHeight);

        if (widget.constraints.isSatisfiedBy(newSize)) {
          size = newSize;
        }

        final normalizedLeft = position.dx;
        final normalizedTop = position.dy;

        void onUpdate() {

          final normalizedPosition = Offset(
            normalizedLeft +
                (Constants.floatingActionPadding / 2) +
                (Constants.cornerDiameter / 2),
            normalizedTop +
                (Constants.floatingActionPadding / 2) +
                (Constants.cornerDiameter / 2),
          );

          print("onUpdate Widget " + widget.size.toString() + " |Z|" );

          widget.onUpdate?.call(
            DragUpdate(
              position: normalizedPosition,
              size: size,
              constraints: Size(constraints.maxWidth, constraints.maxHeight),
              angle: angle,
              scale: 1,
            ),
          );
        }

        // void onDragTopLeft(Offset details) {
        //   final mid = (details.dx + details.dy) / 2;
        //   final newHeight = math.max((size.height - (2 * mid)), 0.0);
        //   final newWidth = math.max(size.width - (2 * mid), 0.0);
        //   final updatedSize = Size(newWidth, newHeight);

        //   if (!widget.constraints.isSatisfiedBy(updatedSize)) return;

        //   final updatedPosition = Offset(position.dx + mid, position.dy + mid);

        //   setState(() {
        //     size = updatedSize;
        //     position = updatedPosition;
        //   });

        //   onUpdate();
        // }

        // ignore: unused_element
        void onDragTopRight(Offset details) {
          final mid = (details.dx + (details.dy * -1)) / 2;
          final newHeight = math.max(size.height + (2 * mid), 0.0);
          final newWidth = math.max(size.width + (2 * mid), 0.0);
          final updatedSize = Size(newWidth, newHeight);

          if (!widget.constraints.isSatisfiedBy(updatedSize)) return;

          final updatedPosition = Offset(position.dx - mid, position.dy - mid);

          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });

          onUpdate();
        }

        // ignore: unused_element
        void onDragBottomLeft(Offset details) {
          final mid = ((details.dx * -1) + details.dy) / 2;
          final newHeight = math.max(size.height + (2 * mid), 0.0);
          final newWidth = math.max(size.width + (2 * mid), 0.0);
          final updatedSize = Size(newWidth, newHeight);

          // if (!widget.constraints.isSatisfiedBy(updatedSize)) return;
          final updatedPosition = Offset(position.dx - mid, position.dy - mid);

          // if (updatedSize > Size(100, 100)) {
          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });
          // }

          onUpdate();
        }

        void onDragBottomRight(Offset details) {
          final mid = (details.dx + details.dy) / 2;
          final newHeight = math.max(size.height + (2 * mid), 0.0);
          final newWidth = math.max(size.width + (2 * mid), 0.0);
          final updatedSize = Size(newWidth, newHeight);

          // if (!widget.constraints.isSatisfiedBy(updatedSize)) return;

          final updatedPosition = Offset(position.dx - mid, position.dy - mid);
          // minimum size of the sticker should be Size(50,50)
          if (updatedSize > const Size(50, 50)) {
            setState(() {
              size = updatedSize;
              position = updatedPosition;
            });
          }

          onUpdate();
        }

        final decoratedChild = Container(
          key: const Key('draggableResizable_child_container'),
          alignment: Alignment.center,
          height: normalizedHeight + Constants.cornerDiameter + Constants.floatingActionPadding,
          width: normalizedWidth + Constants.cornerDiameter + Constants.floatingActionPadding,
          child: Container(
            height: normalizedHeight,
            width: normalizedWidth,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: widget.canTransform ? Colors.blue : Colors.transparent,
              ),
            ),
            child: Center(child: widget.child),
          ),
        );

        final topLeftCorner = FloatingActionIcon(
          key: const Key('draggableResizable_editFloatingActionIcon'),
          iconData: Icons.edit,
          onTap: widget.onEdit,
        );

        final topCenter = FloatingActionIcon(
          key: const Key('draggableResizable_layerFloatingActionIcon'),
          iconData: Icons.layers,
          onTap: widget.onLayerTapped,
        );
        // final topLeftCorner = ResizePoint(
        //   key: const Key('draggableResizable_topLeftResizePoint'),
        //   type: ResizePointType.topLeft,
        //   onDrag: onDragTopLeft,
        // );

        // final topRightCorner = ResizePoint(
        //   key: const Key('draggableResizable_topRightResizePoint'),
        //   type: ResizePointType.topRight,
        //   onDrag: onDragTopRight,
        // );

        // final bottomLeftCorner = ResizePoint(
        //   key: const Key('draggableResizable_bottomLeftResizePoint'),
        //   type: ResizePointType.bottomLeft,
        //   onDrag: onDragBottomLeft,
        //   // iconData: Icons.zoom_out_map,
        // );

        final bottomRightCorner = ResizePoint(
          key: const Key('draggableResizable_bottomRightResizePoint'),
          type: ResizePointType.bottomRight,
          onDrag: onDragBottomRight,
          iconData: Icons.zoom_out_map,
        );

        final deleteButton = FloatingActionIcon(
          key: const Key('draggableResizable_deleteFloatingActionIcon'),
          iconData: Icons.delete,
          onTap: widget.onDelete,
        );

        final center = Offset(
          -((normalizedHeight / 2) +
              (Constants.floatingActionDiameter / 2) +
              (Constants.cornerDiameter / 2) +
              (Constants.floatingActionPadding / 2)),
          // (_floatingActionDiameter + _cornerDiameter) / 2,
          (normalizedHeight / 2) +
              (Constants.floatingActionDiameter / 2) +
              (Constants.cornerDiameter / 2) +
              (Constants.floatingActionPadding / 2),
        );

        final rotateAnchor = GestureDetector(
          key: const Key('draggableResizable_rotate_gestureDetector'),
          onScaleStart: (details) {
            final offsetFromCenter = details.localFocalPoint - center;
            setState(() => angleDelta = baseAngle -
                offsetFromCenter.direction -
                Constants.floatingActionDiameter);
          },
          onScaleUpdate: (details) {
            final offsetFromCenter = details.localFocalPoint - center;

            setState(
              () {
                angle = offsetFromCenter.direction + angleDelta * 0.55;
              },
            );
            onUpdate();
          },
          onScaleEnd: (_) => setState(() => baseAngle = angle),
          child: FloatingActionIcon(
            key: const Key('draggableResizable_rotateFloatingActionIcon'),
            iconData: Icons.rotate_90_degrees_ccw,
            onTap: () {},
          ),
        );

        if (this.constraints != constraints) {
          this.constraints = constraints;
          onUpdate();
        }

        return Stack(
          children: <Widget>[
            Positioned(
              top: normalizedTop,
              left: normalizedLeft,
              child: Transform(
                alignment: Alignment.topLeft,
                transform: Matrix4.identity()
                  ..scale(1.0)
                  ..rotateZ(angle),
                child: DraggablePoint(
                  key: const Key('draggableResizable_childDraggablePoint'),

                  onTap: onUpdate,

                  onDrag: (d) {
                    print("dragging");

                    setState(() {
                      position = Offset(position.dx + d.dx, position.dy + d.dy);
                    });
                    onUpdate();
                  },

                  onScale: (s) {
                    print("scaling");
                    final updatedSize = Size(
                      widget.size.width * s,
                      widget.size.height * s,
                    );

                    if (!widget.constraints.isSatisfiedBy(updatedSize)) return;

                    final midX = position.dx + (size.width / 2);
                    final midY = position.dy + (size.height / 2);
                    final updatedPosition = Offset(
                      midX - (updatedSize.width / 2),
                      midY - (updatedSize.height / 2),
                    );

                    setState(() {
                      size = updatedSize;
                      position = updatedPosition;
                      scale = s;
                    });
                    onUpdate();
                  },

                  onRotate: (a) {
                    print('rotate');
                    setState(() => angle = a * 0.5);
                    onUpdate();
                  },

                  child: Stack(
                    // Add corner handles if this is the selected element
                    children: [
                      decoratedChild,
                      if (widget.canTransform && isTouchInputSupported) ...[
                        // Positioned(
                        //   top: Constants.floatingActionPadding / 2,
                        //   left: Constants.floatingActionPadding / 2,
                        //   child: topLeftCorner,
                        // ),
                        // Positioned(
                        //   right: (normalizedWidth / 2) -
                        //       (Constants.floatingActionDiameter / 2) +
                        //       (Constants.cornerDiameter / 2) +
                        //       (Constants.floatingActionPadding / 2),
                        //   child: topCenter,
                        // ),
                        // Positioned(
                        //   bottom: Constants.floatingActionPadding / 2,
                        //   left: Constants.floatingActionPadding / 2,
                        //   child: deleteButton,
                        // ),
                        Positioned(
                          top: normalizedHeight + Constants.floatingActionPadding / 2,
                          left: normalizedWidth + Constants.floatingActionPadding / 2,
                          child: bottomRightCorner,
                        ),
                        Positioned(
                          top: Constants.floatingActionPadding / 2,
                          right: Constants.floatingActionPadding / 2,
                          child: rotateAnchor,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}





