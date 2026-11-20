import 'package:bitaqwa/dashboard/color_constant.dart';
import 'package:bitaqwa/kajian_online/kajian_data.dart';
import 'package:bitaqwa/kajian_online/kajian_detail_screen.dart';
import 'package:bitaqwa/kajian_online/kajian_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// LAYAR VIDEO KAJIAN (Tugas 3): pencarian, favorit, dan riwayat yang tersimpan.
class VideoKajianScreen extends StatefulWidget {
  const VideoKajianScreen({super.key});

  @override
  State<VideoKajianScreen> createState() => _VideoKajianScreenState();
}

class _VideoKajianScreenState extends State<VideoKajianScreen> {
  bool _loading = true;
  String? _error;
  String _filter = 'Semua';
  String _query = '';
  Set<String> _fav = {};
  List<String> _riwayat = [];

  @override
  void initState() {
    super.initState();
    _muat();
  }

  Future<void> _muat() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      _fav = (prefs.getStringList('fav_kajian') ?? []).toSet();
      _riwayat = prefs.getStringList('riwayat_kajian') ?? [];
    } catch (e) {
      _error = 'Gagal memuat data tersimpan.';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _simpan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('fav_kajian', _fav.toList());
    await prefs.setStringList('riwayat_kajian', _riwayat);
  }

  void _toggleFav(KajianVideo k) {
    setState(() {
      if (!_fav.remove(k.youtubeId)) _fav.add(k.youtubeId);
    });
    _simpan();
  }

  void _buka(KajianVideo k) {
    _riwayat.remove(k.youtubeId);
    _riwayat.insert(0, k.youtubeId);
    if (_riwayat.length > 10) _riwayat = _riwayat.sublist(0, 10);
    _simpan();
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => KajianDetailScreen(kajian: k)));
  }

  List<KajianVideo> get _items {
    var list = daftarKajian.toList();
    if (_filter == 'Favorit') {
      list = list.where((k) => _fav.contains(k.youtubeId)).toList();
    } else if (_filter == 'Riwayat') {
      list = [
        for (final id in _riwayat)
          ...daftarKajian.where((k) => k.youtubeId == id)
      ];
    } else if (_filter != 'Semua') {
      list = list.where((k) => k.kategori == _filter).toList();
    }
    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where((k) =>
              k.judul.toLowerCase().contains(q) || k.pemateri.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  Widget _info(IconData icon, String teks, {VoidCallback? ulang}) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: ColorConstant.colorPrimary),
              const SizedBox(height: 12),
              Text(teks,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ColorConstant.colorText)),
              if (ulang != null)
                TextButton(onPressed: ulang, child: const Text('Coba lagi')),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Semua',
      'Favorit',
      'Riwayat',
      ...{for (final k in daftarKajian) k.kategori}
    ];

    Widget isi;
    if (_loading) {
      isi = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      isi = _info(Icons.error_outline, _error!, ulang: _muat);
    } else if (_items.isEmpty) {
      isi = _info(
          Icons.search_off,
          _filter == 'Favorit'
              ? 'Belum ada favorit. Ketuk ikon hati pada kajian.'
              : _filter == 'Riwayat'
                  ? 'Belum ada kajian yang dibuka.'
                  : 'Kajian tidak ditemukan.');
    } else {
      isi = ListView(
        padding: const EdgeInsets.all(16),
        children: [for (final k in _items) _kartu(k)],
      );
    }

    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      appBar: AppBar(
        backgroundColor: ColorConstant.colorPrimary,
        foregroundColor: ColorConstant.colorWhite,
        title: const Text('Video Kajian'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Cari judul atau pemateri',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                for (final c in categories)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: _filter == c,
                      selectedColor: ColorConstant.colorPrimary,
                      labelStyle: TextStyle(
                          color: _filter == c
                              ? ColorConstant.colorWhite
                              : ColorConstant.colorText),
                      onSelected: (_) => setState(() => _filter = c),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(child: isi),
        ],
      ),
    );
  }

  Widget _kartu(KajianVideo k) {
    final fav = _fav.contains(k.youtubeId);
    return Card(
      elevation: 0,
      color: ColorConstant.colorAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _buka(k),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 110,
                  height: 70,
                  child: Image.network(
                    k.thumbnail,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, p) => p == null
                        ? child
                        : Container(
                            color: ColorConstant.colorPrimary.withValues(alpha: 0.15),
                            child: const Center(
                                child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2)))),
                    errorBuilder: (_, __, ___) => Container(
                      color: ColorConstant.colorPrimary,
                      child: Icon(Icons.play_arrow, color: ColorConstant.colorWhite),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(k.judul,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: ColorConstant.colorText)),
                    const SizedBox(height: 4),
                    Text('${k.pemateri} • ${k.kategori}',
                        style: TextStyle(fontSize: 12, color: ColorConstant.colorText)),
                  ],
                ),
              ),
              IconButton(
                tooltip: fav ? 'Hapus dari favorit' : 'Tambah ke favorit',
                icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
                    color: ColorConstant.colorPrimary),
                onPressed: () => _toggleFav(k),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
