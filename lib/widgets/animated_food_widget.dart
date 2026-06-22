import 'package:flutter/material.dart';
import 'dart:math' as math;

enum FoodType { dimsum, dimsumFrozen, dimsumSosis, bakso, tahuBakso, sempol, pisangGoreng, tahuGoreng, tempeGoreng, bakwan, baksoGoreng, tahuBaksoGoreng, generic }

FoodType getFoodType(String name) {
  final n = name.toLowerCase();
  if (n.contains('pisang')) return FoodType.pisangGoreng;
  if (n.contains('bakwan')) return FoodType.bakwan;
  if (n.contains('tahu bakso goreng')) return FoodType.tahuBaksoGoreng;
  if (n.contains('bakso goreng')) return FoodType.baksoGoreng;
  if (n.contains('tahu goreng')) return FoodType.tahuGoreng;
  if (n.contains('tempe')) return FoodType.tempeGoreng;
  if (n.contains('frozen')) return FoodType.dimsumFrozen;
  if (n.contains('sosis')) return FoodType.dimsumSosis;
  if (n.contains('dimsum')) return FoodType.dimsum;
  if (n.contains('bakso crispy') || n.contains('crispy')) return FoodType.bakso;
  if (n.contains('tahu bakso')) return FoodType.tahuBakso;
  if (n.contains('sempol')) return FoodType.sempol;
  return FoodType.generic;
}

bool get isGorengan => true;

class AnimatedFoodWidget extends StatefulWidget {
  final String productName;
  final double size;
  const AnimatedFoodWidget({super.key, required this.productName, this.size = 80});

  @override
  State<AnimatedFoodWidget> createState() => _AnimatedFoodWidgetState();
}

class _AnimatedFoodWidgetState extends State<AnimatedFoodWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _phase;
  late Animation<double> _sway;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _phase = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
    _sway = Tween<double>(begin: -0.03, end: 0.03)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Transform.rotate(
        angle: _sway.value,
        child: CustomPaint(
          size: Size(widget.size, widget.size * 1.1),
          painter: _FoodPainter(type: getFoodType(widget.productName), phase: _phase.value),
        ),
      ),
    );
  }
}

class _FoodPainter extends CustomPainter {
  final FoodType type;
  final double phase;
  _FoodPainter({required this.type, required this.phase});

  @override
  void paint(Canvas canvas, Size s) {
    switch (type) {
      case FoodType.pisangGoreng:   _paintPisangGoreng(canvas, s); break;
      case FoodType.tahuGoreng:     _paintTahuGoreng(canvas, s); break;
      case FoodType.tempeGoreng:    _paintTempeGoreng(canvas, s); break;
      case FoodType.bakwan:         _paintBakwan(canvas, s); break;
      case FoodType.baksoGoreng:    _paintBaksoGoreng(canvas, s); break;
      case FoodType.tahuBaksoGoreng:_paintTahuBaksoGoreng(canvas, s); break;
      case FoodType.dimsum:         _paintDimsum(canvas, s); break;
      case FoodType.dimsumFrozen:   _paintDimsumFrozen(canvas, s); break;
      case FoodType.dimsumSosis:    _paintDimsumSosis(canvas, s); break;
      case FoodType.bakso:          _paintBaksoCrispy(canvas, s); break;
      case FoodType.tahuBakso:      _paintTahuBakso(canvas, s); break;
      case FoodType.sempol:         _paintSempol(canvas, s); break;
      default:                      _paintGeneric(canvas, s); break;
    }
  }

  // ── HELPERS ──────────────────────────────────────────────────────────────

