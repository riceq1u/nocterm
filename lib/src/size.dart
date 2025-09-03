class Size {
  const Size(this.width, this.height);

  final double width;
  final double height;

  static const Size zero = Size(0, 0);
  static const Size infinite = Size(double.infinity, double.infinity);

  @override
  String toString() => 'Size($width, $height)';
}
