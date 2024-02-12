import 'package:floor_billing/DRAWER/drawerPage.dart';
import 'package:floor_billing/SCREENs/ITEMDATA/itemAddPage.dart';
import 'package:floor_billing/SCREENs/ITEMDATA/viewcart.dart';
import 'package:floor_billing/components/custom_snackbar.dart';
import 'package:floor_billing/peridic_fun.dart';
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
  TextEditingController bagno = TextEditingController();
  TextEditingController itemname = TextEditingController();
  TextEditingController rate = TextEditingController();
  FocusNode cardfocus = FocusNode();
  FocusNode bagFocus = FocusNode();
  String _scanBarcode = 'Unknown';
  @override
  void initState() {
    super.initState();
    // FunctionUtils.runFunctionPeriodically(context);
    cardfocus.addListener(() {
      if (!cardfocus.hasFocus) {
        getCustdetails(cardno.text.toString());
      }
    });
    bagFocus.addListener(() {
      if (!bagFocus.hasFocus) {
        Provider.of<Controller>(context, listen: false)
            .setBagNo(bagno.text.toString());
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    // });
    date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  }

  getCustdetails(String cardno) async {
    Provider.of<Controller>(context, listen: false)
        .getCustData(cardno, context);
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
    cardfocus.removeListener(() {});
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 20),
        height: 70,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: Consumer<Controller>(
            builder: (context, value, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            textStyle: TextStyle(fontSize: 18)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewCartPage()),
                          );
                        },
                        icon: Icon(Icons.shopping_cart),
                        label: Text("VIEW CART"))
                  ],
                )),
      ),
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
                      focusNode: cardfocus,
                      controller: cardno,
                      onChanged: (val) {},
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Select Card Number';
                        }
                        return null;
                      },
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
                      focusNode: bagFocus,
                      controller: bagno,
                      onFieldSubmitted: (_) {
                        Provider.of<Controller>(context, listen: false)
                            .getBagDetails(bagno.text.toString(), context);
                      },
                      onChanged: (val) {},
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          Provider.of<Controller>(context, listen: false)
                              .setbagerror("Please Select Bag Number");
                        }
                        return null;
                      },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 50, width: 100, child: value.baggerror),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            if (bagno.text.toString().isEmpty ||
                                value.card_id.isEmpty) {
                              CustomSnackbar snackbar = CustomSnackbar();
                              snackbar.showSnackbar(
                                  context, "Please select Card & Bag ...", "");
                            } else {
                              print("card---->${value.card_id.toString()}");
                              print("bag---->${value.bag_no.toString()}");

                              Provider.of<Controller>(context, listen: false)
                                  .getItemDetails(
                                      context, value.bag_no.toString());
                              Provider.of<Controller>(context, listen: false)
                                  .getCart(context);
                              Provider.of<Controller>(context, listen: false)
                                  .setcusnameAndPhone(custname.text.toString(),
                                      custphon.text.toString(), context);
                              print(
                                  "namee------ ${custname.text.toString()},  phone---${custphon.text.toString()}");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ItemAddPage()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, bottom: 12),
                            child: Text(
                              "NEXT",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                          ),
                        ),
                      )
                    ],
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
          _scanBarcode = "";
          Provider.of<Controller>(context, listen: false)
              .getCustData(cardno.text.toString(), context);
        } else {
          bagno.text = _scanBarcode.toString();
          _scanBarcode = "";
          Provider.of<Controller>(context, listen: false)
              .getBagDetails(bagno.text.toString(), context);
        }
      });
    } on PlatformException {
      _scanBarcode = "hugugu";
    }
  }
}
