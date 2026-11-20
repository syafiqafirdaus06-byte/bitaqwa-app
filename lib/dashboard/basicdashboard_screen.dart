import 'dart:async';

import 'package:bitaqwa/dashboard/color_constant.dart';
import 'package:bitaqwa/dashboard/menu_data.dart';
import 'package:bitaqwa/jadwal_sholat/jadwal_sholat_screen.dart';
import 'package:flutter/material.dart';

// SCREEN BASIC DASHBOARD: salam, sholat berikutnya, dan daftar tombol menu.
class BasicDashboardScreen extends StatefulWidget {
  const BasicDashboardScreen({super.key});

  @override
  State<BasicDashboardScreen> createState() => _BasicDashboardScreenState();
}

class _BasicDashboardScreenState extends State<BasicDashboardScreen> {
  // Ganti sesuai keinginan
  static const _nama = 'Syafiq';
  static const _lokasi = 'Bogor, Pamijahan';
  // Menu yang layarnya sudah tersedia.
  static const _ready = {'doa', 'jadwal-sholat', 'video-kajian', 'zakat'};

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Segarkan tiap 30 detik agar sholat berikutnya selalu terbaru.
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final next = JadwalSholatScreen.nextPrayer(now);
    final jam = '${_two(next.time.hour)}:${_two(next.time.minute)}';
    final tanggal = '${_two(now.day)}.${_two(now.month)}.${now.year}';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorConstant.colorPrimary,
              ColorConstant.colorPrimaryDark,
              const Color(0xff0B1A17),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Siluet masjid (dekorasi)
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Icon(Icons.mosque,
                  size: 230, color: ColorConstant.colorWhite.withValues(alpha: 0.08)),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  children: [
                    // 1. SALAM
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bismillah',
                              style: TextStyle(color: ColorConstant.colorAccent)),
                          Text('Assalamualaikum $_nama',
                              style: TextStyle(
                                  color: ColorConstant.colorWhite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),
                    // 2. SHOLAT BERIKUTNYA
                    Text(next.name,
                        style: TextStyle(
                            color: ColorConstant.colorGold,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    Text(jam,
                        style: TextStyle(
                            color: ColorConstant.colorWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 64)),
                    Text(tanggal,
                        style: TextStyle(color: ColorConstant.colorWhite, fontSize: 22)),
                    const SizedBox(height: 4),
                    Text(_lokasi,
                        style: TextStyle(color: ColorConstant.colorAccent, fontSize: 14)),
                    const SizedBox(height: 56),
                    // 3. DAFTAR MENU
                    for (final menu in menus) _tombol(context, menu),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tombol(BuildContext context, dynamic menu) {
    final radius = BorderRadius.circular(22);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: ColorConstant.colorWhite.withValues(alpha: 0.35)),
            gradient: LinearGradient(
              colors: [
                ColorConstant.colorWhite.withValues(alpha: 0.55),
                ColorConstant.colorWhite.withValues(alpha: 0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: InkWell(
            borderRadius: radius,
            onTap: () {
              if (_ready.contains(menu.route)) {
                Navigator.pushNamed(context, menu.route);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${menu.title} segera hadir.')),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: ColorConstant.colorAccent,
                    child: Image.asset(
                      menu.image,
                      width: 30,
                      height: 30,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.apps, color: ColorConstant.colorPrimaryDark),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(menu.title,
                        style: TextStyle(
                            color: ColorConstant.colorWhite,
                            fontSize: 24,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
