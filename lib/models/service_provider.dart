/// Mahasiswa kos yang menawarkan jasa. (Dinamai ServiceProvider)

class ServiceProvider {
  const ServiceProvider({
    required this.name,
    required this.categoryIds,
    required this.area,
    required this.distanceKm,
    required this.bio,
    this.isNew = false,
  });

  final String name;
  final List<String> categoryIds; // satu penyedia bisa punya >1 jasa
  final String area;
  final double distanceKm;
  final String bio;
  final bool isNew; // true = baru mendaftar lewat form

  String get initial => name.isEmpty ? '?' : name[0].toUpperCase();

  String get distanceText => distanceKm < 1
      ? '${(distanceKm * 1000).round()} m'
      : '${distanceKm.toStringAsFixed(1)} km';
}
