import 'dart:io';

import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resign_record_app/helper/database.dart';
import 'package:resign_record_app/presentation/page/input_page.dart';
import 'package:resign_record_app/presentation/page/report_page.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rekab Karyawan Resign',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Rekab Karyawan Resign'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Map<String, dynamic>> listData = [];
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void laodData() async {
    Database db = await MyDatabase.openDB();
    List<String> jenis = <String>[
      'Meninggal',
      'Pensiun Alami',
      'Diterima ASN',
      'Diterima Perusahaan Lain',
      'Alasan Keluarga',
      'Lainnya'
    ];
    List<Map<String, dynamic>> data = await db.rawQuery(
        "SELECT jenis, tahun, COUNT(*) AS jumlah_resign FROM data_resign  GROUP BY jenis");
    List<Map<String, dynamic>> list = [];
    if (jenis.isNotEmpty) {
      for (var e in jenis) {
        print('$e');
        String query =
            "select tahun, COUNT(*) AS jumlah_resign from data_resign where jenis ='$e' group by tahun ";
        List a = await db.rawQuery(query);

        list.add({"jenis": e, "data": a});
      }
    }
    print(list);
    setState(() {
      listData = list;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    laodData();
  }

  convert() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage].request();

    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    row.add("Uraian");
    row.add("2024");
    row.add("2023");
    row.add("2022");
    row.add("2021");

    rows.add(row);
    for (int i = 0; i < listData.length; i++) {
      List<dynamic> row = [];
      row.add(listData[i]["jenis"]);
      for (var e in listData[i]["data"]) {
        if (e["tahun"].toString() == "2024") {
          row.add(e["jumlah_resign"]);
        }
        if (e["tahun"].toString() == 2023) {
          row.add(e["jumlah_resign"]);
        }
        if (e["tahun"].toString() == 2022) {
          row.add(e["jumlah_resign"]);
        }
        if (e["tahun"].toString() == 2021) {
          row.add(e["jumlah_resign"]);
        }
        print(row);
      }
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);

    String dir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    print("dir $dir");
    String file = "$dir" + "/data_karyawan_resign.csv";

    File f = File(file);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(file),
    ));
    f.writeAsString(csv);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                convert();
              },
              icon: Icon(Icons.data_exploration_outlined))
        ],
      ),
      body: ListView.builder(
          itemCount: listData.length,
          itemBuilder: (c, i) {
            var b = listData[i];
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ReportPage(jenis: b["jenis"]))).then((value) {});
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b["jenis"]),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: b["data"].length,
                          itemBuilder: (c, i) {
                            var d = b["data"][i];
                            return Row(
                              children: [
                                Text(
                                  d["tahun"] + ": ",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  d["jumlah_resign"].toString(),
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ],
                            );
                          })
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const InputPage()))
              .then((value) {
            laodData();
          });
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
