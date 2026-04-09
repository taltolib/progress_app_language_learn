// import 'package:flutter/material.dart';
//
// class DuolingoButtonPainter extends CustomPainter {
//   final Color topColor;
//   final Color baseColor;
//
//   const DuolingoButtonPainter({
//     required this.topColor,
//     required this.baseColor,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     // 1. Определяем диаметр круга.
//     // Чтобы кнопка была идеальной, берем меньшую из сторон и вычитаем отступ для 3D тени.
//     const double depth = 7.0;
//     final double diameter = (size.width < size.height ? size.width  : size.height - 20) - depth;
//
//     final Paint basePaint = Paint()
//       ..color = baseColor
//       ..isAntiAlias = true;
//
//     final Paint topPaint = Paint()
//       ..color = topColor
//       ..isAntiAlias = true;
//
//     // Находим центр холста
//     final Offset center = Offset(size.width / 2, size.height / 2);
//
//     // 2. Рисуем нижнюю часть (Тень/База)
//     // Смещаем её чуть ниже центра
//     canvas.drawCircle(
//         Offset(center.dx, center.dy + (depth / 2)),
//         diameter / 2,
//         basePaint
//     );
//
//     // 3. Рисуем верхнюю часть (Сама кнопка)
//     // Смещаем её чуть выше центра
//     canvas.drawCircle(
//         Offset(center.dx, center.dy - (depth / 2)),
//         diameter / 2,
//         topPaint
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant DuolingoButtonPainter oldDelegate) {
//     return oldDelegate.topColor != topColor || oldDelegate.baseColor != baseColor;
//   }
// }