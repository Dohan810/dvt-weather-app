import 'package:flutter/material.dart';
import 'package:weather_wise/main.dart';
import 'package:provider/provider.dart';

class KOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? rightIcon;
  final VoidCallback? onRightIconPress;

  const KOption({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.rightIcon,
    this.onRightIconPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color:  isSelected ? Colors.white : themeNotifier.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 2,
              ),
            ),
            if (rightIcon != null)
              IconButton(
                icon: Icon(rightIcon, color: Colors.red),
                onPressed: onRightIconPress,
              ),
          ],
        ),
      ),
    );
  }
}
