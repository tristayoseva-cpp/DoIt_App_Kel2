import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/dummy_data.dart';
import '../models/service_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class ProviderRegisterScreen extends StatefulWidget {
  const ProviderRegisterScreen({super.key});

  @override
  State<ProviderRegisterScreen> createState() => _ProviderRegisterScreenState();
}

class _ProviderRegisterScreenState extends State<ProviderRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _nimCtrl = TextEditingController();
  final _waCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();

  // STATE: jasa yang dipilih, status upload KTM, persetujuan, dan flag
  // "sudah pernah tekan Daftar" untuk menampilkan error di bagian non-TextField.
  final Set<String> _selected = {};
  bool _ktmAttached = false; // disimulasikan (belum pakai image_picker)
  bool _agree = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nimCtrl.dispose();
    _waCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  String? get _categoryError =>
      _submitted && _selected.isEmpty ? 'Pilih minimal satu jenis jasa' : null;
  String? get _ktmError =>
      _submitted && !_ktmAttached ? 'Foto KTM wajib dilampirkan' : null;
  String? get _agreeError =>
      _submitted && !_agree ? 'Kamu harus menyetujui pernyataan ini' : null;

  Future<void> _submit() async {
    final formOk = _formKey.currentState!.validate();
    setState(() => _submitted = true);

    final extraOk = _selected.isNotEmpty && _ktmAttached && _agree;
    if (!formOk || !extraOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi dulu data pendaftaran ya')),
      );
      return;
    }

    final provider = ServiceProvider(
      name: _nameCtrl.text.trim(),
      categoryIds: _selected.toList(),
      area: _areaCtrl.text.trim(),
      distanceKm: 0.2,
      bio: 'Penyedia baru, siap membantu di sekitar kosmu.',
      isNew: true,
    );

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Pendaftaran terkirim 🎉', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          'Akunmu akan aktif setelah status mahasiswa diverifikasi (disimulasikan di versi ini).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Lihat di Beranda',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.pop(context, provider); // kirim data kembali ke Beranda
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadi Penyedia Jasa')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            const Text(
              'Ubah waktu luangmu jadi penghasilan. Isi data singkat di bawah ini.',
              style: TextStyle(color: AppColors.muted, height: 1.4),
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Nama lengkap',
              hint: 'Sesuai KTM',
              icon: Icons.badge_outlined,
              controller: _nameCtrl,
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return 'Nama wajib diisi';
                if (t.length < 3) return 'Nama minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'NIM',
              hint: '9 digit angka',
              icon: Icons.numbers_rounded,
              controller: _nimCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return 'NIM wajib diisi';
                if (t.length != 9) return 'NIM harus 9 digit angka';
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'No. WhatsApp',
              hint: '08xxxxxxxxxx',
              icon: Icons.phone_outlined,
              controller: _waCtrl,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return 'Nomor WhatsApp wajib diisi';
                if (!t.startsWith('08')) return 'Nomor harus diawali 08';
                if (t.length < 10 || t.length > 13) return 'Panjang nomor 10–13 digit';
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Nama kos / area',
              hint: 'Contoh: Kos Melati',
              icon: Icons.home_work_outlined,
              controller: _areaCtrl,
              validator: (v) =>
                  (v ?? '').trim().length < 3 ? 'Isi nama kos minimal 3 karakter' : null,
            ),
            const SizedBox(height: 20),
            const Text('Jasa yang ditawarkan', style: kLabelStyle),
            const SizedBox(height: 4),
            const Text(
              'Boleh pilih lebih dari satu',
              style: TextStyle(fontSize: 12, color: AppColors.muted),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in categories)
                  FilterChip(
                    label: Text('${c.emoji} ${c.name}'),
                    selected: _selected.contains(c.id),
                    showCheckmark: false,
                    onSelected: (on) => setState(() {
                      if (on) {
                        _selected.add(c.id);
                      } else {
                        _selected.remove(c.id);
                      }
                    }),
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: _selected.contains(c.id) ? AppColors.primary : AppColors.line,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _selected.contains(c.id) ? Colors.white : AppColors.ink,
                    ),
                  ),
              ],
            ),
            if (_categoryError != null) _errorText(_categoryError!),
            const SizedBox(height: 20),
            const Text('Foto KTM / KTMA', style: kLabelStyle),
            const SizedBox(height: 8),
            _buildKtmBox(),
            if (_ktmError != null) _errorText(_ktmError!),
            const SizedBox(height: 14),
            CheckboxListTile(
              value: _agree,
              onChanged: (v) => setState(() => _agree = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.primary,
              title: const Text(
                'Saya mahasiswa aktif dan data di atas benar.',
                style: TextStyle(fontSize: 13),
              ),
            ),
            if (_agreeError != null) _errorText(_agreeError!),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'Daftar sekarang',
              icon: Icons.check_circle_outline_rounded,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorText(String text) => Padding(
        padding: const EdgeInsets.only(top: 6, left: 4),
        child: Text(text, style: const TextStyle(color: AppColors.error, fontSize: 12)),
      );

  Widget _buildKtmBox() {
    final hasError = _ktmError != null;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => setState(() => _ktmAttached = !_ktmAttached),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _ktmAttached ? AppColors.skyTint : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasError
                ? AppColors.error
                : (_ktmAttached ? AppColors.primaryLight : AppColors.line),
            width: hasError ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _ktmAttached ? Icons.check_circle_rounded : Icons.upload_file_rounded,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _ktmAttached
                    ? 'ktm_mahasiswa.jpg terlampir (tap untuk hapus)'
                    : 'Tap untuk melampirkan foto KTM',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
