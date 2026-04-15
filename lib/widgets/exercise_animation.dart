import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/exercise_library.dart';
import '../theme/app_colors.dart';

/// Animated exercise demonstration widget.
/// Shows a clean, looping illustration of the movement.
class ExerciseAnimation extends StatefulWidget {
  final ExerciseType type;
  final Color color;
  final double size;

  const ExerciseAnimation({
    super.key,
    required this.type,
    required this.color,
    this.size = 200,
  });

  @override
  State<ExerciseAnimation> createState() => _ExerciseAnimationState();
}

class _ExerciseAnimationState extends State<ExerciseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _anim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _getPainter(widget.type, _anim.value, widget.color),
      ),
    );
  }

  CustomPainter _getPainter(ExerciseType type, double t, Color color) {
    switch (type) {
      case ExerciseType.pushup:
        return _PushupPainter(t: t, color: color);
      case ExerciseType.squat:
        return _SquatPainter(t: t, color: color);
      case ExerciseType.plank:
        return _PlankPainter(t: t, color: color);
      case ExerciseType.jumpingJack:
        return _JumpingJackPainter(t: t, color: color);
      case ExerciseType.lunge:
        return _LungePainter(t: t, color: color);
      case ExerciseType.crunch:
        return _CrunchPainter(t: t, color: color);
      case ExerciseType.burpee:
        return _BurpeePainter(t: t, color: color);
      default:
        return _GenericPainter(t: t, color: color);
    }
  }
}

// ── Shared Drawing Helpers ───────────────────────────────��────────────────────

Paint _bodyPaint(Color color, {double strokeWidth = 10, bool fill = false}) =>
    Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke;

void _drawHead(Canvas c, Offset center, double radius, Color color) {
  c.drawCircle(center, radius, _bodyPaint(color, fill: true));
}

void _drawLine(Canvas c, Offset a, Offset b, Color color,
    {double sw = 9}) =>
    c.drawLine(a, b, _bodyPaint(color, strokeWidth: sw));

// ── PUSHUP ───────────────────────────���────────────────────────────────────────

