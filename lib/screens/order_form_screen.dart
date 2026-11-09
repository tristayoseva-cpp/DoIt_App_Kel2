import 'package:flutter/material.dart';

import '../models/order.dart';
import '../models/service_category.dart';
import '../models/service_provider.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/quantity_stepper.dart';
import '../widgets/ticket_card.dart';
import 'order_status_screen.dart';

class OrderFormScreen extends StatefulWidget {
  const OrderFormScreen({super.key, required this.category, this.provider});

  final ServiceCategory category;
  final ServiceProvider? provider;

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _pickupCtrl = TextEditingController();
  final _destCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  // STATE: jumlah (km/kg/porsi) dan jadwal. Estimasi biaya dihitung ulang
  // setiap kali _qty berubah lewat setState().
  int _qty = 1;
  DateTime? _schedule;

  ServiceCategory get _c => widget.category;
  int get _total => _c.estimate(_qty);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pickupCtrl.dispose();
    _destCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickSchedule(FormFieldState<DateTime> field) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 30)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(hours: 1))),
    );
    if (time == null || !mounted) return;

    final picked = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() => _schedule = picked);
    field.didChange(picked); // supaya pesan error jadwal hilang
  }

  void _submit() {
    // validate() menjalankan semua validator; false jika ada yang tidak valid.
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masih ada data yang belum benar, cek lagi ya'),
        ),
      );
      return;
    }

    final order = Order(
      code:
          'DI-${(DateTime.now().millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}',
      category: _c,
      customerName: _nameCtrl.text.trim(),
      pickup: _pickupCtrl.text.trim(),
      destination: _c.needsDestination ? _destCtrl.text.trim() : null,
      quantity: _qty,
      schedule: _schedule!,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      total: _total,
      provider: widget.provider,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderStatusScreen(order: order)),
    );
  }

  String? _requiredMin(String? v, String label, int min) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return '$label wajib diisi';
    if (t.length < min) return '$label minimal $min karakter';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pesan ${_c.name}')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _buildHero(),
            const SizedBox(height: 22),
            AppTextField(
              label: 'Nama pemesan',
              hint: 'Contoh: Hanif',
              icon: Icons.person_outline_rounded,
              controller: _nameCtrl,
              validator: (v) => _requiredMin(v, 'Nama', 3),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: _c.needsDestination
                  ? 'Lokasi jemput'
                  : 'Alamat / nama kos',
              hint: _c.needsDestination
                  ? 'Contoh: Kos Melati, Jl. Kenanga 4'
                  : 'Contoh: Kos Melati kamar 12',
              icon: Icons.place_outlined,
              controller: _pickupCtrl,
              validator: (v) => _requiredMin(v, 'Alamat', 5),
            ),
            if (_c.needsDestination) ...[
              const SizedBox(height: 16),
              AppTextField(
                label: 'Tujuan',
                hint: 'Contoh: Kampus Gedung A',
                icon: Icons.flag_outlined,
                controller: _destCtrl,
                validator: (v) {
                  final err = _requiredMin(v, 'Tujuan', 5);
                  if (err != null) return err;
                  if (v!.trim().toLowerCase() ==
                      _pickupCtrl.text.trim().toLowerCase()) {
                    return 'Tujuan tidak boleh sama dengan lokasi jemput';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 16),
            QuantityStepper(
              label: _c.quantityLabel,
              unit: _c.unitLabel,
              value: _qty,
              min: 1,
              max: _c.maxQty,
              onChanged: (v) => setState(() => _qty = v),
            ),
            const SizedBox(height: 16),
            _buildSchedulePicker(),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Catatan (opsional)',
              hint: 'Contoh: tolong tunggu di depan gerbang',
              icon: Icons.sticky_note_2_outlined,
              controller: _noteCtrl,
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            _buildEstimate(),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Pesan sekarang',
              icon: Icons.bolt_rounded,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return TicketCard(
      accent: AppColors.accent,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _c.tint,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(_c.emoji, style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _c.tagline,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.provider == null
                      ? 'Penyedia terdekat akan dicarikan otomatis'
                      : 'Penyedia: ${widget.provider!.name} • ${widget.provider!.area}',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulePicker() {
    return FormField<DateTime>(
      validator: (v) {
        if (v == null) return 'Pilih tanggal & jam dulu';
        if (v.isBefore(DateTime.now()))
          return 'Jadwal tidak boleh di masa lalu';
        return null;
      },
      builder: (field) {
        final hasError = field.hasError;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Jadwal', style: kLabelStyle),
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _pickSchedule(field),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: hasError ? AppColors.error : AppColors.line,
                    width: hasError ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _schedule == null
                            ? 'Pilih tanggal & jam'
                            : formatSchedule(_schedule!),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _schedule == null
                              ? AppColors.muted
                              : AppColors.ink,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.muted,
                    ),
                  ],
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(color: AppColors.error, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildEstimate() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        boxShadow: AppColors.softShadow,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(28),
          bottomLeft: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estimasi biaya',
            style: TextStyle(color: Color(0xB3FFFFFF), fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            rupiah(_total),
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tarif dasar ${rupiah(_c.baseFee)} + $_qty ${_c.unitLabel} × ${rupiah(_c.unitPrice)}',
            style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
