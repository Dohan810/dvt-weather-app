import 'package:flutter/material.dart';
import 'package:weather_wise/main.dart';
import 'package:weather_wise/shared/utils/color_extensions.dart';
import 'package:provider/provider.dart';

class KButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Future<void> Function()? onPressAsync;
  final IconData? rightIcon;
  MainAxisSize mainAxisSize = MainAxisSize.min;

  KButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.onPressAsync,
    this.rightIcon,
    this.mainAxisSize = MainAxisSize.min,
  }) : super(key: key);

  @override
  _KButtonState createState() => _KButtonState();
}

class _KButtonState extends State<KButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed ?? _handleAsyncPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Row(
          mainAxisSize: widget.mainAxisSize,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              )
            else
              Text(
                widget.text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            if (widget.rightIcon != null && !_isLoading) ...[
              SizedBox(width: 8),
              Icon(widget.rightIcon, color: Theme.of(context).colorScheme.primary),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleAsyncPress() async {
    if (widget.onPressAsync != null) {
      setState(() {
        _isLoading = true;
      });
      await widget.onPressAsync!();
      setState(() {
        _isLoading = false;
      });
    }
  }
}
