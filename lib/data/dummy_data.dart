import '../models/service_category.dart';
import '../models/service_provider.dart';
import '../theme/app_colors.dart';

const List<ServiceCategory> categories = [
  ServiceCategory(
    id: 'antar',
    name: 'Antar Jemput',
    emoji: '🛵',
    tagline: 'Berangkat tanpa pusing cari kendaraan',
    tint: AppColors.butter,
    baseFee: 5000,
    unitPrice: 3000,
    quantityLabel: 'Perkiraan jarak',
    unitLabel: 'km',
    maxQty: 20,
    needsDestination: true,
  ),
  ServiceCategory(
    id: 'laundry',
    name: 'Laundry',
    emoji: '🧺',
    tagline: 'Cucian beres, kamu fokus kuliah',
    tint: AppColors.skyTint,
    baseFee: 3000,
    unitPrice: 6000,
    quantityLabel: 'Berat cucian',
    unitLabel: 'kg',
    maxQty: 15,
  ),
  ServiceCategory(
    id: 'masak',
    name: 'Jasa Masak',
    emoji: '🍳',
    tagline: 'Masakan rumahan harga anak kos',
    tint: AppColors.satsumaTint,
    baseFee: 4000,
    unitPrice: 12000,
    quantityLabel: 'Jumlah porsi',
    unitLabel: 'porsi',
    maxQty: 10,
  ),
];

ServiceCategory categoryById(String id) =>
    categories.firstWhere((c) => c.id == id);

const List<ServiceProvider> dummyProviders = [
  ServiceProvider(
    name: 'Rafi Pratama',
    categoryIds: ['antar'],
    area: 'Kos Melati',
    distanceKm: 0.3,
    bio: 'Motor siap, hafal jalan sekitar kampus.',
  ),
  ServiceProvider(
    name: 'Salsa Maharani',
    categoryIds: ['laundry'],
    area: 'Kos Anggrek',
    distanceKm: 0.4,
    bio: 'Cuci, kering, lipat. Selesai dalam sehari.',
  ),
  ServiceProvider(
    name: 'Nadia Kusuma',
    categoryIds: ['masak'],
    area: 'Kos Kenanga',
    distanceKm: 0.6,
    bio: 'Masakan rumahan: ayam, tempe, sayur segar.',
  ),
  ServiceProvider(
    name: 'Dimas Aryo',
    categoryIds: ['antar'],
    area: 'Kos Mawar',
    distanceKm: 0.8,
    bio: 'Bisa jemput pagi buta, anti telat kelas.',
  ),
  ServiceProvider(
    name: 'Bagas Wicaksono',
    categoryIds: ['masak', 'antar'],
    area: 'Kos Cempaka',
    distanceKm: 0.9,
    bio: 'Bisa masak, bisa sekalian anter pesanan.',
  ),
  ServiceProvider(
    name: 'Putri Ayu',
    categoryIds: ['laundry'],
    area: 'Kos Dahlia',
    distanceKm: 1.1,
    bio: 'Setrika rapi, wangi tahan lama.',
  ),
];

/// Penyedia pertama yang punya jasa tersebut (dipakai saat pesanan "diterima").
ServiceProvider providerFor(String categoryId) =>
    dummyProviders.firstWhere((p) => p.categoryIds.contains(categoryId));
