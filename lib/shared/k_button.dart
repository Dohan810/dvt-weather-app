import 'package:flutter/material.dart';
import 'package:weather_wise/main.dart';
import 'package:weather_wise/shared/utils/color_extensions.dart';
import 'package:provider/provider.dart';

class KButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? rightIcon;
  MainAxisSize mainAxisSize = MainAxisSize.min;

   KButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.rightIcon,
    this.mainAxisSize = MainAxisSize.min
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Row(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (rightIcon != null) ...[
              SizedBox(width: 8),
              Icon(rightIcon, color: Theme.of(context).colorScheme.primary),
            ],
          ],
        ),
      ),
    );
  }
}
