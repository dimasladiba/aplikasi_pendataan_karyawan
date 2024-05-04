class Karyawan {
  final int id;
  final String nama;
  final String alasan;
  final String keterangan;
  final String tanggal;

  Karyawan(
      {required this.id,
      required this.nama,
      required this.alasan,
      required this.keterangan,
      required this.tanggal});

  factory Karyawan.fromJSON(Map<String, dynamic> data) => Karyawan(
      id: data["id"],
      nama: data["nama"],
      alasan: data["alasan"],
      keterangan: data["keterangan"],
      tanggal: data["tanggal"]);
}
