import 'package:floor_billing/DRAWER/drawerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:floor_billing/components/sizeScaling.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:floor_billing/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeFloorBill extends StatefulWidget {
  const HomeFloorBill({super.key});

  @override
  State<HomeFloorBill> createState() => _HomeFloorBillState();
}

class _HomeFloorBillState extends State<HomeFloorBill> {
  String? date;
  TextEditingController cardno = TextEditingController();
  TextEditingController custname = TextEditingController();
  TextEditingController custphon = TextEditingController();
  TextEditingController billno = TextEditingController();
  TextEditingController itemname = TextEditingController();
  TextEditingController rate = TextEditingController();
  FocusNode firstFocusNode = FocusNode();
  String _scanBarcode = 'Unknown';
  @override
  void initState() {
    super.initState();
    firstFocusNode.addListener(() {
      if (!firstFocusNode.hasFocus) {
        getCustdetails(cardno.text.toString());
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    // });
    date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  }

  getCustdetails(String cardno) async {
    Provider.of<Controller>(context, listen: false).getCustData(cardno);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cusname = prefs.getString("Cust_Name");
    String? cusfon = prefs.getString("Cust_Phone");
    if (cusname.toString().isNotEmpty &&
        cusname.toString() != " " &&
        cusname.toString() != "" &&
        cusname.toString() != "null" &&
        cusname != null) {
      custname.text = cusname.toString();
    }
    if (cusfon.toString().isNotEmpty &&
        cusfon.toString() != " " &&
        cusfon.toString() != "" &&
        cusfon.toString() != "null" &&
        cusfon != null) {
      custphon.text = cusfon.toString();
    }
    print("User clicked outside the Text Form Field");
  }

  @override
  void dispose() {
    firstFocusNode.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color.fromARGB(255, 220, 228, 111),
        title: Consumer<Controller>(
            builder: (BuildContext context, Controller value, Widget? child) =>
                Text(
                  value.cName.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )),
        actions: [
          Consumer<Controller>(
            builder: (BuildContext context, Controller value, Widget? child) {
              return Padding(
                padding: EdgeInsets.only(right: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        value.disply_name.toString().toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // IconButton(
          //   onPressed: () async {
          //     // List<Map<String, dynamic>> list =
          //     //     await KOT.instance.getListOfTables();
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) => TableList(list: list)),
          //     // );
          //   },
          //   icon: Icon(Icons.table_bar, color: Colors.green),
          // ),
        ],
      ),
      drawer: DrawerPage(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<Controller>(
          builder: (context, value, child) => Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      focusNode: firstFocusNode,
                      controller: cardno,
                      onChanged: (val) {},
                      decoration: InputDecoration(
                          errorBorder: UnderlineInputBorder(),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                scanBarcode("card");
                              }),
                          hintText: "Card Number"),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextFormField(
                      controller: custname,
                      onChanged: (val) {},
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          errorBorder: UnderlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                          hintText: "Customer Name"),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextFormField(
                      controller: custphon,
                      onChanged: (val) {},
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          errorBorder: UnderlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.blue,
                          ),
                          hintText: "Contact Number"),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      controller: billno,
                      onChanged: (val) {},
                      decoration: InputDecoration(
                          errorBorder: UnderlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              scanBarcode("bag");
                            },
                          ),
                          hintText: "Bag Number"),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextFormField(
                      controller: itemname,
                      onChanged: (val) {},
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          errorBorder: UnderlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.blue,
                          ),
                          hintText: "Item name"),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextFormField(
                      controller: rate,
                      onChanged: (val) {},
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          errorBorder: UnderlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.blue,
                          ),
                          hintText: "Rate"),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> scanBarcode(String field) async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (!mounted) return;
      setState(() {
        _scanBarcode = barcode;
        if (field == "card") {
          cardno.text = _scanBarcode.toString();
        } else {
          billno.text = _scanBarcode.toString();
        }
      });
    } on PlatformException {
      _scanBarcode = "hugugu";
    }
  }
}
