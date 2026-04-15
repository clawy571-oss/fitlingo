import 'package:flutter/material.dart';

class TactileButton extends StatefulWidget {
  final Widget child;
  final Color color;
  final Color shadowColor;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final double shadowHeight;
  final Border? border;

  const TactileButton({
    super.key,
    required this.child,
    required this.color,
    required this.shadowColor,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.shadowHeight = 6,
    this.border,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isPressed ? widget.shadowHeight : 0, 0),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: widget.borderRadius,
          border: widget.border,
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: widget.shadowColor,
                    offset: Offset(0, widget.shadowHeight),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Padding(
          padding: widget.padding,
          child: widget.child,
        ),
      ),
    );
  }
}

class TactileIconButton extends StatefulWidget {
  final Widget child;
  final Color color;
  final Color shadowColor;
  final VoidCallback? onTap;
  final double size;
  final BorderRadius? borderRadius;
  final Border? border;

  const TactileIconButton({
    super.key,
    required this.child,
    required this.color,
    required this.shadowColor,
    this.onTap,
    this.size = 72,
    this.borderRadius,
    this.border,
  });

  @override
  State<TactileIconButton> createState() => _TactileIconButtonState();
}

class _TactileIconButtonState extends State<TactileIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final br = widget.borderRadius ?? BorderRadius.circular(widget.size / 2);
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: widget.size,
        height: widget.size,
        transform: Matrix4.translationValues(0, _isPressed ? 6 : 0, 0),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: br,
          border: widget.border,
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: widget.shadowColor,
                    offset: const Offset(0, 6),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}
