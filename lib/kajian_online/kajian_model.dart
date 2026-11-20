// MODEL KAJIAN: satu video kajian = satu objek ini.
class KajianVideo {
  final String judul;
  final String pemateri;
  final String kategori;
  final String youtubeId; // bagian setelah "watch?v=" pada link YouTube
  final String deskripsi;

  const KajianVideo({
    required this.judul,
    required this.pemateri,
    required this.kategori,
    required this.youtubeId,
    required this.deskripsi,
  });

  String get thumbnail => 'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';
  String get url => 'https://www.youtube.com/watch?v=$youtubeId';
}
