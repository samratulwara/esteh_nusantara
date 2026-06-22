import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Konfigurasi warna & tampilan per produk
class DrinkConfig {
  final Color liquidColor;
  final Color liquidColor2;
  final Color cupColor;
  final Color strawColor;
  final bool hasBubble;
  final bool hasIce;
  final bool hasFoam;
  final Color foamColor;
  final List<Color> toppingColors;
  final bool isHot; // gelas panas (tidak pakai sedotan, ada uap)

  const DrinkConfig({
    required this.liquidColor,
    required this.liquidColor2,
    this.cupColor = const Color(0xFFE0F2FE),
    this.strawColor = const Color(0xFFEF9A9A),
    this.hasBubble = false,
    this.hasIce = true,
    this.hasFoam = false,
    this.foamColor = Colors.white,
    this.toppingColors = const [],
    this.isHot = false,
  });
}

/// Mapping nama produk → DrinkConfig
DrinkConfig getDrinkConfig(String productName) {
  final name = productName.toLowerCase();

  if (name.contains('taro')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFCE93D8),
      liquidColor2: Color(0xFF9C27B0),
      strawColor: Color(0xFFBA68C8),
      hasBubble: true,
      toppingColors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
    );
  } else if (name.contains('red velvet')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFEF9A9A),
      liquidColor2: Color(0xFFC62828),
      strawColor: Color(0xFFE57373),
      hasFoam: true,
      foamColor: Color(0xFFFCE4EC),
    );
  } else if (name.contains('strawberry')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFF48FB1),
      liquidColor2: Color(0xFFE91E63),
      strawColor: Color(0xFFEC407A),
      hasBubble: true,
      toppingColors: [Color(0xFFC2185B), Color(0xFFE91E63)],
    );
  } else if (name.contains('mango') || name.contains('mangga')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFFFCC80),
      liquidColor2: Color(0xFFFF6F00),
      strawColor: Color(0xFFFFA726),
      toppingColors: [Color(0xFFFF8F00), Color(0xFFFFA000)],
    );
  } else if (name.contains('choco') || name.contains('coklat') || name.contains('chocolate')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFBCAAA4),
      liquidColor2: Color(0xFF4E342E),
      strawColor: Color(0xFF6D4C41),
      hasFoam: true,
      foamColor: Color(0xFFD7CCC8),
      toppingColors: [Color(0xFF3E2723), Color(0xFF4E342E)],
    );
  } else if (name.contains('green tea') || name.contains('greentea') || name.contains('matcha')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFA5D6A7),
      liquidColor2: Color(0xFF2E7D32),
      strawColor: Color(0xFF66BB6A),
      hasFoam: true,
      foamColor: Color(0xFFC8E6C9),
    );
  } else if (name.contains('lemon')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFFFF176),
      liquidColor2: Color(0xFFF9A825),
      strawColor: Color(0xFFFFEE58),
      hasIce: true,
    );
  } else if (name.contains('peach')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFFFCCBC),
      liquidColor2: Color(0xFFBF360C),
      strawColor: Color(0xFFFF7043),
    );
  } else if (name.contains('lychee') || name.contains('leci')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFF8BBD0),
      liquidColor2: Color(0xFFAD1457),
      strawColor: Color(0xFFEC407A),
      hasBubble: true,
      toppingColors: [Color(0xFF880E4F), Color(0xFFC2185B)],
    );
  } else if (name.contains('yakult')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFFFFDE7),
      liquidColor2: Color(0xFFF9A825),
      strawColor: Color(0xFFFFCA28),
    );
  } else if (name.contains('honeylime') || name.contains('honey')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFFFF59D),
      liquidColor2: Color(0xFFF57F17),
      strawColor: Color(0xFFFFD600),
    );
  } else if (name.contains('cocopandan') || name.contains('pandan')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFC8E6C9),
      liquidColor2: Color(0xFF1B5E20),
      strawColor: Color(0xFF66BB6A),
    );
  } else if (name.contains('jahe') || name.contains('sereh')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFFFE0B2),
      liquidColor2: Color(0xFFE65100),
      strawColor: Color(0xFFFF8F00),
    );
  } else if (name.contains('melon')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFB2DFDB),
      liquidColor2: Color(0xFF00695C),
      strawColor: Color(0xFF26A69A),
      hasBubble: true,
      toppingColors: [Color(0xFF004D40), Color(0xFF00695C)],
    );
  } else if (name.contains('cookies')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFD7CCC8),
      liquidColor2: Color(0xFF3E2723),
      strawColor: Color(0xFF795548),
      toppingColors: [Color(0xFF212121), Color(0xFF424242)],
    );
  } else if (name.contains('coffelatte') || name.contains('coffee')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFBCAAA4),
      liquidColor2: Color(0xFF3E2723),
      strawColor: Color(0xFF6D4C41),
      hasFoam: true,
      foamColor: Color(0xFFEFEBE9),
    );
  } else if (name.contains('milk') || name.contains('susu')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFFFF8E1),
      liquidColor2: Color(0xFFFF8F00),
      strawColor: Color(0xFFFFA000),
      hasFoam: true,
      foamColor: Colors.white,
    );
  } else if (name.contains('macchiato')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFFFCC80),
      liquidColor2: Color(0xFF4E342E),
      strawColor: Color(0xFF6D4C41),
      hasFoam: true,
      foamColor: Color(0xFFFFE0B2),
    );
  } else if (name.contains('bandrek')) {
    // Bandrek — merah kecoklatan hangat, gelas panas, ada uap + kayu manis
    return const DrinkConfig(
      liquidColor: Color(0xFFEF5350),   // merah terang di atas
      liquidColor2: Color(0xFF7F0000),  // merah gelap di bawah
      cupColor: Color(0xFFFFF3E0),
      strawColor: Color(0xFFBF360C),
      hasBubble: false,
      hasIce: false,
      hasFoam: false,
      isHot: true,
      toppingColors: [Color(0xFF3E2723), Color(0xFF6D4C41)], // kayu manis stik
    );
  } else if (name.contains('wedang uwuh') || name.contains('uwuh')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFEF5350),
      liquidColor2: Color(0xFF7B1FA2),
      cupColor: Color(0xFFFCE4EC),
      strawColor: Color(0xFFC62828),
      hasIce: false,
      isHot: true,
    );
  } else if (name.contains('wedang') || name.contains('jahe')) {
    return const DrinkConfig(
      liquidColor: Color(0xFFFFCC80),
      liquidColor2: Color(0xFFE65100),
      cupColor: Color(0xFFFFF8E1),
      strawColor: Color(0xFFFF8F00),
      hasIce: false,
      isHot: true,
    );
  } else {
    // Original / default tea
    return const DrinkConfig(
      liquidColor: Color(0xFFFFCC80),
      liquidColor2: Color(0xFF6D4C41),
      strawColor: Color(0xFFFF7043),
      hasIce: true,
    );
  }
}

