import 'dart:math';

const String _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

String generateOrderCode({int length = 8}) {
  final random = Random();
  return List.generate(
    length,
    (_) => _chars[random.nextInt(_chars.length)],
  ).join();
}
