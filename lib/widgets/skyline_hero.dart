import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A fully vector-drawn, made-up city skyline — not modeled on any real
/// building — used as the home screen hero. Kept pale/light throughout so
/// the dark-text Ventrata logo in the app bar above it stays readable.
/// Deliberately hand-authored geometry (no randomness, no image asset, no
/// network) so it renders identically every run and never adds
/// latency/flakiness to Maestro flows.
class SkylineHero extends StatelessWidget {
  final double height;

  const SkylineHero({super.key, this.height = 260});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(painter: _SkylinePainter()),
    );
  }
}

class _SkylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFDF7F1), Color(0xFFFBE3E8), Color(0xFFF7C9A8)],
        stops: [0, 0.55, 1],
      ).createShader(rect);
    canvas.drawRect(rect, sky);

    _drawSunGlow(canvas, size);
    _drawBirds(canvas, size);
    _drawBuildingLayer(
      canvas,
      size,
      baseline: size.height * 0.62,
      heights: const [0.30, 0.42, 0.24, 0.50, 0.34, 0.20, 0.44],
      color: const Color(0xFF3B2A54).withValues(alpha: 0.12),
    );
    _drawBuildingLayer(
      canvas,
      size,
      baseline: size.height * 0.74,
      heights: const [0.20, 0.36, 0.55, 0.28, 0.46, 0.32, 0.60, 0.22],
      color: const Color(0xFF3B2A54).withValues(alpha: 0.20),
    );
    _drawFrontSkyline(canvas, size);
  }

  void _drawSunGlow(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.74, size.height * 0.34);
    for (final r in [70.0, 46.0, 26.0]) {
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..color = const Color(0xFFFFB13B).withValues(alpha: 0.12)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
      );
    }
    canvas.drawCircle(
      center,
      16,
      Paint()..color = const Color(0xFFFFD874).withValues(alpha: 0.95),
    );
  }

  void _drawBirds(Canvas canvas, Size size) {
    final positions = [
      Offset(size.width * 0.18, size.height * 0.20),
      Offset(size.width * 0.26, size.height * 0.14),
      Offset(size.width * 0.55, size.height * 0.16),
    ];
    final paint = Paint()
      ..color = const Color(0xFF3B2A54).withValues(alpha: 0.45)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (final p in positions) {
      final path = Path()
        ..moveTo(p.dx - 6, p.dy)
        ..quadraticBezierTo(p.dx - 2, p.dy - 4, p.dx, p.dy)
        ..quadraticBezierTo(p.dx + 2, p.dy - 4, p.dx + 6, p.dy);
      canvas.drawPath(path, paint);
    }
  }

  void _drawBuildingLayer(
    Canvas canvas,
    Size size, {
    required double baseline,
    required List<double> heights,
    required Color color,
    }) {
    final paint = Paint()..color = color;
    final slotWidth = size.width / heights.length;
    for (var i = 0; i < heights.length; i++) {
      final w = slotWidth * 0.72;
      final left = i * slotWidth + (slotWidth - w) / 2;
      final top = baseline - heights[i] * size.height;
      canvas.drawRect(Rect.fromLTRB(left, top, left + w, size.height), paint);
    }
  }

  void _drawFrontSkyline(Canvas canvas, Size size) {
    final baseline = size.height * 0.86;
    final heights = <double>[0.22, 0.34, 0.46, 0.30, 0.66, 0.38, 0.28, 0.42, 0.24];
    final darkPaint = Paint()..color = const Color(0xFF3B2A54);
    final windowPaint = Paint()
      ..color = const Color(0xFFFFE3A3).withValues(alpha: 0.9);

    final slotWidth = size.width / heights.length;
    const heroIndex = 4;

    for (var i = 0; i < heights.length; i++) {
      final w = slotWidth * 0.78;
      final left = i * slotWidth + (slotWidth - w) / 2;
      final buildingHeight = heights[i] * size.height;
      final top = baseline - buildingHeight;
      final rect = Rect.fromLTRB(left, top, left + w, size.height);
      canvas.drawRect(rect, darkPaint);

      if (i == heroIndex) {
        _drawHeroTopper(canvas, rect);
      }

      final cols = math.max(2, (w / 14).floor());
      final rows = math.max(2, (buildingHeight / 16).floor());
      for (var c = 0; c < cols; c++) {
        for (var r = 0; r < rows; r++) {
          if ((c + r * cols) % 3 == 0) continue;
          final wx = left + 5 + c * (w - 10) / cols;
          final wy = top + 8 + r * (buildingHeight - 12) / rows;
          canvas.drawRect(Rect.fromLTWH(wx, wy, 3.5, 5), windowPaint);
        }
      }
    }
  }

  /// A rounded halo-ring rooftop (deliberately not a spire) so the tallest
  /// building reads as its own invented silhouette.
  void _drawHeroTopper(Canvas canvas, Rect towerRect) {
    final center = Offset(towerRect.center.dx, towerRect.top);
    canvas.drawLine(
      center,
      Offset(center.dx, center.dy - 22),
      Paint()
        ..color = const Color(0xFF3B2A54)
        ..strokeWidth = 3,
    );
    canvas.drawCircle(
      Offset(center.dx, center.dy - 30),
      13,
      Paint()
        ..color = const Color(0xFFFFB13B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawCircle(
      Offset(center.dx, center.dy - 30),
      3,
      Paint()..color = const Color(0xFFFFB13B),
    );
  }

  @override
  bool shouldRepaint(covariant _SkylinePainter oldDelegate) => false;
}