class _PushupPainter extends CustomPainter {
  final double t; // 0 = up, 1 = down
  final Color color;
  _PushupPainter({required this.t, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final fade = color.withAlpha(30);

    // Ground line
    canvas.drawLine(
      Offset(w * 0.05, h * 0.72),
      Offset(w * 0.95, h * 0.72),
      _bodyPaint(AppColors.outlineVariant.withAlpha(100), strokeWidth: 3),
    );

    // Body height: up = h*0.45, down = h*0.62
    final bodyY = h * 0.45 + t * h * 0.17;
    const bodyStartX = 0.25;
    const bodyEndX = 0.78;

    // Body rectangle (torso + legs)
    final bodyPath = Path()
      ..moveTo(w * bodyStartX, bodyY - 8)
      ..lineTo(w * bodyEndX, bodyY - 8)
      ..lineTo(w * bodyEndX, bodyY + 8)
      ..lineTo(w * bodyStartX, bodyY + 8)
      ..close();
    canvas.drawPath(bodyPath, _bodyPaint(color, fill: true));

    // Head
    _drawHead(canvas, Offset(w * 0.15, bodyY), 14, color);

    // Left arm (near head)
    final armTopY = bodyY;
    final handY = h * 0.70;
    // Arm angle changes with t
    final elbowX = w * (0.22 + t * 0.05);
    final elbowY = bodyY + (h * 0.70 - bodyY) * (0.4 + t * 0.35);
    _drawLine(canvas, Offset(w * 0.22, armTopY), Offset(elbowX, elbowY), color);
    _drawLine(canvas, Offset(elbowX, elbowY), Offset(w * 0.20, handY), color);

    // Right arm (near feet)
    final armR_topY = bodyY;
    final elbowRX = w * (0.70 + t * 0.04);
    final elbowRY = bodyY + (h * 0.70 - bodyY) * (0.4 + t * 0.35);
    _drawLine(canvas, Offset(w * 0.72, armR_topY), Offset(elbowRX, elbowRY), color);
    _drawLine(canvas, Offset(elbowRX, elbowRY), Offset(w * 0.73, handY), color);

    // Feet
    _drawLine(canvas, Offset(w * bodyEndX, bodyY),
        Offset(w * bodyEndX, h * 0.70), color);

    // Direction arrow
    final arrowOpacity = t < 0.3 ? t / 0.3 : (t > 0.7 ? (1 - t) / 0.3 : 1.0);
    if (arrowOpacity > 0.05) {
      final arrowPaint = Paint()
        ..color = color.withAlpha((180 * arrowOpacity).toInt())
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      final arrowDir = t < 0.5 ? 1.0 : -1.0; // down or up
      final arrowX = w * 0.92;
      final arrowMidY = bodyY + 10;
      canvas.drawLine(
          Offset(arrowX, arrowMidY - 16),
          Offset(arrowX, arrowMidY + 16),
          arrowPaint);
      canvas.drawLine(
          Offset(arrowX, arrowMidY + arrowDir * 16),
          Offset(arrowX - 8, arrowMidY + arrowDir * 8),
          arrowPaint);
      canvas.drawLine(
          Offset(arrowX, arrowMidY + arrowDir * 16),
          Offset(arrowX + 8, arrowMidY + arrowDir * 8),
          arrowPaint);
    }
  }

  @override
  bool shouldRepaint(_PushupPainter old) => old.t != t;
}

// ── SQUAT ─────────────────────────────────────────────────────────────���───────

class _SquatPainter extends CustomPainter {
  final double t;
  final Color color;
  _SquatPainter({required this.t, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Ground line
    canvas.drawLine(
      Offset(w * 0.15, h * 0.85),
      Offset(w * 0.85, h * 0.85),
      _bodyPaint(AppColors.outlineVariant.withAlpha(100), strokeWidth: 3),
    );

    // Head: top = h*0.12, bottom (squat) = h*0.28
    final headY = h * 0.12 + t * h * 0.16;
    _drawHead(canvas, Offset(w * 0.5, headY), 16, color);

    // Torso
    final torsoTopY = headY + 16;
    final torsoBottomY = torsoTopY + h * 0.18;
    _drawLine(canvas, Offset(w * 0.5, torsoTopY),
        Offset(w * 0.5, torsoBottomY), color, sw: 10);

    // Arms: extend forward as squatting
    final armExtend = t * 0.15;
    _drawLine(canvas, Offset(w * 0.5, torsoTopY + 10),
        Offset(w * (0.5 - 0.15 - armExtend), torsoTopY + 10 + t * h * 0.04),
        color);
    _drawLine(canvas, Offset(w * 0.5, torsoTopY + 10),
        Offset(w * (0.5 + 0.15 + armExtend), torsoTopY + 10 + t * h * 0.04),
        color);

    // Hip joint
    final hipY = torsoBottomY;
    final hipLeft = Offset(w * 0.42, hipY);
    final hipRight = Offset(w * 0.58, hipY);

    // Knee: spread out as squatting
    final kneeSpread = t * w * 0.08;
    final kneeY = hipY + h * 0.12 + t * h * 0.1;
    final kneeLeft = Offset(w * 0.35 - kneeSpread, kneeY);
    final kneeRight = Offset(w * 0.65 + kneeSpread, kneeY);

    // Ankle/foot: on ground
    final ankleLeft = Offset(w * 0.32, h * 0.85);
    final ankleRight = Offset(w * 0.68, h * 0.85);

    _drawLine(canvas, hipLeft, kneeLeft, color);
    _drawLine(canvas, hipRight, kneeRight, color);
    _drawLine(canvas, kneeLeft, ankleLeft, color);
    _drawLine(canvas, kneeRight, ankleRight, color);
  }

  @override
  bool shouldRepaint(_SquatPainter old) => old.t != t;
}

// ── PLANK ─────────────────────────────────────────────────────────────────────

class _PlankPainter extends CustomPainter {
  final double t;
  final Color color;
  _PlankPainter({required this.t, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawLine(
      Offset(w * 0.05, h * 0.70),
      Offset(w * 0.95, h * 0.70),
      _bodyPaint(AppColors.outlineVariant.withAlpha(100), strokeWidth: 3),
    );

    // Slight hip oscillation to show "holding"
    final hipDip = math.sin(t * math.pi) * 4;
    final bodyY = h * 0.48 + hipDip;

    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.22, bodyY - 7, w * 0.55, 14),
        const Radius.circular(7),
      ),
      _bodyPaint(color, fill: true),
    );

