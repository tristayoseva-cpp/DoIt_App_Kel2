import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/service_category.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category, required this.onTap});

  final ServiceCategory category;
  final VoidCallback onTap;

  static const _radius = BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(10),
    bottomRight: Radius.circular(24),
    bottomLeft: Radius.circular(10),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: _radius,
        boxShadow: AppColors.softShadow,
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: _radius,
        child: InkWell(
          borderRadius: _radius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ikon emoji di atas "blob" yang sedikit dimiringkan
                Transform.rotate(
                  angle: -math.pi / 28,
                  child: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: category.tint,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Text(category.emoji, style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  category.name,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  'dari ${rupiah(category.baseFee + category.unitPrice)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
