import 'package:flutter/material.dart';

/// グラデーション付き AppBar
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const GradientAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFEC4899), // 強めのピンク
              Color(0xFFA855F7), // 紫
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
