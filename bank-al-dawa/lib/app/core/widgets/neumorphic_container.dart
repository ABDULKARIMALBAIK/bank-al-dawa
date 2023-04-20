// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class NeumorphicContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Duration duration;
  final bool isEffective;
  final bool isInnerShadow;
  final VoidCallback onTab;
  final VoidCallback? onLongPress;

  final Offset distance = const Offset(7, 7);

  const NeumorphicContainer({
    required this.backgroundColor,
    required this.child,
    required this.onTab,
    this.onLongPress,
    Key? key,
    this.isInnerShadow = false,
    this.isEffective = false,
    this.padding = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
    this.duration = Duration.zero,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NeumorphicContainerState();
}

class _NeumorphicContainerState extends State<NeumorphicContainer> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (_) {
        if (widget.isEffective) {
          setState(() {
            isPressed = false;
          });
        }
      },
      onPointerDown: (_) {
        if (widget.isEffective) {
          setState(() {
            isPressed = true;
          });
        }
      },
      child: GestureDetector(
        onLongPress: widget.onLongPress,
        onTap: widget.onTab,
        child: AnimatedContainer(
          padding: widget.padding,
          duration: widget.duration,
          decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: widget.borderRadius,
              boxShadow: [
                BoxShadow(
                    blurRadius: 17, //30
                    offset: widget.isEffective
                        ? (isPressed ? const Offset(0, 0) : -widget.distance)
                        : -widget.distance, //-widget.distance
                    color: widget.isEffective
                        ? (isPressed
                            ? Theme.of(context).hintColor.withOpacity(0.01)
                            : Theme.of(context).hintColor)
                        : Theme.of(context).hintColor,
                    inset: widget.isInnerShadow),
                BoxShadow(
                    blurRadius: 17, //30
                    offset: widget.isEffective
                        ? (isPressed ? const Offset(0, 0) : widget.distance)
                        : widget.distance, //widget.distance
                    color: widget.isEffective
                        ? (isPressed
                            ? Theme.of(context).hintColor.withOpacity(0.01)
                            : Theme.of(context).dividerColor)
                        : Theme.of(context).dividerColor,
                    inset: widget.isInnerShadow),
              ]),
          child: widget.child,
        ),
      ),
    );
  }
}