class AnimatedDrinkWidget extends StatefulWidget {
  final String productName;
  final double size;

  const AnimatedDrinkWidget({
    super.key,
    required this.productName,
    this.size = 80,
  });

  @override
  State<AnimatedDrinkWidget> createState() => _AnimatedDrinkWidgetState();
}

class _AnimatedDrinkWidgetState extends State<AnimatedDrinkWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _wave;
  late Animation<double> _straw;
  late Animation<double> _bubble;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
    _wave = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
    _straw = Tween<double>(begin: -2, end: 2)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _bubble = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = getDrinkConfig(widget.productName);
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        size: Size(widget.size, widget.size * 1.3),
        painter: _DrinkPainter(
          config: config,
          wavePhase: _wave.value,
          strawSway: _straw.value,
          bubbleProgress: _bubble.value,
        ),
      ),
    );
  }
}

class _DrinkPainter extends CustomPainter {
  final DrinkConfig config;
  final double wavePhase;
  final double strawSway;
  final double bubbleProgress;

  _DrinkPainter({
    required this.config,
    required this.wavePhase,
    required this.strawSway,
    required this.bubbleProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    if (config.isHot) {
      _paintHotCup(canvas, w, h);
    } else {
      _paintColdCup(canvas, w, h);
    }
  }

  // ─── GELAS DINGIN (cup plastik + sedotan) ───────────────────────────────
  void _paintColdCup(Canvas canvas, double w, double h) {
    final cupLeft   = w * 0.12;
    final cupRight  = w * 0.88;
    final cupTop    = h * 0.18;
    final cupBottom = h * 0.95;
    final cupMidLeft  = w * 0.08;
    final cupMidRight = w * 0.92;

    final cupPath = Path()
      ..moveTo(cupLeft, cupTop)
      ..lineTo(cupMidLeft, h * 0.5)
      ..lineTo(w * 0.1, cupBottom)
      ..quadraticBezierTo(w * 0.5, cupBottom + h * 0.03, w * 0.9, cupBottom)
      ..lineTo(cupMidRight, h * 0.5)
      ..lineTo(cupRight, cupTop)
      ..close();

    canvas.drawPath(cupPath,
        Paint()..color = config.cupColor.withValues(alpha: 0.6)..style = PaintingStyle.fill);

    // Liquid
    final liquidTop = h * 0.28;
    final liquidPath = Path();
    for (double x = cupLeft; x <= cupRight; x += 1) {
      final p = (x - cupLeft) / (cupRight - cupLeft);
      final y = liquidTop + math.sin(wavePhase + p * 2 * math.pi) * (h * 0.018);
      if (x == cupLeft) liquidPath.moveTo(x, y);
      else liquidPath.lineTo(x, y);
    }
    liquidPath.lineTo(cupRight, cupBottom - 2);
    liquidPath.quadraticBezierTo(w * 0.5, cupBottom + h * 0.02, cupMidLeft + 2, cupBottom - 2);
    liquidPath.close();

    canvas.save();
    canvas.clipPath(cupPath);
    canvas.drawPath(
      liquidPath,
      Paint()
        ..shader = LinearGradient(
          colors: [config.liquidColor, config.liquidColor2],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, liquidTop, w, cupBottom - liquidTop))
        ..style = PaintingStyle.fill,
    );

    // Bubbles
    if (config.hasBubble) {
      final rand = math.Random(42);
      for (int i = 0; i < 8; i++) {
        final bx = cupLeft + rand.nextDouble() * (cupRight - cupLeft);
        final by = cupBottom - h * 0.05 - rand.nextDouble() * h * 0.25
            - bubbleProgress * h * 0.04 * (i % 3);
        final br = w * 0.055 + rand.nextDouble() * w * 0.03;
        final col = config.toppingColors.isNotEmpty
            ? config.toppingColors[i % config.toppingColors.length]
            : config.liquidColor2;
        canvas.drawCircle(Offset(bx, by), br, Paint()..color = col);
        canvas.drawCircle(Offset(bx - br * 0.3, by - br * 0.3), br * 0.3,
            Paint()..color = Colors.white.withValues(alpha: 0.25));
      }
    }

    // Ice
    if (config.hasIce) {
      final iceStroke = Paint()
        ..color = Colors.white.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;
      for (final pos in [
        Offset(w * 0.25, h * 0.55), Offset(w * 0.55, h * 0.5),
        Offset(w * 0.38, h * 0.7),  Offset(w * 0.65, h * 0.68),
      ]) {
        final rr = RRect.fromRectAndRadius(
          Rect.fromCenter(center: pos, width: w * 0.16, height: w * 0.14),
          const Radius.circular(3));
        canvas.drawRRect(rr, Paint()..color = Colors.white.withValues(alpha: 0.55));
        canvas.drawRRect(rr, iceStroke);
      }
    }

    // Foam
    if (config.hasFoam) {
      for (int i = 0; i < 6; i++) {
        final fx = cupLeft + (cupRight - cupLeft) * (i / 5.0);
        final fy = liquidTop + math.sin(wavePhase + i * 0.8) * (h * 0.012);
        canvas.drawCircle(Offset(fx, fy), w * 0.1,
            Paint()..color = config.foamColor..style = PaintingStyle.fill);
      }
    }

    canvas.restore();

    // Outline
    final outline = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(cupPath, outline);

    // Shine
    final shinePath = Path()
      ..moveTo(cupLeft + w * 0.06, cupTop + h * 0.02)
      ..lineTo(cupLeft + w * 0.18, cupTop + h * 0.02)
      ..lineTo(cupLeft + w * 0.15, h * 0.45)
      ..lineTo(cupLeft + w * 0.04, h * 0.45)
      ..close();
    canvas.save();
    canvas.clipPath(cupPath);
    canvas.drawPath(shinePath,
        Paint()..color = Colors.white.withValues(alpha: 0.25)..style = PaintingStyle.fill);
    canvas.restore();

    // Lid
    final lidRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cupLeft - w * 0.04, cupTop - h * 0.04,
          (cupRight - cupLeft) + w * 0.08, h * 0.07),
      const Radius.circular(6));
    canvas.drawRRect(lidRect,
        Paint()..color = Colors.white.withValues(alpha: 0.85)..style = PaintingStyle.fill);
    canvas.drawRRect(lidRect, outline);

    // Straw
    final sx = w * 0.62 + strawSway;
    canvas.drawLine(
      Offset(sx, h * 0.02), Offset(sx - strawSway * 0.5, h * 0.6),
      Paint()
        ..color = config.strawColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.09
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(sx - w * 0.025, h * 0.02),
      Offset(sx - w * 0.025 - strawSway * 0.5, h * 0.6),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.025
        ..strokeCap = StrokeCap.round,
    );
  }

  // ─── GELAS PANAS (cangkir keramik + uap mengepul) ───────────────────────
  void _paintHotCup(Canvas canvas, double w, double h) {
    // Uap mengepul di atas — animasikan dengan wavePhase
    _drawSteam(canvas, w, h);

    // Piring / alas cangkir
    final saucerPaint = Paint()
      ..color = const Color(0xFFD7CCC8)
      ..style = PaintingStyle.fill;
    final saucerPath = Path()
      ..addOval(Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.93),
          width: w * 0.85, height: h * 0.08));
    canvas.drawPath(saucerPath, saucerPaint);
    canvas.drawPath(
      saucerPath,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Badan cangkir — bulat dan gemuk
    final cupL = w * 0.1;
    final cupR = w * 0.9;
    final cupT = h * 0.40;
    final cupB = h * 0.90;

    final cupRect = RRect.fromRectAndCorners(
      Rect.fromLTRB(cupL, cupT, cupR, cupB),
      topLeft: const Radius.circular(10),
      topRight: const Radius.circular(10),
      bottomLeft: const Radius.circular(20),
      bottomRight: const Radius.circular(20),
    );

    // Body cangkir
    canvas.drawRRect(
      cupRect,
      Paint()
        ..color = const Color(0xFFF5F5F5)
        ..style = PaintingStyle.fill,
    );

    // Isi cairan
    final liquidTop = cupT + (cupB - cupT) * 0.18;
    final liquidPath = Path();
    for (double x = cupL + 2; x <= cupR - 2; x += 1) {
      final p = (x - cupL) / (cupR - cupL);
      final y = liquidTop + math.sin(wavePhase + p * 2 * math.pi) * (h * 0.015);
      if (x == cupL + 2) liquidPath.moveTo(x, y);
      else liquidPath.lineTo(x, y);
    }
    liquidPath.lineTo(cupR - 2, cupB - 8);
    liquidPath.quadraticBezierTo(w * 0.5, cupB, cupL + 2, cupB - 8);
    liquidPath.close();

    canvas.save();
    canvas.clipRRect(cupRect);
    canvas.drawPath(
      liquidPath,
      Paint()
        ..shader = LinearGradient(
          colors: [config.liquidColor, config.liquidColor2],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(cupL, liquidTop, cupR - cupL, cupB - liquidTop))
        ..style = PaintingStyle.fill,
    );

    // Kilap cairan
    canvas.drawPath(
      liquidPath,
      Paint()..color = Colors.white.withValues(alpha: 0.12)..style = PaintingStyle.fill,
    );

    // Rempah / topping (kayu manis stik untuk bandrek)
    if (config.toppingColors.isNotEmpty) {
      // Kayu manis stik pertama
      canvas.drawLine(
        Offset(w * 0.28, liquidTop + h * 0.03),
        Offset(w * 0.68, liquidTop + h * 0.13),
        Paint()
          ..color = config.toppingColors[0]
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.07
          ..strokeCap = StrokeCap.round,
      );
      // Kayu manis stik kedua (silang sedikit)
      if (config.toppingColors.length > 1) {
        canvas.drawLine(
          Offset(w * 0.36, liquidTop + h * 0.02),
          Offset(w * 0.62, liquidTop + h * 0.16),
          Paint()
            ..color = config.toppingColors[1]
            ..style = PaintingStyle.stroke
            ..strokeWidth = w * 0.045
            ..strokeCap = StrokeCap.round,
        );
      }
      // Tekstur kayu manis (garis highlight)
      canvas.drawLine(
        Offset(w * 0.30, liquidTop + h * 0.04),
        Offset(w * 0.66, liquidTop + h * 0.12),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.02
          ..strokeCap = StrokeCap.round,
      );
    }

    canvas.restore();

    // Outline cangkir
    canvas.drawRRect(
      cupRect,
      Paint()
        ..color = const Color(0xFFBCAAA4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Shine kiri
    final shinePath = Path()
      ..moveTo(cupL + w * 0.06, cupT + h * 0.03)
      ..lineTo(cupL + w * 0.14, cupT + h * 0.03)
      ..lineTo(cupL + w * 0.12, cupT + h * 0.28)
      ..lineTo(cupL + w * 0.04, cupT + h * 0.28)
      ..close();
    canvas.save();
    canvas.clipRRect(cupRect);
    canvas.drawPath(shinePath,
        Paint()..color = Colors.white.withValues(alpha: 0.3)..style = PaintingStyle.fill);
    canvas.restore();

    // Handle / telinga cangkir
    final handlePaint = Paint()
      ..color = const Color(0xFFEEEEEE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.10
      ..strokeCap = StrokeCap.round;
    final handlePath = Path()
      ..moveTo(cupR - w * 0.02, cupT + (cupB - cupT) * 0.2)
      ..cubicTo(
        cupR + w * 0.28, cupT + (cupB - cupT) * 0.18,
        cupR + w * 0.28, cupB - (cupB - cupT) * 0.28,
        cupR - w * 0.02, cupB - (cupB - cupT) * 0.22,
      );
    canvas.drawPath(handlePath, handlePaint);
    canvas.drawPath(
      handlePath,
      Paint()
        ..color = const Color(0xFFBCAAA4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.04
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawSteam(Canvas canvas, double w, double h) {
    // 3 jalur uap bergelombang naik dengan efek lebih dramatis
    for (int i = 0; i < 3; i++) {
      final xBase = w * (0.28 + i * 0.22);
      final phase = wavePhase + i * 1.2;
      final riseOffset = (math.sin(phase * 0.5) * 0.5 + 0.5) * h * 0.05;

      final path = Path();
      final startY = h * 0.37 - riseOffset;
      for (double t = 0; t <= 1; t += 0.04) {
        final x = xBase + math.sin(phase + t * math.pi * 2.5) * w * 0.07;
        final y = startY - t * h * 0.25;
        if (t == 0) path.moveTo(x, y);
        else path.lineTo(x, y);
      }

      final baseOpacity = 0.60 - i * 0.08;
      final strokeW = w * (0.060 - i * 0.012);

      // Bayangan uap tebal
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withValues(alpha: (baseOpacity * 0.4).clamp(0.05, 0.3))
          ..style = PaintingStyle.stroke
          ..strokeWidth = (strokeW * 2.2).clamp(1.0, 12.0)
          ..strokeCap = StrokeCap.round,
      );
      // Uap utama
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withValues(alpha: baseOpacity.clamp(0.1, 0.65))
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW.clamp(0.5, 6.0)
          ..strokeCap = StrokeCap.round,
      );
    }
  }



  @override
  bool shouldRepaint(_DrinkPainter old) =>
      old.wavePhase != wavePhase ||
      old.strawSway != strawSway ||
      old.bubbleProgress != bubbleProgress;
}
