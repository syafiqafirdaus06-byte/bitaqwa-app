import 'package:bitaqwa/dashboard/color_constant.dart';
import 'package:flutter/material.dart';

// LAYAR DOA HARIAN (Tugas 4): daftar doa yang bisa dibuka-tutup.
class DoaScreen extends StatelessWidget {
  const DoaScreen({super.key});

  // Tambahkan doa baru cukup dengan menambah satu baris di daftar ini.
  static const _doa = [
    _Doa('Sebelum makan', 'بِسْمِ اللَّهِ', 'Dengan nama Allah.'),
    _Doa('Sesudah makan', 'الْحَمْدُ لِلَّهِ', 'Segala puji bagi Allah.'),
    _Doa('Sebelum tidur', 'بِاسْمِكَ اللَّهُمَّ أَحْيَا وَبِاسْمِكَ أَمُوتُ',
        'Dengan nama-Mu ya Allah aku hidup dan aku mati.'),
    _Doa('Sebelum belajar', 'رَبِّ زِدْنِي عِلْمًا',
        'Ya Tuhanku, tambahkanlah ilmu kepadaku.'),
    _Doa('Keluar rumah', 'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ',
        'Dengan nama Allah, aku bertawakal kepada Allah.'),
    _Doa(
        'Kebaikan dunia dan akhirat',
        'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
        'Ya Tuhan kami, berilah kami kebaikan di dunia dan kebaikan di akhirat, dan lindungilah kami dari azab neraka.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      appBar: AppBar(
        backgroundColor: ColorConstant.colorPrimary,
        foregroundColor: ColorConstant.colorWhite,
        title: const Text('Doa-doa'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final d in _doa)
            Card(
              elevation: 0,
              color: ColorConstant.colorAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ExpansionTile(
                shape: const Border(),
                iconColor: ColorConstant.colorPrimaryDark,
                title: Text(d.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: ColorConstant.colorText)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Text(d.arab,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 28, color: ColorConstant.colorPrimaryDark)),
                  const SizedBox(height: 8),
                  Text(d.arti,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ColorConstant.colorText)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Doa {
  final String title;
  final String arab;
  final String arti;
  const _Doa(this.title, this.arab, this.arti);
}
