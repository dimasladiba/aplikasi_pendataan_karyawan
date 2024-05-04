import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resign_record_app/helper/database.dart';
import 'package:sqflite/sqflite.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  static const List<String> jenis = <String>[
    'Meninggal',
    'Pensiun Alami',
    'Diterima ASN',
    'Diterima Perusahaan Lain',
    'Alasan Keluarga',
    'Lainnya'
  ];
  String dropdownValue = jenis.first;

  String date = "Pilih tanggal";
  TextEditingController txtNama = TextEditingController();
  TextEditingController txtAlasan = TextEditingController();
  TextEditingController txtDate = TextEditingController();

  showDate() async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime(1900, 10, 10),
        lastDate: DateTime(2050, 10, 10));
    if (date != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      txtDate.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Data"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: txtNama,
              decoration: InputDecoration(hintText: "Nama"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              // elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: jenis.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: txtAlasan,
              decoration: InputDecoration(hintText: "Alasan"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onTap: () {
                showDate();
              },
              controller: txtDate,
              readOnly: true,
              decoration: InputDecoration(hintText: "Pilih tanggal"),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                Database db = await MyDatabase.openDB();
                String tahun = txtDate.text.split("-")[0];
                Random random = Random();
                int randomNumber1 = random.nextInt(10);
                String query =
                    "INSERT INTO data_resign(nama, alasan, jenis, tanggal, tahun) VALUES('${txtNama.text}','${txtAlasan.text}','$dropdownValue','${txtDate.text}','${tahun}')";
                print(query);

                var a = await db.insert("data_resign", {
                  "nama": txtNama.text,
                  "alasan": txtAlasan.text,
                  "jenis": dropdownValue,
                  "tanggal": txtDate.text,
                  "tahun": tahun
                });
                await db.close();
                Navigator.pop(context);
              },
              child: Text("Simpan"))
        ],
      ),
    );
  }
}