    // Head
    _drawHead(canvas, Offset(w * 0.16, bodyY), 13, color);

    // Forearms (planted)
    _drawLine(canvas, Offset(w * 0.26, bodyY),
        Offset(w * 0.28, h * 0.70), color, sw: 8);
    _drawLine(canvas, Offset(w * 0.60, bodyY),
        Offset(w * 0.62, h * 0.70), color, sw: 8);

    // Feet / toes
    _drawLine(canvas, Offset(w * 0.77, bodyY),
        Offset(w * 0.77, h * 0.70), color, sw: 8);

    // Breathing indicator dots
    final breathScale = 0.7 + t * 0.3;
    final breathPaint = Paint()
      ..color = color.withAlpha((80 * breathScale).toInt())
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.85, h * 0.35), 6 * breathScale, breathPaint);
    canvas.drawCircle(Offset(w * 0.85, h * 0.48), 4 * breathScale, breathPaint);
  }

  @override
  bool shouldRepaint(_PlankPainter old) => old.t != t;
}

// ── JUMPING JACK ──────────────────────────────────────────────────────────────

class _JumpingJackPainter extends CustomPainter {
  final double t;
  final Color color;
  _JumpingJackPainter({required this.t, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawLine(
      Offset(w * 0.05, h * 0.88),
      Offset(w * 0.95, h * 0.88),
      _bodyPaint(AppColors.outlineVariant.withAlpha(100), strokeWidth: 3),
    );

    // Head: slight jump
    final jumpH = math.sin(t * math.pi) * h * 0.04;
    final headY = h * 0.14 - jumpH;
    _drawHead(canvas, Offset(w * 0.5, headY), 15, color);

    // Torso
    _drawLine(canvas, Offset(w * 0.5, headY + 15),
        Offset(w * 0.5, headY + h * 0.22), color, sw: 9);

    // Arms: t=0 down, t=1 up
    final armY = headY + h * 0.08;
    final armEndX = w * (0.5 - 0.15 - t * 0.18);
    final armEndY = armY + h * (0.08 - t * 0.14);
    _drawLine(canvas, Offset(w * 0.5, armY),
        Offset(armEndX, armEndY), color);
    _drawLine(canvas, Offset(w * 0.5, armY),
        Offset(w - armEndX, armEndY), color);

    // Legs: t=0 together, t=1 spread
    final legTopY = headY + h * 0.22;
    final legSpread = t * w * 0.22;
    final kneeSpread = t * w * 0.12;
    final kneeY = legTopY + h * 0.13;
    _drawLine(canvas, Offset(w * 0.5, legTopY),
        Offset(w * 0.5 - kneeSpread, kneeY), color);
    _drawLine(canvas, Offset(w * 0.5, legTopY),
        Offset(w * 0.5 + kneeSpread, kneeY), color);
    _drawLine(canvas, Offset(w * 0.5 - kneeSpread, kneeY),
        Offset(w * 0.5 - legSpread, h * 0.88), color);
    _drawLine(canvas, Offset(w * 0.5 + kneeSpread, kneeY),
        Offset(w * 0.5 + legSpread, h * 0.88), color);
  }

  @override
  bool shouldRepaint(_JumpingJackPainter old) => old.t != t;
}

// ── LUNGE ─────────────────────────────────────────────────────────────────────

class _LungePainter extends CustomPainter {
  final double t;
  final Color color;
  _LungePainter({required this.t, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawLine(
      Offset(w * 0.05, h * 0.88),
      Offset(w * 0.95, h * 0.88),
      _bodyPaint(AppColors.outlineVariant.withAlpha(100), strokeWidth: 3),
    );

    // Head: descends slightly
    final headY = h * 0.12 + t * h * 0.06;
    _drawHead(canvas, Offset(w * 0.42, headY), 14, color);

    // Torso stays upright
    _drawLine(canvas, Offset(w * 0.42, headY + 14),
        Offset(w * 0.42, headY + h * 0.22), color, sw: 9);

    // Arms on hips
    _drawLine(canvas, Offset(w * 0.42, headY + h * 0.07),
        Offset(w * 0.30, headY + h * 0.15), color, sw: 8);
    _drawLine(canvas, Offset(w * 0.42, headY + h * 0.07),
        Offset(w * 0.54, headY + h * 0.15), color, sw: 8);

    final hipY = headY + h * 0.22;

    // Front leg (right): steps forward
    final frontKneeX = w * 0.6;
    final frontKneeY = hipY + h * 0.15;
    final frontAnkleX = w * 0.64;
    _drawLine(canvas, Offset(w * 0.44, hipY),
        Offset(frontKneeX, frontKneeY), color);
    _drawLine(canvas, Offset(frontKneeX, frontKneeY),
        Offset(frontAnkleX, h * 0.88), color);

    // Back leg: knee drops
    final backKneeX = w * 0.32;
    final backKneeY = hipY + h * 0.14 + t * h * 0.08;
    final backAnkleX = w * 0.25;
    _drawLine(canvas, Offset(w * 0.40, hipY),
        Offset(backKneeX, backKneeY), color);
    _drawLine(canvas, Offset(backKneeX, backKneeY),
        Offset(backAnkleX, h * 0.88), color);

    // Back knee dot (near ground at t=1)
    if (t > 0.5) {
      final kneeToFloor = (t - 0.5) / 0.5;
      canvas.drawCircle(
        Offset(backKneeX, backKneeY),
        6,
        Paint()..color = color.withAlpha((200 * kneeToFloor).toInt()),
      );
    }
  }

  @override
  bool shouldRepaint(_LungePainter old) => old.t != t;
}

// ── CRUNCH ───────────────────────────────────────────────────────────────────���

class _CrunchPainter extends CustomPainter {
  final double t;
  final Color color;
  _CrunchPainter({required this.t, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Floor
    canvas.drawLine(
      Offset(w * 0.05, h * 0.72),
      Offset(w * 0.95, h * 0.72),
      _bodyPaint(AppColors.outlineVariant.withAlpha(100), strokeWidth: 3),
    );

    // Head curls up
    final headLiftY = t * h * 0.12;
    final headX = w * 0.22 + t * w * 0.04;
    _drawHead(canvas, Offset(headX, h * 0.55 - headLiftY), 14, color);

    // Upper torso curves
    final torsoEndX = w * 0.55;
    final torsoY = h * 0.66 - t * h * 0.03;
    _drawLine(canvas, Offset(headX + 12, h * 0.55 - headLiftY + 6),
        Offset(torsoEndX, torsoY), color, sw: 9);

    // Lower back / hips (flat on ground)
    _drawLine(canvas, Offset(torsoEndX, torsoY),
        Offset(w * 0.72, h * 0.70), color, sw: 9);

    // Arms behind head
    _drawLine(canvas, Offset(headX, h * 0.52 - headLiftY),
        Offset(w * 0.14, h * 0.50 - headLiftY * 0.5), color, sw: 7);
    _drawLine(canvas, Offset(headX, h * 0.52 - headLiftY),
        Offset(w * 0.30, h * 0.50 - headLiftY * 0.5), color, sw: 7);

    // Bent knees
    _drawLine(canvas, Offset(w * 0.72, h * 0.70),
        Offset(w * 0.80, h * 0.60), color);
    _drawLine(canvas, Offset(w * 0.80, h * 0.60),
        Offset(w * 0.88, h * 0.72), color);
  }

  @override
  bool shouldRepaint(_CrunchPainter old) => old.t != t;
}

// ── BURPEE ──────────────────────────────────────��─────────────────────────────

class _BurpeePainter extends CustomPainter {
  final double t;
  final Color color;
  _BurpeePainter({required this.t, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawLine(
      Offset(w * 0.05, h * 0.85),
      Offset(w * 0.95, h * 0.85),
      _bodyPaint(AppColors.outlineVariant.withAlpha(100), strokeWidth: 3),
    );

    // Phase: 0-0.5 = jump up (standing), 0.5-1 = plank (on ground)
    if (t < 0.5) {
      // Standing / jumping
      final jumpPhase = t / 0.5;
      final jumpH = math.sin(jumpPhase * math.pi) * h * 0.12;
      final headY = h * 0.16 - jumpH;
      _drawHead(canvas, Offset(w * 0.5, headY), 14, color);
      _drawLine(canvas, Offset(w * 0.5, headY + 14),
          Offset(w * 0.5, headY + h * 0.20), color, sw: 9);
      // Arms up
      final armAngle = jumpPhase * math.pi * 0.5;
      _drawLine(canvas, Offset(w * 0.5, headY + h * 0.07),
          Offset(w * 0.5 - math.cos(armAngle) * w * 0.18,
              headY + h * 0.07 - math.sin(armAngle) * h * 0.12),
          color);
      _drawLine(canvas, Offset(w * 0.5, headY + h * 0.07),
          Offset(w * 0.5 + math.cos(armAngle) * w * 0.18,
              headY + h * 0.07 - math.sin(armAngle) * h * 0.12),
          color);
      _drawLine(canvas, Offset(w * 0.5, headY + h * 0.20),
          Offset(w * 0.44, h * 0.85), color);
      _drawLine(canvas, Offset(w * 0.5, headY + h * 0.20),
          Offset(w * 0.56, h * 0.85), color);
    } else {
      // Plank position
      const bodyY = 0.50;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.20, h * bodyY - 7, w * 0.58, 14),
          const Radius.circular(7),
        ),
        _bodyPaint(color, fill: true),
      );
      _drawHead(canvas, Offset(w * 0.14, h * bodyY), 13, color);
      _drawLine(canvas, Offset(w * 0.25, h * bodyY),
          Offset(w * 0.24, h * 0.85), color, sw: 8);
      _drawLine(canvas, Offset(w * 0.60, h * bodyY),
          Offset(w * 0.61, h * 0.85), color, sw: 8);
      _drawLine(canvas, Offset(w * 0.78, h * bodyY),
          Offset(w * 0.79, h * 0.85), color, sw: 8);
    }
  }

  @override
  bool shouldRepaint(_BurpeePainter old) => old.t != t;
}

// ── GENERIC ──────────────────────────────────────────────────────────────────���

class _GenericPainter extends CustomPainter {
  final double t;
  final Color color;
  _GenericPainter({required this.t, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final scale = 1.0 + math.sin(t * math.pi) * 0.1;
    canvas.save();
    canvas.translate(w / 2, h / 2);
    canvas.scale(scale);
    canvas.translate(-w / 2, -h / 2);
    final paint = Paint()
      ..color = color.withAlpha(180)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.3, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_GenericPainter old) => old.t != t;
}
