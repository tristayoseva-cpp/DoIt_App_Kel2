import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum ButtonVariant { accent, dark, outline }

/// Tombol utama DoIt. Bentuk sengaja asimetris (pojok kiri bawah lebih lancip).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = ButtonVariant.accent,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;

  static const _radius = BorderRadius.only(
    topLeft: Radius.circular(18),
    topRight: Radius.circular(18),
    bottomRight: Radius.circular(18),
    bottomLeft: Radius.circular(6),
  );

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color? border;
    List<BoxShadow> shadow = const [];

    if (variant == ButtonVariant.accent) {
      bg = AppColors.accent;
      fg = AppColors.primary;
      shadow = const [
        BoxShadow(color: Color(0x4DFECD6D), blurRadius: 18, offset: Offset(0, 8)),
      ];
    } else if (variant == ButtonVariant.dark) {
      bg = AppColors.primary;
      fg = Colors.white;
      shadow = AppColors.softShadow;
    } else {
      bg = Colors.transparent;
      fg = AppColors.primary;
      border = AppColors.primary;
    }

    return Container(
      decoration: BoxDecoration(borderRadius: _radius, boxShadow: shadow),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: _radius,
            side: border == null
                ? BorderSide.none
                : BorderSide(color: border, width: 1.5),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
            Flexible(child: Text(label, textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }
}
