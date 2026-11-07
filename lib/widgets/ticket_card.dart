import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Kartu bergaya "tiket": pojok asimetris + strip warna di sisi kiri.
class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    required this.child,
    this.accent = AppColors.primary,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final Color accent;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  static const radius = BorderRadius.only(
    topLeft: Radius.circular(22),
    topRight: Radius.circular(8),
    bottomRight: Radius.circular(22),
    bottomLeft: Radius.circular(8),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: radius,
        boxShadow: AppColors.softShadow,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          color: AppColors.surface,
          child: InkWell(
            onTap: onTap,
            child: Container(
              // Strip warna di sisi kiri (tanpa IntrinsicHeight, karena
              // DashedDivider memakai LayoutBuilder yang tidak mendukungnya).
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: accent, width: 6)),
              ),
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Garis putus-putus ala sobekan tiket.
class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final count = (box.maxWidth / 9).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(width: 5, height: 1.5, color: AppColors.line),
          ),
        );
      },
    );
  }
}
