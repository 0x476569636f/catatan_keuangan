// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:catatan_keuangan/model/model_db.dart';
import 'package:catatan_keuangan/database/database_helper.dart';

class PageInputPemasukan extends StatefulWidget {
  final ModelDb? modelDatabase;

  const PageInputPemasukan({super.key, this.modelDatabase});

  @override
  // ignore: library_private_types_in_public_api
  _PageInputPemasukanState createState() => _PageInputPemasukanState();
}

class _PageInputPemasukanState extends State<PageInputPemasukan> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  TextEditingController? keterangan;
  TextEditingController? tanggal;
  TextEditingController? jumlahUang;

  @override
  void initState() {
    keterangan = TextEditingController(
        text: widget.modelDatabase == null
            ? ''
            : widget.modelDatabase!.keterangan);
    tanggal = TextEditingController(
        text:
            widget.modelDatabase == null ? '' : widget.modelDatabase!.tanggal);
    jumlahUang = TextEditingController(
        text: widget.modelDatabase == null
            ? ''
            : widget.modelDatabase!.jumlahUang);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.orange,
        title: const Text('Form Data Pemasukan',
            style: TextStyle(fontSize: 14, color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            controller: keterangan,
            decoration: InputDecoration(
                labelText: 'Keterangan',
                labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.datetime,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                              onPrimary: Colors.white,
                              onBackground: Colors.white),
                          datePickerTheme: const DatePickerThemeData(
                            headerBackgroundColor: Colors.orange,
                            backgroundColor: Colors.white,
                            headerForegroundColor: Colors.white,
                            surfaceTintColor: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(9999));
                if (pickedDate != null) {
                  tanggal!.text = DateFormat('dd MMM yyyy').format(pickedDate);
                }
              },
              controller: tanggal,
              decoration: InputDecoration(
                  labelText: 'Tanggal',
                  labelStyle:
                      const TextStyle(fontSize: 14, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              controller: jumlahUang,
              decoration: InputDecoration(
                  labelText: 'Jumlah Uang',
                  labelStyle:
                      const TextStyle(fontSize: 14, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: size.width,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.orange),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (keterangan!.text.toString() == '' ||
                          tanggal!.text.toString() == '' ||
                          jumlahUang!.text.toString() == '') {
                        const snackBar = SnackBar(
                            content:
                                Text("Ups, form tidak boleh ada yang kosong!"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        upsertData();
                      }
                    },
                    child: Center(
                      child: (widget.modelDatabase == null)
                          ? const Text(
                              'Tambah Data',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            )
                          : const Text(
                              'Update Data',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> upsertData() async {
    if (widget.modelDatabase != null) {
      //update
      await databaseHelper.updateDataPemasukan(ModelDb.fromMap({
        'id': widget.modelDatabase!.id,
        'tipe': 'pemasukan',
        'keterangan': keterangan!.text,
        'jumlahUang': jumlahUang!.text,
        'tanggal': tanggal!.text
      }));
      Navigator.pop(context, 'update');
    } else {
      //insert
      await databaseHelper.saveData(ModelDb(
        tipe: 'pemasukan',
        keterangan: keterangan!.text,
        jumlahUang: jumlahUang!.text,
        tanggal: tanggal!.text,
      ));
      Navigator.pop(context, 'save');
    }
  }
}
