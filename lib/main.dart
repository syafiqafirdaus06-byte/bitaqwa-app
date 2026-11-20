import 'package:bitaqwa/dashboard/basicdashboard_screen.dart';
import 'package:bitaqwa/doa_harian/doa_screen.dart';
import 'package:bitaqwa/jadwal_sholat/jadwal_sholat_screen.dart';
import 'package:bitaqwa/kajian_online/video_kajian_screen.dart';
import 'package:bitaqwa/zakat/zakat_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Menyiapkan format tanggal Indonesia
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitaqwa',
      debugShowCheckedModeBanner: false,
      // Transisi antarlayar (zoom/fade halus di semua platform)
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          for (final p in TargetPlatform.values) p: const ZoomPageTransitionsBuilder(),
        }),
      ),
      // Aksesibilitas: ikuti ukuran teks sistem, tapi dibatasi 1.0-1.3x agar tata letak aman.
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
              textScaler: mq.textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.3)),
          child: child!,
        );
      },
      home: const BasicDashboardScreen(),
      // Nama rute sama dengan field `route` di menu_data.dart
      routes: {
        'doa': (context) => const DoaScreen(),
        'jadwal-sholat': (context) => const JadwalSholatScreen(),
        'video-kajian': (context) => const VideoKajianScreen(),
        'zakat': (context) => const ZakatScreen(),
      },
    );
  }
}
