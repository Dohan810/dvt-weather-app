import 'package:flutter/material.dart';

class KAddSpace extends StatelessWidget {
  final double multiplier;
  
  const KAddSpace({
    super.key,
    required this.multiplier,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: multiplier * 4,
      width: multiplier * 4,
    );
  }
}