import 'package:bitaqwa/dashboard/color_constant.dart';
import 'package:flutter/material.dart';

// LAYAR ZAKAT (Tugas 2): kalkulator zakat maal dan zakat fitrah.
class ZakatScreen extends StatelessWidget {
  const ZakatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorConstant.colorWhite,
        appBar: AppBar(
          backgroundColor: ColorConstant.colorPrimary,
          foregroundColor: ColorConstant.colorWhite,
          title: const Text('Zakat'),
          centerTitle: true,
          bottom: TabBar(
            labelColor: ColorConstant.colorWhite,
            unselectedLabelColor: ColorConstant.colorAccent,
            indicatorColor: ColorConstant.colorGold,
            tabs: const [Tab(text: 'Zakat Maal'), Tab(text: 'Zakat Fitrah')],
          ),
        ),
        body: const TabBarView(children: [_MaalTab(), _FitrahTab()]),
      ),
    );
  }
}

double _num(TextEditingController c) =>
    double.tryParse(c.text.replaceAll('.', '').replaceAll(',', '.')) ?? 0;

String _rp(double v) {
  final s = v.round().toString();
  final out = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) out.write('.');
    out.write(s[i]);
  }
  return 'Rp $out';
}

Widget _field(TextEditingController c, String label, String hint, VoidCallback onChanged) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: c,
      keyboardType: TextInputType.number,
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

Widget _hasil(String judul, String isi, String catatan) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: ColorConstant.colorAccent,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: ColorConstant.colorGold),
    ),
    child: Column(
      children: [
        Text(judul, style: TextStyle(color: ColorConstant.colorText)),
        const SizedBox(height: 6),
        Text(isi,
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: ColorConstant.colorPrimaryDark)),
        const SizedBox(height: 6),
        Text(catatan,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: ColorConstant.colorText)),
      ],
    ),
  );
}

class _MaalTab extends StatefulWidget {
  const _MaalTab();
  @override
  State<_MaalTab> createState() => _MaalTabState();
}

class _MaalTabState extends State<_MaalTab> {
  final _harta = TextEditingController();
  final _hutang = TextEditingController();
  final _emas = TextEditingController();

  @override
  void dispose() {
    _harta.dispose();
    _hutang.dispose();
    _emas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void refresh() => setState(() {});
    final hargaEmas = _num(_emas);
    final nisab = 85 * hargaEmas; // nisab = 85 gram emas
    final bersih = _num(_harta) - _num(_hutang);

    Widget hasil;
    if (hargaEmas <= 0) {
      hasil = _hasil('Hasil', '-', 'Isi harga emas per gram hari ini untuk menghitung nisab.');
    } else if (bersih >= nisab) {
      hasil = _hasil('Zakat yang harus dibayar', _rp(bersih * 0.025),
          'Harta bersih ${_rp(bersih)} sudah mencapai nisab ${_rp(nisab)}. Tarif 2,5%.');
    } else {
      hasil = _hasil('Belum wajib zakat', _rp(0),
          'Harta bersih ${_rp(bersih)} belum mencapai nisab ${_rp(nisab)}.');
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _field(_harta, 'Total harta (tabungan, emas, dll)', 'contoh: 150000000', refresh),
        _field(_hutang, 'Hutang jatuh tempo', 'contoh: 0', refresh),
        _field(_emas, 'Harga emas per gram hari ini', 'cek harga terbaru', refresh),
        hasil,
        const SizedBox(height: 8),
        Text('Berlaku jika harta sudah dimiliki satu tahun (haul). Untuk kepastian, tanyakan ke BAZNAS/lembaga zakat setempat.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: ColorConstant.colorText)),
      ],
    );
  }
}

class _FitrahTab extends StatefulWidget {
  const _FitrahTab();
  @override
  State<_FitrahTab> createState() => _FitrahTabState();
}

class _FitrahTabState extends State<_FitrahTab> {
  final _jiwa = TextEditingController(text: '1');
  final _beras = TextEditingController();

  @override
  void dispose() {
    _jiwa.dispose();
    _beras.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void refresh() => setState(() {});
    final jiwa = _num(_jiwa);
    final harga = _num(_beras);
    final hasil = harga <= 0
        ? _hasil('Hasil', '-', 'Isi harga beras per kg yang kamu konsumsi.')
        : _hasil('Zakat fitrah', _rp(jiwa * 2.5 * harga),
            '${jiwa.round()} jiwa × 2,5 kg beras × ${_rp(harga)}/kg.');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _field(_jiwa, 'Jumlah jiwa', 'contoh: 4', refresh),
        _field(_beras, 'Harga beras per kg', 'cek harga terbaru', refresh),
        hasil,
        const SizedBox(height: 8),
        Text('Ukuran 2,5 kg per jiwa adalah patokan umum. Besaran resmi bisa berbeda per daerah, cek ketetapan BAZNAS setempat.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: ColorConstant.colorText)),
      ],
    );
  }
}
