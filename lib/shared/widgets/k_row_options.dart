import 'package:flutter/material.dart';

enum LayoutType { row, column }

class KRowOptions extends StatelessWidget {
  final String title;
  final LayoutType layoutType;
  final List<Widget> children;
  final String hexColor;

  const KRowOptions({
    super.key,
    required this.title,
    required this.layoutType,
    required this.children,
    this.hexColor = '#E0E0E0',
  });

  @override
  Widget build(BuildContext context) {
    
    return ListTile(
      title: Text(title),
      subtitle: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: layoutType == LayoutType.row
            ? Row(
                children: children,
              )
            : Column(
                children: children,
              ),
      ),
    );
  }
}
