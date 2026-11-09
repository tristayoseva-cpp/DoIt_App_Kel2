import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/order.dart';
import '../models/service_provider.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import '../widgets/primary_button.dart';
import '../widgets/provider_tile.dart';
import '../widgets/ticket_card.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key, required this.order});

  final Order order;

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  // STATE: tahap pesanan saat ini (0..3). Naik lewat setState() sehingga
  // timeline, teks, dan tombol di layar berubah.
  int _step = 0;

  Order get _order => widget.order;

  List<({String title, String desc})> get _steps => [
        (title: 'Mencari penyedia', desc: 'Kami lagi nyariin mahasiswa terdekat…'),
        (title: 'Pesanan diterima', desc: 'Penyedia sudah menerima dan bersiap.'),
        (
          title: _order.category.needsDestination ? 'Dalam perjalanan' : 'Sedang dikerjakan',
          desc: _order.category.needsDestination
              ? 'Penyedia menuju lokasi jemputmu.'
              : 'Pesananmu lagi diproses.',
        ),
        (title: 'Selesai', desc: 'Pesanan beres. Terima kasih sudah pakai DoIt!'),
      ];

  ServiceProvider get _assigned => _order.provider ?? providerFor(_order.category.id);

  bool get _isDone => _step == _steps.length - 1;

  void _next() {
    if (_isDone) return;
    setState(() => _step++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status Pesanan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _buildSummary(),
          const SizedBox(height: 26),
          const Text(
            'Perjalanan pesanan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          _buildTimeline(),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: _step >= 1
                ? Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Penyedia kamu',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        ProviderTile(provider: _assigned, onTap: () {}),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
          const SizedBox(height: 24),
          if (_isDone) ...[
            const Center(
              child: Text('🎉', style: TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Kembali ke Beranda',
              icon: Icons.home_rounded,
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            ),
          ] else ...[
            PrimaryButton(
              label: 'Simulasikan tahap berikutnya',
              icon: Icons.fast_forward_rounded,
              onPressed: _next,
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Di versi lengkap, status berubah otomatis dari penyedia.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11.5, color: AppColors.muted),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummary() {
    Widget row(String label, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 78,
                child: Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
              ),
              Expanded(
                child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ],
          ),
        );

    return TicketCard(
      accent: AppColors.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_order.category.emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _order.category.name,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.skyTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _order.code,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const DashedDivider(),
          const SizedBox(height: 10),
          row('Pemesan', _order.customerName),
          row(_order.category.needsDestination ? 'Jemput' : 'Alamat', _order.pickup),
          if (_order.destination != null) row('Tujuan', _order.destination!),
          row(_order.category.quantityLabel, '${_order.quantity} ${_order.category.unitLabel}'),
          row('Jadwal', formatSchedule(_order.schedule)),
          if (_order.note != null) row('Catatan', _order.note!),
          const SizedBox(height: 8),
          const DashedDivider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(color: AppColors.muted)),
              Text(
                rupiah(_order.total),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final steps = _steps;
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 30,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < _step
                              ? AppColors.primary
                              : (i == _step ? AppColors.accent : AppColors.line),
                        ),
                        child: Icon(
                          i < _step || (i == _step && _isDone)
                              ? Icons.check_rounded
                              : Icons.circle,
                          size: i < _step || (i == _step && _isDone) ? 18 : 8,
                          color: i < _step
                              ? Colors.white
                              : (i == _step ? AppColors.primary : AppColors.muted),
                        ),
                      ),
                      if (i != steps.length - 1)
                        Expanded(
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 3,
                              color: i < _step ? AppColors.primary : AppColors.line,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          steps[i].title,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: i <= _step ? AppColors.ink : AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          steps[i].desc,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.muted,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
