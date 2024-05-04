import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../helper/database.dart';

class ReportPage extends StatefulWidget {
  final String jenis;

  const ReportPage({super.key, required this.jenis});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<Map> listData = [];
  void laodData() async {
    Database db = await MyDatabase.openDB();

    List<Map<String, dynamic>> data = await db
        .rawQuery("SELECT * from data_resign where  jenis='${widget.jenis}'");
    print(data);
    setState(() {
      listData = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    laodData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Karyawan Resign"),
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.data_exploration_outlined))
        ],
      ),
      body: ListView.builder(
          itemCount: listData.length,
          itemBuilder: (c, i) {
            var data = listData[i];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nama: " + data["nama"],
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Alasan: " + data["alasan"],
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Tahun: " + data["tahun"],
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