  void _drawSteam(Canvas canvas, double w, double startY, double cx, int count) {
    for (int i = 0; i < count; i++) {
      final xb = cx + (i - count / 2.0) * w * 0.22;
      final path = Path();
      for (double t = 0; t <= 1; t += 0.05) {
        final x = xb + math.sin(phase + i * 1.3 + t * math.pi * 2.5) * w * 0.06;
        final y = startY - t * w * 0.28;
        if (t == 0) path.moveTo(x, y); else path.lineTo(x, y);
      }
      canvas.drawPath(path, Paint()
        ..color = Colors.white.withValues(alpha: 0.45 - i * 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.04
        ..strokeCap = StrokeCap.round);
    }
  }

  void _drawOilShine(Canvas canvas, Offset pos, double r) {
    canvas.drawCircle(Offset(pos.dx - r * 0.3, pos.dy - r * 0.3), r * 0.22,
        Paint()..color = Colors.white.withValues(alpha: 0.45));
  }

  // ── 🍌 PISANG GORENG ─────────────────────────────────────────────────────
  void _paintPisangGoreng(Canvas canvas, Size s) {
    final w = s.width; final h = s.height;

    // Uap panas
    _drawSteam(canvas, w, h * 0.18, w * 0.5, 2);

    // Piring / daun pisang hijau
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.88), width: w * 0.92, height: h * 0.18),
      Paint()..color = const Color(0xFF388E3C),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.86), width: w * 0.76, height: h * 0.12),
      Paint()..color = const Color(0xFF66BB6A),
    );

    // 3 pisang goreng golden melengkung
    final pisangData = [
      [w * 0.22, h * 0.60, -0.35],
      [w * 0.50, h * 0.52, 0.0],
      [w * 0.78, h * 0.60, 0.35],
    ];
    for (final d in pisangData) {
      canvas.save();
      canvas.translate(d[0], d[1]);
      canvas.rotate(d[2]);
      // Badan pisang goreng (lonjong keemasan)
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: w * 0.28, height: w * 0.50),
        const Radius.circular(18),
      );
      canvas.drawRRect(rect, Paint()
        ..shader = LinearGradient(
          colors: const [Color(0xFFFFF176), Color(0xFFFF8F00)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ).createShader(Rect.fromCenter(center: Offset.zero, width: w * 0.28, height: w * 0.50)));
      // Tekstur goreng (garis coklat)
      for (int i = 0; i < 3; i++) {
        canvas.drawLine(
          Offset(-w * 0.08, -w * 0.10 + i * w * 0.10),
          Offset(w * 0.08, -w * 0.06 + i * w * 0.10),
          Paint()..color = const Color(0xFFE65100).withValues(alpha: 0.5)
            ..strokeWidth = w * 0.025..style = PaintingStyle.stroke..strokeCap = StrokeCap.round,
        );
      }
      // Shine
      canvas.drawOval(
        Rect.fromCenter(center: Offset(-w * 0.06, -w * 0.12), width: w * 0.08, height: w * 0.14),
        Paint()..color = Colors.white.withValues(alpha: 0.4),
      );
      canvas.restore();
    }
  }

  // ── 🟨 TAHU GORENG ───────────────────────────────────────────────────────
  void _paintTahuGoreng(Canvas canvas, Size s) {
    final w = s.width; final h = s.height;

    _drawSteam(canvas, w, h * 0.16, w * 0.5, 2);

    // Kertas minyak di bawah
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.04, h * 0.72, w * 0.92, h * 0.24), const Radius.circular(6)),
      Paint()..color = const Color(0xFFFFF9C4),
    );

    // 4 tahu goreng kuning keemasan
    final positions = [
      Offset(w * 0.26, h * 0.44), Offset(w * 0.72, h * 0.44),
      Offset(w * 0.26, h * 0.66), Offset(w * 0.72, h * 0.66),
    ];
    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final bobble = math.sin(phase + i * 0.8) * h * 0.008;
      // Bayangan
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(pos.dx + 2, pos.dy + bobble + 3), width: w * 0.32, height: w * 0.32),
          const Radius.circular(6)),
        Paint()..color = Colors.black.withValues(alpha: 0.12),
      );
      // Badan tahu
      final tahuRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(pos.dx, pos.dy + bobble), width: w * 0.32, height: w * 0.32),
        const Radius.circular(6),
      );
      canvas.drawRRect(tahuRect, Paint()
        ..shader = LinearGradient(
          colors: const [Color(0xFFFFF9C4), Color(0xFFFFB300)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ).createShader(Rect.fromCenter(center: Offset(pos.dx, pos.dy), width: w * 0.32, height: w * 0.32)));
      // Outline garing
      canvas.drawRRect(tahuRect, Paint()
        ..color = const Color(0xFFE65100).withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke..strokeWidth = 1.5);
      // Lubang tahu (pori-pori)
      for (int j = 0; j < 3; j++) {
        canvas.drawCircle(
          Offset(pos.dx - w * 0.06 + j * w * 0.06, pos.dy + bobble),
          w * 0.02, Paint()..color = const Color(0xFFE65100).withValues(alpha: 0.35),
        );
      }
      _drawOilShine(canvas, Offset(pos.dx, pos.dy + bobble), w * 0.14);
    }
  }

  // ── 🟫 TEMPE GORENG ──────────────────────────────────────────────────────
  void _paintTempeGoreng(Canvas canvas, Size s) {
    final w = s.width; final h = s.height;

    _drawSteam(canvas, w, h * 0.16, w * 0.5, 2);

    // Kertas minyak
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.04, h * 0.74, w * 0.92, h * 0.22), const Radius.circular(6)),
      Paint()..color = const Color(0xFFFFF9C4),
    );

    // 3 tempe goreng persegi panjang tipis
    final tempeData = [
      [w * 0.5, h * 0.37, 0.0],
      [w * 0.28, h * 0.57, -0.15],
      [w * 0.72, h * 0.57, 0.15],
    ];
    for (int i = 0; i < tempeData.length; i++) {
      final d = tempeData[i];
      final bobble = math.sin(phase + i * 1.1) * h * 0.007;
      canvas.save();
      canvas.translate(d[0], d[1] + bobble);
      canvas.rotate(d[2]);
      // Badan tempe (persegi panjang tipis)
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: w * 0.58, height: w * 0.22),
        const Radius.circular(5),
      );
      canvas.drawRRect(rect, Paint()
        ..shader = LinearGradient(
          colors: const [Color(0xFFBCAAA4), Color(0xFF6D4C41)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ).createShader(Rect.fromCenter(center: Offset.zero, width: w * 0.58, height: w * 0.22)));
      // Tekstur kedelai tempe (titik-titik)
      final rand = math.Random(i + 10);
      for (int j = 0; j < 10; j++) {
        final tx = (rand.nextDouble() - 0.5) * w * 0.48;
        final ty = (rand.nextDouble() - 0.5) * w * 0.14;
        canvas.drawCircle(Offset(tx, ty), w * 0.025,
            Paint()..color = const Color(0xFF4E342E).withValues(alpha: 0.7));
      }
      // Outline garing coklat
      canvas.drawRRect(rect, Paint()
        ..color = const Color(0xFF3E2723)..style = PaintingStyle.stroke..strokeWidth = 1.2);
      // Shine
      canvas.drawOval(
        Rect.fromCenter(center: Offset(-w * 0.15, -w * 0.05), width: w * 0.14, height: w * 0.06),
        Paint()..color = Colors.white.withValues(alpha: 0.35),
      );
      canvas.restore();
    }
  }

  // ── 🥦 BAKWAN ────────────────────────────────────────────────────────────
  void _paintBakwan(Canvas canvas, Size s) {
    final w = s.width; final h = s.height;

    _drawSteam(canvas, w, h * 0.14, w * 0.5, 3);

    // Kertas minyak
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.04, h * 0.74, w * 0.92, h * 0.22), const Radius.circular(6)),
      Paint()..color = const Color(0xFFFFF9C4),
    );

    // 3 bakwan goreng (bulat gepeng tak beraturan)
    final bakwanPos = [
      Offset(w * 0.28, h * 0.50), Offset(w * 0.70, h * 0.46), Offset(w * 0.48, h * 0.68),
    ];
    final rand = math.Random(99);
    for (int i = 0; i < bakwanPos.length; i++) {
      final pos = bakwanPos[i];
      final bobble = math.sin(phase + i * 1.2) * h * 0.008;

      // Bentuk tak beraturan pakai path
      final path = Path();
      final pts = 8;
      for (int j = 0; j <= pts; j++) {
        final angle = j / pts * 2 * math.pi;
        final r = w * (0.18 + rand.nextDouble() * 0.07);
        final px = pos.dx + r * math.cos(angle);
        final py = pos.dy + bobble + r * math.sin(angle) * 0.75;
        if (j == 0) path.moveTo(px, py); else path.lineTo(px, py);
      }
      path.close();

      // Warna golden goreng
      canvas.drawPath(path, Paint()
        ..shader = RadialGradient(
          colors: const [Color(0xFFFFF176), Color(0xFFFF8F00)],
          center: const Alignment(-0.2, -0.3),
        ).createShader(Rect.fromCenter(center: pos, width: w * 0.44, height: w * 0.44)));

      // Sayuran terlihat (hijau & oranye)
      for (int j = 0; j < 5; j++) {
        final vx = pos.dx + (rand.nextDouble() - 0.5) * w * 0.24;
        final vy = pos.dy + bobble + (rand.nextDouble() - 0.5) * w * 0.16;
        canvas.drawOval(
          Rect.fromCenter(center: Offset(vx, vy), width: w * 0.06, height: w * 0.03),
          Paint()..color = j % 2 == 0
              ? const Color(0xFF66BB6A).withValues(alpha: 0.8)
              : const Color(0xFFFF8A65).withValues(alpha: 0.8),
        );
      }
      // Outline & shine
      canvas.drawPath(path, Paint()
        ..color = const Color(0xFFE65100).withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke..strokeWidth = 1.2);
      _drawOilShine(canvas, pos, w * 0.18);
    }
  }

  // ── 🍡 BAKSO GORENG ──────────────────────────────────────────────────────
  void _paintBaksoGoreng(Canvas canvas, Size s) {
    final w = s.width; final h = s.height;

    _drawSteam(canvas, w, h * 0.14, w * 0.5, 2);

    // Kertas minyak
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.04, h * 0.74, w * 0.92, h * 0.22), const Radius.circular(6)),
      Paint()..color = const Color(0xFFFFF9C4),
    );

    // 5 bakso goreng bulat coklat keemasan
    final positions = [
      Offset(w * 0.26, h * 0.42), Offset(w * 0.66, h * 0.42),
      Offset(w * 0.46, h * 0.56), Offset(w * 0.30, h * 0.68),
      Offset(w * 0.64, h * 0.68),
    ];
    final rand = math.Random(55);
    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final r = w * 0.13;
      final bobble = math.sin(phase + i * 0.9) * h * 0.007;

      // Shadow
      canvas.drawCircle(Offset(pos.dx + 1.5, pos.dy + bobble + 2.5), r,
          Paint()..color = Colors.black.withValues(alpha: 0.15));

      // Badan bakso goreng
      canvas.drawCircle(Offset(pos.dx, pos.dy + bobble), r, Paint()
        ..shader = RadialGradient(
          colors: const [Color(0xFFFFCC80), Color(0xFF8D4E00)],
          center: const Alignment(-0.3, -0.3),
        ).createShader(Rect.fromCircle(center: Offset(pos.dx, pos.dy + bobble), radius: r)));

      // Tekstur crispy (bintik-bintik gelap)
      for (int j = 0; j < 5; j++) {
        final angle = rand.nextDouble() * 2 * math.pi;
        final dist = rand.nextDouble() * r * 0.7;
        canvas.drawCircle(
          Offset(pos.dx + dist * math.cos(angle), pos.dy + bobble + dist * math.sin(angle)),
          r * 0.08,
          Paint()..color = const Color(0xFF4E2600).withValues(alpha: 0.55),
        );
      }
      _drawOilShine(canvas, Offset(pos.dx, pos.dy + bobble), r);
    }
  }

  // ── 🍢 TAHU BAKSO GORENG ─────────────────────────────────────────────────
  void _paintTahuBaksoGoreng(Canvas canvas, Size s) {
    final w = s.width; final h = s.height;

    _drawSteam(canvas, w, h * 0.16, w * 0.5, 2);

    // Kertas minyak
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.04, h * 0.74, w * 0.92, h * 0.22), const Radius.circular(6)),
      Paint()..color = const Color(0xFFFFF9C4),
    );

    // 4 tahu bakso goreng — segi empat dengan isian merah di tengah
    final positions = [
      Offset(w * 0.27, h * 0.43), Offset(w * 0.70, h * 0.43),
      Offset(w * 0.27, h * 0.66), Offset(w * 0.70, h * 0.66),
    ];
    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final bobble = math.sin(phase + i * 0.9) * h * 0.008;

      // Shadow
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(pos.dx + 2, pos.dy + bobble + 2), width: w * 0.34, height: w * 0.34),
          const Radius.circular(6)),
        Paint()..color = Colors.black.withValues(alpha: 0.12),
      );

      // Badan tahu goreng keemasan
      final tahuRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(pos.dx, pos.dy + bobble), width: w * 0.34, height: w * 0.34),
        const Radius.circular(6),
      );
      canvas.drawRRect(tahuRect, Paint()
        ..shader = LinearGradient(
          colors: const [Color(0xFFFFF176), Color(0xFFFF6F00)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ).createShader(Rect.fromCenter(center: Offset(pos.dx, pos.dy), width: w * 0.34, height: w * 0.34)));

      // Isian bakso merah/merah muda di tengah
      canvas.drawCircle(Offset(pos.dx, pos.dy + bobble), w * 0.07,
          Paint()..color = const Color(0xFFEF5350));
      canvas.drawCircle(Offset(pos.dx, pos.dy + bobble), w * 0.04,
          Paint()..color = const Color(0xFFB71C1C));

      // Outline garing
      canvas.drawRRect(tahuRect, Paint()
        ..color = const Color(0xFFBF360C).withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke..strokeWidth = 1.5);

      _drawOilShine(canvas, Offset(pos.dx, pos.dy + bobble), w * 0.15);
    }
  }

  // ── DIMSUM AYAM ──────────────────────────────────────────────────────────
  void _paintDimsum(Canvas canvas, Size s) {
    final w = s.width; final h = s.height;
    _drawSteam(canvas, w, h * 0.22, w * 0.5, 3);
    // Kukusan bambu
    canvas.drawRRect(
      RRect.fromRectAndCorners(Rect.fromLTRB(w * 0.05, h * 0.38, w * 0.95, h * 0.93),
        topLeft: const Radius.circular(8), topRight: const Radius.circular(8),
        bottomLeft: const Radius.circular(16), bottomRight: const Radius.circular(16)),
      Paint()..color = const Color(0xFF8D6E63),
    );
    // Garis bambu
    for (int i = 1; i <= 3; i++) {
      canvas.drawLine(Offset(w * 0.05, h * (0.38 + i * 0.13)), Offset(w * 0.95, h * (0.38 + i * 0.13)),
          Paint()..color = const Color(0xFF6D4C41)..style = PaintingStyle.stroke..strokeWidth = w * 0.025);
    }
    // Isi dimsum
    for (final pos in [
      Offset(w * 0.28, h * 0.52), Offset(w * 0.5, h * 0.48), Offset(w * 0.72, h * 0.52),
      Offset(w * 0.39, h * 0.64), Offset(w * 0.61, h * 0.64),
    ]) {
      canvas.drawCircle(pos, w * 0.11, Paint()..color = const Color(0xFFFFF8E1));
      canvas.drawCircle(Offset(pos.dx, pos.dy - w * 0.03), w * 0.05, Paint()..color = const Color(0xFFEF9A9A));
    }
    // Tutup kukusan
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.02, h * 0.33, w * 0.96, h * 0.09), const Radius.circular(6)),
      Paint()..color = const Color(0xFFA1887F),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.38, h * 0.25, w * 0.24, h * 0.10), const Radius.circular(8)),
      Paint()..color = const Color(0xFF795548),
    );
  }

  // ── DIMSUM FROZEN ─────────────────────────────────────────────────────────
  void _paintDimsumFrozen(Canvas canvas, Size s) {
    final w = s.width; final h = s.height;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.04, h * 0.25, w * 0.92, h * 0.70), const Radius.circular(10)),
      Paint()..color = const Color(0xFFF5F5F5),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.04, h * 0.25, w * 0.92, h * 0.70), const Radius.circular(10)),
      Paint()..color = const Color(0xFFBDBDBD)..style = PaintingStyle.stroke..strokeWidth = 1.5,
    );
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 4; col++) {
        final cx = w * (0.18 + col * 0.21);
        final cy = h * (0.40 + row * 0.17);
        canvas.drawCircle(Offset(cx, cy), w * 0.09, Paint()..color = const Color(0xFFFFF8E1));
        canvas.drawCircle(Offset(cx, cy - w * 0.025), w * 0.04, Paint()..color = const Color(0xFFEF9A9A));
      }
    }
    // Label 15k
    canvas.drawCircle(Offset(w * 0.8, h * 0.18), w * 0.18, Paint()..color = const Color(0xFF37474F));
    final tp = TextPainter(
      text: const TextSpan(text: '15k', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(w * 0.8 - tp.width / 2, h * 0.18 - tp.height / 2));
  }

  // ── DIMSUM SOSIS ──────────────────────────────────────────────────────────
  void _paintDimsumSosis(Canvas canvas, Size s) {
    final w = s.width; final h = s.height;
    _drawSteam(canvas, w, h * 0.12, w * 0.45, 2);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.85), width: w * 0.88, height: h * 0.22),
        Paint()..color = const Color(0xFFBCAAA4));
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.82), width: w * 0.78, height: h * 0.16),
        Paint()..color = const Color(0xFFD7CCC8));
    for (final pos in [
      Offset(w * 0.28, h * 0.58), Offset(w * 0.5, h * 0.50),
      Offset(w * 0.72, h * 0.58), Offset(w * 0.38, h * 0.70), Offset(w * 0.62, h * 0.70),
    ]) {
      canvas.drawCircle(pos, w * 0.13, Paint()..color = const Color(0xFFFFF8E1));
      canvas.drawCircle(pos, w * 0.06, Paint()..color = const Color(0xFFE53935));
    }
    // Botol saus
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.74, h * 0.30, w * 0.14, h * 0.30), const Radius.circular(6)),
      Paint()..color = const Color(0xFFE53935),
    );
  }

  // ── BAKSO CRISPY ──────────────────────────────────────────────────────────
  void _paintBaksoCrispy(Canvas canvas, Size s) {
    final w = s.width; final h = s.height;
    _drawSteam(canvas, w, h * 0.1, w * 0.5, 2);
    final bowlPath = Path()
      ..moveTo(w * 0.08, h * 0.55)
      ..quadraticBezierTo(w * 0.05, h * 0.85, w * 0.5, h * 0.95)
      ..quadraticBezierTo(w * 0.95, h * 0.85, w * 0.92, h * 0.55)
      ..close();
    canvas.drawPath(bowlPath, Paint()..color = const Color(0xFF1565C0));
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.55), width: w * 0.84, height: h * 0.14),
        Paint()..color = const Color(0xFF1976D2));
    final rand = math.Random(7);
    for (final pos in [
      Offset(w * 0.28, h * 0.68), Offset(w * 0.5, h * 0.62), Offset(w * 0.72, h * 0.68),
      Offset(w * 0.38, h * 0.52), Offset(w * 0.62, h * 0.52), Offset(w * 0.5, h * 0.42),
    ]) {
      final r = w * (0.11 + rand.nextDouble() * 0.02);
      canvas.drawCircle(pos, r, Paint()
        ..shader = RadialGradient(
          colors: const [Color(0xFFFFF176), Color(0xFFFF8F00)],
          center: const Alignment(-0.3, -0.3),
        ).createShader(Rect.fromCircle(center: pos, radius: r)));
      _drawOilShine(canvas, pos, r);
    }
  }

  // ── TAHU BAKSO (non-goreng) ───────────────────────────────────────────────
  void _paintTahuBakso(Canvas canvas, Size s) {
    final w = s.width; final h = s.height;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.04, h * 0.72, w * 0.92, h * 0.24), const Radius.circular(12)),
      Paint()..color = const Color(0xFF795548),
    );
    final tahuColors = [
      const Color(0xFFFFCDD2), const Color(0xFFF8BBD0), const Color(0xFFE1BEE7),
      const Color(0xFFBBDEFB), const Color(0xFFC8E6C9), const Color(0xFFFFECB3),
    ];
    for (int i = 0; i < 5; i++) {
      final pos = [
        Offset(w * 0.2, h * 0.42), Offset(w * 0.5, h * 0.38), Offset(w * 0.78, h * 0.42),
        Offset(w * 0.32, h * 0.62), Offset(w * 0.68, h * 0.62),
      ][i];
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: pos, width: w * 0.26, height: w * 0.26), const Radius.circular(5)),
        Paint()..color = tahuColors[i % tahuColors.length],
      );
      canvas.drawCircle(pos, w * 0.06, Paint()..color = tahuColors[(i + 2) % tahuColors.length]);
    }
  }

  // ── SEMPOL AYAM ───────────────────────────────────────────────────────────
  void _paintSempol(Canvas canvas, Size s) {
    final w = s.width; final h = s.height;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.05, h * 0.62, w * 0.9, h * 0.35), const Radius.circular(10)),
      Paint()..color = const Color(0xFFECEFF1),
    );
    for (int i = 0; i < 4; i++) {
      final sx = w * (0.22 + i * 0.18);
      canvas.drawLine(Offset(sx, h * 0.15), Offset(sx, h * 0.90),
          Paint()..color = const Color(0xFFA1887F)..strokeWidth = w * 0.025..strokeCap = StrokeCap.round);
      for (int j = 0; j < 3; j++) {
        final cy = h * (0.32 + j * 0.18) + math.sin(phase + i * 0.7 + j * 1.2) * h * 0.008;
        canvas.drawCircle(Offset(sx, cy), w * 0.09, Paint()
          ..shader = RadialGradient(
            colors: const [Color(0xFFFFF9C4), Color(0xFFFFCC02)],
            center: const Alignment(-0.3, -0.3),
          ).createShader(Rect.fromCircle(center: Offset(sx, cy), radius: w * 0.09)));
        _drawOilShine(canvas, Offset(sx, cy), w * 0.09);
      }
    }
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.84, h * 0.50), width: w * 0.22, height: w * 0.18),
        Paint()..color = const Color(0xFFEF9A9A));
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.84, h * 0.50), width: w * 0.16, height: w * 0.12),
        Paint()..color = const Color(0xFFE53935));
  }

  void _paintGeneric(Canvas canvas, Size s) {
    canvas.drawCircle(Offset(s.width * 0.5, s.height * 0.55), s.width * 0.35,
        Paint()..color = const Color(0xFFFFF8E1));
  }

  @override
  bool shouldRepaint(_FoodPainter old) => old.phase != phase;
}
