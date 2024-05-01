import 'package:flutter/material.dart';
import 'package:catatan_keuangan/model/model_db.dart';
import 'package:catatan_keuangan/database/database_helper.dart';
import 'package:catatan_keuangan/helpers/format_rupiah.dart';
import 'package:catatan_keuangan/ui/pengeluaran/page_input_pengeluaran.dart';

class PagePengeluaran extends StatefulWidget {
  const PagePengeluaran({super.key});

  @override
  State<PagePengeluaran> createState() => _PagePengeluaranState();
}

class _PagePengeluaranState extends State<PagePengeluaran> {
  List<ModelDb> listPemasukan = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  int strJmlUang = 0;
  int strCheckDatabase = 0;

  @override
  void initState() {
    super.initState();
    getDatabase();
    getJmlUang();
    getAllData();
  }

  //cek database ada data atau tidak
  Future<void> getDatabase() async {
    var checkDB = await databaseHelper.cekDataPengeluaran();
    setState(() {
      if (checkDB == 0) {
        strCheckDatabase = 0;
        strJmlUang = 0;
      } else {
        strCheckDatabase = checkDB!;
      }
    });
  }

  //cek jumlah total uang
  Future<void> getJmlUang() async {
    var checkJmlUang = await databaseHelper.getJmlPengeluaran();
    setState(() {
      if (checkJmlUang == 0) {
        strJmlUang = 0;
      } else {
        strJmlUang = checkJmlUang;
      }
    });
  }

  //get data untuk menampilkan ke listview
  Future<void> getAllData() async {
    var listData = await databaseHelper.getDataPengeluaran();
    setState(() {
      listPemasukan.clear();
      for (var kontak in listData!) {
        listPemasukan.add(ModelDb.fromMap(kontak));
      }
    });
  }

  //untuk hapus data berdasarkan Id
  Future<void> deleteData(ModelDb modelDatabase, int position) async {
    await databaseHelper.deleteDataPengeluaran(modelDatabase.id!);
    setState(() {
      getJmlUang();
      getDatabase();
      listPemasukan.removeAt(position);
    });
  }

  //untuk insert data baru
  Future<void> openFormCreate() async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const PageInputPengeluaran()));
    if (result == 'save') {
      await getAllData();
      await getJmlUang();
      await getDatabase();
    }
  }

  //untuk edit data
  Future<void> openFormEdit(ModelDb modelDatabase) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PageInputPengeluaran(modelDatabase: modelDatabase)));
    if (result == 'update') {
      await getAllData();
      await getJmlUang();
      await getDatabase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(10),
              clipBehavior: Clip.antiAlias,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: ListTile(
                title: const Text('Total Pengeluaran Bulan Ini',
                    style: TextStyle(fontSize: 14, color: Colors.black)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(CurrencyFormat.convertToIdr(strJmlUang),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
              ),
            ),
            strCheckDatabase == 0
                ? Container(
                    padding: const EdgeInsets.only(top: 200),
                    child: const Text(
                        'Ups, belum ada pengeluaran.\nYuk catat pengeluaran Kamu!',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)))
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listPemasukan.length,
                    itemBuilder: (context, index) {
                      ModelDb modeldatabase = listPemasukan[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        clipBehavior: Clip.antiAlias,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.white,
                        child: ListTile(
                          title: Text('${modeldatabase.keterangan}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                ),
                                child: Text(
                                    'Jumlah Uang: ${CurrencyFormat.convertToIdr(int.parse(modeldatabase.jumlahUang.toString()))}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Text('Tanggal: ${modeldatabase.tanggal}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black)),
                              ),
                            ],
                          ),
                          trailing: FittedBox(
                            fit: BoxFit.fill,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      openFormEdit(modeldatabase);
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    )),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    AlertDialog hapus = AlertDialog(
                                      title: const Text('Hapus Data',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black)),
                                      content: const SizedBox(
                                        height: 20,
                                        child: Column(
                                          children: [
                                            Text(
                                                'Yakin ingin menghapus data ini?',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black))
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              deleteData(modeldatabase, index);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Ya',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black))),
                                        TextButton(
                                          child: const Text('Tidak',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                    showDialog(
                                        context: context,
                                        builder: (context) => hapus);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          openFormCreate();
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Pengeluaran',
          style: TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
