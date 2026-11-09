String rupiah(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}
https://github.com/tristayoseva-cpp/DoIt_App_Kel2/pull/6/conflict?name=lib%252Futils%252Fformat.dart&ancestor_oid=e69de29bb2d1d6434b8b29ae775ad8c2e48c5391&base_oid=815640c65b7a58fd4ceb1d0d3c0e025cf0b68405&head_oid=c31756ca5668eff46956f37f33dbd04824d57d1f
const _bulan = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

/// "10 Nov 2026 • 14.30"
String formatSchedule(DateTime d) {
  final h = d.hour.toString().padLeft(2, '0');
  final m = d.minute.toString().padLeft(2, '0');
  return '${d.day} ${_bulan[d.month - 1]} ${d.year} • $h.$m';
}
