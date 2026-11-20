import 'package:bitaqwa/dashboard/color_constant.dart';
import 'package:bitaqwa/kajian_online/kajian_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// LAYAR DETAIL KAJIAN: header, nama pemateri, video, dan deskripsi.
class KajianDetailScreen extends StatelessWidget {
  final KajianVideo kajian;
  const KajianDetailScreen({super.key, required this.kajian});

  // Teks di header (ganti sesuai keinginan)
  static const _namaHeader = 'Syafiq A Firdaus';
  static const _bismillah = 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ';

  Future<void> _bukaVideo(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await launchUrl(Uri.parse(kajian.url),
        mode: LaunchMode.externalApplication);
    if (!ok) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Tidak bisa membuka video.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorAccent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER
            Container(
              height: 210,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorConstant.colorPrimaryDark, ColorConstant.colorPrimary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: -10,
                    child: Icon(Icons.mosque,
                        size: 150,
                        color: ColorConstant.colorWhite.withValues(alpha: 0.12)),
                  ),
                  Positioned(
                    top: 36,
                    left: 8,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: ColorConstant.colorWhite),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_namaHeader,
                          style: TextStyle(
                              color: ColorConstant.colorWhite,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(_bismillah,
                          style: TextStyle(color: ColorConstant.colorGold, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. PILL NAMA PEMATERI
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorConstant.colorPrimary.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: ColorConstant.colorPrimary,
                          child: Icon(Icons.record_voice_over,
                              color: ColorConstant.colorWhite),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(kajian.pemateri,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstant.colorPrimaryDark)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 3. VIDEO (tap untuk membuka YouTube)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorConstant.colorWhite,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: ColorConstant.colorGold, width: 1.2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: InkWell(
                          onTap: () => _bukaVideo(context),
                          child: Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.center,
                            children: [
                              Image.network(
                                kajian.thumbnail,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Container(color: ColorConstant.colorPrimary),
                              ),
                              Center(
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: ColorConstant.colorPrimary.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.play_arrow,
                                      size: 40, color: ColorConstant.colorWhite),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(kajian.judul,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.colorPrimaryDark)),
                  const SizedBox(height: 8),
                  // 4. DESKRIPSI
                  Text(kajian.deskripsi,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          height: 1.5, color: ColorConstant.colorText)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
