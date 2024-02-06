
import 'package:path/path.dart';
import 'package:floor_billing/MODEL/registration_model.dart';

import 'package:sqflite/sqflite.dart';

class BILLING {
  static final BILLING instance = BILLING._init();
  static Database? _database;
  BILLING._init();
  //////////////////////////////////////

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("BILLING.db");
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return await openDatabase(
      path,
      version: 1, onCreate: _createDB,
      // onUpgrade: _upgradeDB
    );
  }

  Future _createDB(Database db, int version) async {
    ///////////////barcode store table ////////////////
    await db.execute('''
          CREATE TABLE companyRegistrationTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cid TEXT NOT NULL,
            fp TEXT NOT NULL,
            os TEXT NOT NULL,
            type TEXT,
            app_type TEXT,
            cpre TEXT,
            ctype TEXT,
            cnme TEXT,
            ad1 TEXT,
            ad2 TEXT,
            ad3 TEXT,
            pcode TEXT,
            land TEXT,
            mob TEXT,
            em TEXT,
            gst TEXT,
            ccode TEXT,
            scode TEXT,
            msg TEXT
          )
          ''');
           await db.execute('''
          CREATE TABLE custDetailsTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cardnum TEXT NOT NULL,
            custname TEXT NOT NULL,
            contact TEXT NOT NULL,
            billid TEXT NOT NULL
          )
          ''');

  }


/////////////////////////////////////////////////////////////////////////
  Future insertRegistrationDetails(RegistrationData data) async {
    final db = await database;
    var query1 =
        'INSERT INTO companyRegistrationTable(cid, fp, os, type, app_type, cpre, ctype, cnme, ad1, ad2, ad3, pcode, land, mob, em, gst, ccode, scode, msg) VALUES("${data.cid}", "${data.fp}", "${data.os}","${data.type}","${data.apptype}","${data.c_d![0].cpre}", "${data.c_d![0].ctype}", "${data.c_d![0].cnme}", "${data.c_d![0].ad1}", "${data.c_d![0].ad2}", "${data.c_d![0].ad3}", "${data.c_d![0].pcode}", "${data.c_d![0].land}", "${data.c_d![0].mob}", "${data.c_d![0].em}", "${data.c_d![0].gst}", "${data.c_d![0].ccode}", "${data.c_d![0].scode}", "${data.msg}" )';
    var res = await db.rawInsert(query1);
    print(query1);
    print("registered ----$res");
    return res;
  }

////////////////////////////////////////////////////////////////////////////////
   deleteFromTableCommonQuery(String table, String? condition) async {
    // ignore: avoid_print
    print("table--condition -$table---$condition");
    Database db = await instance.database;
    if (condition == null || condition.isEmpty || condition == "") {
      // ignore: avoid_print
      print("no condition");
      await db.delete('$table');
    } else {
      // ignore: avoid_print
      print("condition");

      await db.rawDelete('DELETE FROM "$table" WHERE $condition');
    }
  }

///////////////////////////////////////////////////////////////////////////////
  selectCommonQuery(String table, String? condition, String fields) async {
    List<Map<String, dynamic>> result;
    Database db = await instance.database;
    var query = "SELECT $fields FROM '$table' $condition";
    result = await db.rawQuery(query);
    print("naaknsdJK-----$result");
    return result;
  }

  ///////////////////////////////////////////////////////////////////////////
  updateCommonQuery(String table, String fields, String condition) async {
    Database db = await instance.database;
    var query = 'UPDATE $table SET $fields $condition ';
    var res = await db.rawUpdate(query);
    return res;
  }

  /////////////////////////////////////////////////////////////
  getListOfTables() async {
    Database db = await instance.database;
    var list = await db.query('sqlite_master', columns: ['type', 'name']);
    print(list);
    list.map((e) => print(e["name"])).toList();
    return list;
    // list.forEach((row) {
    //   print(row.values);
    // });
  }

  getTableData(String tablename) async {
    Database db = await instance.database;
    print(tablename);
    var list = await db.rawQuery('SELECT * FROM $tablename');
    print(list);
    return list;
   
  }

  ///////////////////////////................................///////////////////////////////////////
  


}
