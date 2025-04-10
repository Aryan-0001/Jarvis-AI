class CorePatternPainter extends CustomPainter {
  final bool isActive;
  final bool isConversation;
  final Color color;
  final bool showPurpleTriangle;
  CorePatternPainter({
    this.isActive = false,
    this.isConversation = false,
    this.color = Colors.blue,
    this.showPurpleTriangle = false,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5;
    final path = Path();
    final triangleSize = radius * 0.8;
    final height = triangleSize * sqrt(3) / 2;
    path.moveTo(center.dx, center.dy - height / 2);
    path.lineTo(center.dx + triangleSize / 2, center.dy + height / 2);
    path.lineTo(center.dx - triangleSize / 2, center.dy + height / 2);
    path.close();
    canvas.drawPath(path, borderPaint);
    canvas.drawPath(path, paint); 
    final innerPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final innerBorderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final innerSize = triangleSize * 0.6;
    final innerHeight = innerSize * sqrt(3) / 2;
    path.reset();
    path.moveTo(center.dx, center.dy - innerHeight / 2);
    path.lineTo(center.dx + innerSize / 2, center.dy + innerHeight / 2);
    path.lineTo(center.dx - innerSize / 2, center.dy + innerHeight / 2);
    path.close();
    canvas.drawPath(path, innerBorderPaint); 
    canvas.drawPath(path, innerPaint); 
    final dotPaint = Paint()
      ..color = color.withOpacity(0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.12, dotPaint);
    if (showPurpleTriangle) {
      final purplePaint = Paint()
        ..color = Colors.purple.withOpacity(0.8)
        ..style = PaintingStyle.fill;
      final purpleBorderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      final purpleTrianglePath = Path();
      final purpleTriangleSize =
          radius * 0.5;
      final purpleHeight = purpleTriangleSize * sqrt(3) / 2;
      purpleTrianglePath.moveTo(center.dx, center.dy - purpleHeight / 2);
      purpleTrianglePath.lineTo(
          center.dx + purpleTriangleSize / 2, center.dy + purpleHeight / 2);
      purpleTrianglePath.lineTo(
          center.dx - purpleTriangleSize / 2, center.dy + purpleHeight / 2);
      purpleTrianglePath.close();
      final purpleRect = Rect.fromCircle(center: center, radius: radius * 0.5);
      final purpleGradient = RadialGradient(
        colors: [
          Colors.purple.withOpacity(0.9),
          Colors.deepPurple.withOpacity(0.7),
        ],
        center: Alignment(0.2, -0.3),
        radius: 0.8,
      );

      final gradientPaint = Paint()
        ..shader = purpleGradient.createShader(purpleRect)
        ..style = PaintingStyle.fill;
      //drawing a 3d triangle with gradient and a border...
      canvas.drawPath(purpleTrianglePath, gradientPaint);
      canvas.drawPath(purpleTrianglePath, purpleBorderPaint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
