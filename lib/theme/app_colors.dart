import 'package:flutter/material.dart';

/// Palet DoIt (Burgundy, Chinese Red, Satsuma, Lunar Yellow, Cobalt).
/// Pembagian peran: krem = latar, putih = kartu/input, burgundy = identitas,
/// kuning = aksi utama, satsuma & cobalt = aksen pendukung.
class AppColors {
  AppColors._();

  static const background = Color(0xFFF8F3EA); // latar layar (krem hangat)
  static const surface = Colors.white; // kartu & input
  static const primary = Color(0xFF70191D); // Burgundy
  static const primaryLight = Color(0xFF970A12); // Chinese Red
  static const accent = Color(0xFFFECD6D); // Lunar Yellow (tombol utama)
  static const satsuma = Color(0xFFD1601F); // Satsuma (aksen hangat)
  static const cobalt = Color(0xFF5686BB); // Cobalt (aksen dingin)
  static const ink = Color(0xFF2B1C1C); // teks utama
  static const muted = Color(0xFF7D6E6B); // teks sekunder
  static const line = Color(0xFFEADFD2); // garis & border halus
  static const error = Color(0xFFD32F2F);

  // Warna lembut untuk latar ikon kategori & badge
  static const butter = Color(0xFFFFF0CF); // turunan Lunar Yellow
  static const skyTint = Color(0xFFDCE8F5); // turunan Cobalt
  static const satsumaTint = Color(0xFFFBE3D3); // turunan Satsuma

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  /// Shadow bernuansa burgundy (bukan abu-abu standar).
  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x2670191D), blurRadius: 24, offset: Offset(0, 10)),
  ];
}
