import 'package:flutter/material.dart';

/// Satu jenis jasa di DoIt (antar jemput, laundry, masak).
class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.tagline,
    required this.tint,
    required this.baseFee,
    required this.unitPrice,
    required this.quantityLabel,
    required this.unitLabel,
    required this.maxQty,
    this.needsDestination = false,
  });

  final String id;
  final String name;
  final String emoji;
  final String tagline;
  final Color tint; // warna lembut untuk latar ikon
  final int baseFee; // tarif dasar
  final int unitPrice; // tarif per satuan (km / kg / porsi)
  final String quantityLabel; // contoh: "Berat cucian"
  final String unitLabel; // contoh: "kg"
  final int maxQty;
  final bool needsDestination; // true = butuh alamat tujuan (antar jemput)

  /// Rumus estimasi biaya yang tampil sebelum pesanan dikonfirmasi.
  int estimate(int qty) => baseFee + unitPrice * qty;
}
