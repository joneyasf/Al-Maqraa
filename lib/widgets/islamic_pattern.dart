import 'dart:math' as math;

import 'package:flutter/material.dart';

/// زخرفة هندسية هادئة (نجوم ثمانية) تُرسم خلف الشريط الافتتاحي والشاشة الأولى.
class IslamicPatternPainter extends CustomPainter {
  IslamicPatternPainter({required this.color, this.cell = 56});

  final Color color;
  final double cell;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;
    final r = cell * 0.36;
    var row = 0;
    for (double y = 0; y < size.height + cell; y += cell) {
      final shift = row.isOdd ? cell / 2 : 0.0;
      for (double x = -cell; x < size.width + cell; x += cell) {
        _star(canvas, Offset(x + shift, y), r, paint);
      }
      row++;
    }
  }

  void _star(Canvas canvas, Offset c, double r, Paint paint) {
    final path = Path();
    for (var k = 0; k < 2; k++) {
      final rot = k * math.pi / 4;
      for (var i = 0; i < 4; i++) {
        final a = rot + i * math.pi / 2 + math.pi / 4;
        final p = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant IslamicPatternPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.cell != cell;
}

/// فاصل زخرفي: خط ذهبي ونجمة في المنتصف.
class OrnamentDivider extends StatelessWidget {
  const OrnamentDivider({super.key, required this.color, this.width = 140});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 22,
      child: CustomPaint(painter: _DividerPainter(color)),
    );
  }
}

class _DividerPainter extends CustomPainter {
  _DividerPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = color.withValues(alpha: 0.75)
      ..strokeWidth = 1.2;
    final mid = size.width / 2;
    final y = size.height / 2;
    canvas.drawLine(Offset(0, y), Offset(mid - 14, y), line);
    canvas.drawLine(Offset(mid + 14, y), Offset(size.width, y), line);
    final star = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    for (var k = 0; k < 2; k++) {
      final rot = k * math.pi / 4;
      for (var i = 0; i < 4; i++) {
        final a = rot + i * math.pi / 2 + math.pi / 4;
        final p = Offset(mid + 8 * math.cos(a), y + 8 * math.sin(a));
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
    }
    canvas.drawPath(path, star);
  }

  @override
  bool shouldRepaint(covariant _DividerPainter oldDelegate) => oldDelegate.color != color;
}
