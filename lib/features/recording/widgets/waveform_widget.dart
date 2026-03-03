// ============================================================
// SECTION 4: waveform_widget.dart
// lib/features/recording/widgets/waveform_widget.dart
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';

/// Microphone icon that closely matches the reference image:
///  • Light-blue gradient capsule with a white gloss strip
///  • Dark-grey U-shaped stand + horizontal base bar
///  • Two teal wave arcs on each side (inner bright, outer faded)
///  • Arcs pulse when [isAnimating] is true
class MicrophoneIcon extends StatefulWidget {
  final bool isAnimating;
  const MicrophoneIcon({super.key, required this.isAnimating});

  @override
  State<MicrophoneIcon> createState() => _MicrophoneIconState();
}

class _MicrophoneIconState extends State<MicrophoneIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Wave arcs (behind mic body) ───────────────────
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, __) => CustomPaint(
              size: const Size(160, 160),
              painter: _WavePainter(
                scale: widget.isAnimating ? _pulse.value : 1.0,
              ),
            ),
          ),
          // ── Mic body (on top) ─────────────────────────────
          const _MicBody(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Mic body
// ─────────────────────────────────────────────────────────────
class _MicBody extends StatelessWidget {
  const _MicBody();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      height: 110,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Capsule ───────────────────────────────────────
          _Capsule(),
          const SizedBox(height: 4),
          // ── U-shaped stand ────────────────────────────────
          CustomPaint(
            size: const Size(54, 22),
            painter: _StandPainter(),
          ),
          const SizedBox(height: 1),
          // ── Horizontal base bar ───────────────────────────
          Container(
            width: 32,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFF5C6672),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Capsule widget ────────────────────────────────────────────
class _Capsule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 62,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // Light blue → slightly darker blue (matches reference)
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD0E8F8), // very light blue top
            Color(0xFF9EC4E0), // medium blue bottom
          ],
        ),
        // Subtle shadow to give depth
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7AAECF).withOpacity(0.35),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // White gloss strip on the left side
          Positioned(
            left: 9,
            top: 10,
            bottom: 10,
            child: Container(
              width: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.75),
                    Colors.white.withOpacity(0.20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// U-shaped stand painter
// ─────────────────────────────────────────────────────────────
class _StandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5C6672)
      ..strokeWidth = 3.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Smooth U arc: starts top-left, curves down to bottom-center,
    // then curves back up to top-right — mirrors reference image
    final path = Path()
      ..moveTo(size.width * 0.12, 0)
      ..cubicTo(
        size.width * 0.12, size.height * 1.1,  // left control
        size.width * 0.88, size.height * 1.1,  // right control
        size.width * 0.88, 0,                  // end point
      );

    canvas.drawPath(path, paint);

    // Short vertical stem from bottom of arc down to the base bar
    canvas.drawLine(
      Offset(size.width / 2, size.height * 0.95),
      Offset(size.width / 2, size.height + 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(_StandPainter old) => false;
}

// ─────────────────────────────────────────────────────────────
// Wave arc painter
// ─────────────────────────────────────────────────────────────
class _WavePainter extends CustomPainter {
  final double scale;
  const _WavePainter({required this.scale});

  // Arc sweep ≈ 120° so they look like the reference (not full circles)
  static const double _sweep = pi * 0.68;

  // Vertical offset from centre — arcs are centred on the capsule mid-point
  static const double _vOffset = -6.0;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + _vOffset;
    final center = Offset(cx, cy);

    // Two rings per side: inner (brighter) and outer (faded)
    // radius, opacity, strokeWidth
    final rings = [
      (45.0 * scale, 1.00, 3.0),
      (69.0 * scale, 0.50, 2.4),
      (89.0 * scale, 0.25, 2.0),
    ];

    for (final (radius, opacity, strokeW) in rings) {
      final paint = Paint()
        ..color = const Color(0xFF18D4E2).withOpacity(opacity)
        ..strokeWidth = strokeW
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final rect = Rect.fromCircle(center: center, radius: radius);

      // Right arc — starts just above centre-right, sweeps downward
      canvas.drawArc(rect, -pi * 0.34, _sweep, false, paint);

      // Left arc — mirrored (start angle flipped)
      canvas.drawArc(rect, pi - (-pi * 0.34) - _sweep, _sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.scale != scale;
}