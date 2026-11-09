import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/dummy_data.dart';
import '../models/service_category.dart';
import '../models/service_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/category_tile.dart';
import '../widgets/primary_button.dart';
import '../widgets/provider_tile.dart';
import 'order_form_screen.dart';
import 'provider_register_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // STATE: daftar penyedia, filter kategori, dan kata kunci pencarian.
  // Setiap perubahan dibungkus setState() sehingga daftar di layar ikut berubah.
  final List<ServiceProvider> _providers = List.of(dummyProviders);
  String? _filter; // null = semua kategori
  String _query = '';

  List<ServiceProvider> get _visible {
    final q = _query.trim().toLowerCase();
    return _providers.where((p) {
      final okCategory = _filter == null || p.categoryIds.contains(_filter);
      final okQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.area.toLowerCase().contains(q);
      return okCategory && okQuery;
    }).toList();
  }

  void _openOrder(ServiceCategory category, {ServiceProvider? provider}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderFormScreen(category: category, provider: provider),
      ),
    );
  }

  /// Tap kartu penyedia: pakai kategori yang sedang difilter, kalau tidak ada
  /// pakai jasa pertama milik penyedia.
  void _orderFromProvider(ServiceProvider p) {
    final id = (_filter != null && p.categoryIds.contains(_filter))
        ? _filter!
        : p.categoryIds.first;
    _openOrder(categoryById(id), provider: p);
  }

  Future<void> _openRegister() async {
    // Screen pendaftaran mengembalikan penyedia baru lewat Navigator.pop(...)
    final created = await Navigator.push<ServiceProvider>(
      context,
      MaterialPageRoute(builder: (_) => const ProviderRegisterScreen()),
    );
    if (created == null || !mounted) return;
    setState(() => _providers.insert(0, created));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${created.name} sekarang muncul di daftar penyedia')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mau bantuin apa?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        for (final c in categories)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: c == categories.last ? 0 : 12),
                              child: CategoryTile(category: c, onTap: () => _openOrder(c)),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Mahasiswa di sekitar kosmu',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    _buildFilterChips(),
                    const SizedBox(height: 16),
                    if (visible.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 28),
                        child: Center(
                          child: Text(
                            '🔍 Belum ada penyedia yang cocok.\nCoba kata kunci atau kategori lain.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.muted, height: 1.4),
                          ),
                        ),
                      )
                    else
                      for (final p in visible)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: ProviderTile(
                            provider: p,
                            onTap: () => _orderFromProvider(p),
                          ),
                        ),
                    const SizedBox(height: 14),
                    _buildJoinBanner(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Do', style: TextStyle(color: Colors.white)),
                            TextSpan(text: 'It', style: TextStyle(color: AppColors.accent)),
                          ],
                        ),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0x26FFFFFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '📍 Sekitar kosmu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Halo, anak kos! 👋',
                    style: TextStyle(color: Color(0xB3FFFFFF), fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Mau dibantuin\napa hari ini?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      decoration: const InputDecoration(
                        hintText: 'Cari nama atau kos penyedia…',
                        hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
                        prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    Widget chip(String label, String? id) {
      final selected = _filter == id;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => setState(() => _filter = id),
          showCheckmark: false,
          selectedColor: AppColors.primary,
          backgroundColor: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(color: selected ? AppColors.primary : AppColors.line),
          ),
          labelStyle: TextStyle(
            color: selected ? Colors.white : AppColors.ink,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip('Semua', null),
          for (final c in categories) chip('${c.emoji} ${c.name}', c.id),
        ],
      ),
    );
  }

  Widget _buildJoinBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.butter,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(8),
          bottomLeft: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💸', style: TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          const Text(
            'Punya waktu luang & skill?',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Daftar jadi penyedia jasa dan dapatkan penghasilan tambahan dari kosmu sendiri.',
            style: TextStyle(color: AppColors.muted, height: 1.4, fontSize: 13),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Daftar jadi penyedia',
            icon: Icons.add_business_rounded,
            variant: ButtonVariant.dark,
            onPressed: _openRegister,
          ),
        ],
      ),
    );
  }
}
