import 'package:flutter/material.dart';
import 'package:weather_wise/shared/utils/color_extensions.dart';

class KButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? rightIcon;

  const KButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.rightIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: ColorExtension.fromHex("#2B3151"),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
            if (rightIcon != null) ...[
              SizedBox(width: 8),
              Icon(rightIcon, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}
