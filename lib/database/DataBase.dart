import 'package:catatan_keuangan/model/model_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBase {
  static final DataBase _instance = DataBase._internal();
  static DataBase? _database;

  //inisialisasi
  final String tableName = 'tbl_keuangan';
  final String columnId = 'id';
  final String columnTipe = 'tipe';
  final String columnKet = 'keterangan';
  final String columnJumlahUang = 'jumlahUang';
  final String columnTgl = 'tanggal';

  DataBase._internal();
  factory DataBase() => _instance;

  //Mengecek Apakah DataBase Sudah Ada
  Future<Database?> get checkDb async {
    if (_database != null) {
      return _database;
    }
    // Jika belum ada panggil fungsi _initDB()
    _database = await _initDB();
    return _database;
  }

  Future<Database?> _initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'keuangan.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //Membuat tabel dan kolom"nya
  Future<void> _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, "
        "$columnTipe TEXT,"
        "$columnKet TEXT,"
        "$columnJumlahUang TEXT,"
        "$columnTgl TEXT)";
    await db.execute(sql);
  }
}
