import 'dart:async';
import 'dart:math';

import 'package:bitaqwa/dashboard/color_constant.dart';
import 'package:flutter/material.dart';

// LAYAR JADWAL SHOLAT (Tugas 5): waktu sholat dihitung otomatis untuk Bogor.
class JadwalSholatScreen extends StatefulWidget {
  const JadwalSholatScreen({super.key});

  // Lokasi: Bogor (WIB = UTC+7). Ubah untuk kota lain.
  static const double _lat = -6.595;
  static const double _lng = 106.816;
  static const int _tz = 7;

  // Ihtiyath (menit pengaman): Subuh, Dzuhur, Ashar, Maghrib, Isya.
  static const _ihtiyat = [2, 4, 2, 4, 2];
  static const _names = ['Subuh', 'Dzuhur', 'Ashar', 'Maghrib', 'Isya'];
  static const _hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Ahad'];
  static const _bulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
    'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  static double _rad(double d) => d * pi / 180;
  static double _deg(double r) => r * 180 / pi;

  /// Mengembalikan jam desimal 5 waktu sholat untuk [date].
  static List<double> _hours(DateTime date) {
    var y = date.year, m = date.month;
    final dd = date.day.toDouble();
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final a = y ~/ 100;
    final jd = (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        dd +
        (2 - a + a ~/ 4) -
        1524.5;
    final d = jd - 2451545.0 + (12 - _tz) / 24;
    final g = _rad((357.529 + 0.98560028 * d) % 360);
    final q = (280.459 + 0.98564736 * d) % 360;
    final l = _rad((q + 1.915 * sin(g) + 0.020 * sin(2 * g)) % 360);
    final e = _rad(23.439 - 0.00000036 * d);
    final ra = (_deg(atan2(cos(e) * sin(l), cos(l))) / 15) % 24;
    final dec = asin(sin(e) * sin(l));
    final eqt = (((q / 15 - ra) + 12) % 24) - 12;
    final noon = 12 + _tz - _lng / 15 - eqt;
    final la = _rad(_lat);

    double t(double angle) {
      final x = (sin(_rad(angle)) - sin(dec) * sin(la)) / (cos(dec) * cos(la));
      return _deg(acos(x)) / 15;
    }

    final asr = _deg(atan(1 / (1 + tan((la - dec).abs()))));
    final raw = [noon - t(-20), noon, noon + t(asr), noon + t(-0.833), noon + t(-18)];
    return [for (var i = 0; i < 5; i++) raw[i] + _ihtiyat[i] / 60];
  }

  /// Sholat berikutnya setelah [now] (dipakai juga oleh Dashboard).
  static ({String name, DateTime time}) nextPrayer(DateTime now) {
    final today = _hours(now);
    final i = today.indexWhere((h) => _at(h, now).isAfter(now));
    if (i == -1) {
      final besok = now.add(const Duration(days: 1));
      return (name: _names[0], time: _at(_hours(besok)[0], besok));
    }
    return (name: _names[i], time: _at(today[i], now));
  }

  static DateTime _at(double h, DateTime day) =>
      DateTime(day.year, day.month, day.day, h.floor(), ((h % 1) * 60).floor());

  static String _fmt(double h) =>
      '${h.floor().toString().padLeft(2, '0')}:${((h % 1) * 60).floor().toString().padLeft(2, '0')}';

  @override
  State<JadwalSholatScreen> createState() => _JadwalSholatState();
}

class _JadwalSholatState extends State<JadwalSholatScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Perbarui layar tiap detik supaya hitungan mundur berjalan sendiri.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = JadwalSholatScreen._hours(now);
    var next = today.indexWhere((h) => JadwalSholatScreen._at(h, now).isAfter(now));
    late DateTime nextTime;
    late double nextHour;
    if (next == -1) {
      next = 0;
      final tomorrow = now.add(const Duration(days: 1));
      nextHour = JadwalSholatScreen._hours(tomorrow)[0];
      nextTime = JadwalSholatScreen._at(nextHour, tomorrow);
    } else {
      nextHour = today[next];
      nextTime = JadwalSholatScreen._at(nextHour, now);
    }
    final diff = nextTime.difference(now);

    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      appBar: AppBar(
        backgroundColor: ColorConstant.colorPrimary,
        foregroundColor: ColorConstant.colorWhite,
        title: const Text('Jadwal Sholat'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${JadwalSholatScreen._hari[now.weekday - 1]}, ${now.day} ${JadwalSholatScreen._bulan[now.month - 1]} ${now.year}',
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorConstant.colorText),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ColorConstant.colorPrimary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text('Sholat berikutnya',
                    style: TextStyle(color: ColorConstant.colorWhite)),
                const SizedBox(height: 6),
                Text(JadwalSholatScreen._names[next],
                    style: TextStyle(
                        color: ColorConstant.colorWhite,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                Text(JadwalSholatScreen._fmt(nextHour),
                    style: TextStyle(color: ColorConstant.colorWhite, fontSize: 24)),
                const SizedBox(height: 6),
                Text('${diff.inHours} jam ${diff.inMinutes % 60} menit ${diff.inSeconds % 60} detik lagi',
                    style: TextStyle(color: ColorConstant.colorWhite)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < 5; i++)
            Card(
              elevation: 0,
              color: i == next ? ColorConstant.colorAccent : ColorConstant.colorWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: ColorConstant.colorAccent, width: 2),
              ),
              child: ListTile(
                leading: Icon(Icons.access_time, color: ColorConstant.colorPrimaryDark),
                title: Text(JadwalSholatScreen._names[i],
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: ColorConstant.colorText)),
                trailing: Text(JadwalSholatScreen._fmt(today[i]),
                    style: TextStyle(fontSize: 18, color: ColorConstant.colorText)),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            'Dihitung otomatis untuk Bogor. Bisa berbeda 1–3 menit dari jadwal Kemenag/masjid setempat.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: ColorConstant.colorText),
          ),
        ],
      ),
    );
  }
}
