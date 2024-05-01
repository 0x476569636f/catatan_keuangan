//BluePrint DataBase
class ModelDb {
  int? id;
  String? tipe;
  String? keterangan;
  String? jumlahUang;
  String? tanggal;

  ModelDb({this.id, this.tipe, this.keterangan, this.jumlahUang, this.tanggal});

  //Mengubah objek ke dalam bentuk map
  Map<String, dynamic> toMap() {
    //membuat collection_ilaterals untuk menampung data
    var map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['tipe'] = tipe;
    map['keterangan'] = keterangan;
    map['jumlahUang'] = jumlahUang;
    map['tanggal'] = tanggal;

    return map;
  }

  //membuat objek ModelDb dari map yang berisi data dari database
  ModelDb.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.tipe = map['tipe'];
    this.keterangan = map['keterangan'];
    this.jumlahUang = map['jumlahUang'];
    this.tanggal = map['tanggal'];
  }
}
