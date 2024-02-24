import 'dart:io';

import 'package:floor_billing/DRAWER/drawerPage.dart';
import 'package:floor_billing/SCREENs/FLOORBILL/deliverybill.dart';
import 'package:floor_billing/SCREENs/FLOORBILL/floorBill.dart';

import 'package:floor_billing/SCREENs/ITEMDATA/bagwise_items.dart';
import 'package:floor_billing/SCREENs/ITEMDATA/itemAddPage.dart';
import 'package:floor_billing/SCREENs/ITEMDATA/viewcart.dart';
import 'package:floor_billing/components/custom_snackbar.dart';
import 'package:floor_billing/main.dart';
import 'package:floor_billing/peridic_fun.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:floor_billing/components/sizeScaling.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:floor_billing/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;

class HomeFloorBill extends StatefulWidget {

  
  const HomeFloorBill({super.key});

  @override
  State<HomeFloorBill> createState() => _HomeFloorBillState();
}

class _HomeFloorBillState extends State<HomeFloorBill> {
  String date = "";
  final _formKey = GlobalKey<FormState>();
  // TextEditingController cardno = TextEditingController();
  // TextEditingController custname = TextEditingController();
  // TextEditingController custphon = TextEditingController();
  TextEditingController bagno = TextEditingController();
  TextEditingController itemname = TextEditingController();
  TextEditingController rate = TextEditingController();
  FocusNode cardfocus = FocusNode();
  FocusNode bagFocus = FocusNode();
  FocusNode fonfocus = FocusNode();
  String _scanBarcode = 'Unknown';
  String ep = "";
String cn="";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    getcname();
    Provider.of<Controller>(context, listen: false).clearCardID("0");
    Provider.of<Controller>(context, listen: false)
        .cardNoctrl.clear();
    Provider.of<Controller>(context, listen: false).userAddButtonDisable(false);
    // FunctionUtils.runFunctionPeriodically(context);
    
    cardfocus.addListener(() {
      if (!cardfocus.hasFocus) {
        getCustdetails(Provider.of<Controller>(context, listen: false)
            .cardNoctrl
            .text
            .toString());
      }
    });
    bagFocus.addListener(() {
      if (!bagFocus.hasFocus) {
        Provider.of<Controller>(context, listen: false).setcusnameAndPhone(
            Provider.of<Controller>(context, listen: false).ccname.text,
            Provider.of<Controller>(context, listen: false).ccfon.text,
            context);
        Provider.of<Controller>(context, listen: false)
            .getBagDetails(bagno.text.toString(), context, "home");
        Provider.of<Controller>(context, listen: false)
            .setBagNo(bagno.text.toString(), context);
      }
    });});
    // fonfocus.addListener(() {
    //   if (Provider.of<Controller>(context, listen: false).ccfon.text.length !=
    //       10)
    //   {
    //     CustomSnackbar snackbar = CustomSnackbar();
    //     snackbar.showSnackbar(context, "Enter valid contact...", "");
    //   }
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    // });
    date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  }

  getCustdetails(String cardno) async {
    Provider.of<Controller>(context, listen: false)
        .getCustData(date, cardno, context);

    setState(() {});
    print("User clicked outside the Text Form Field");
  }

  @override
  void dispose() {
    cardfocus.removeListener(() {});
    bagFocus.removeListener(() {});
    fonfocus.removeListener(() {});
    super.dispose();
  }
getcname()
async {
 final SharedPreferences prefs = await SharedPreferences.getInstance();
 
  cn = prefs.getString("cname")!;
}
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          Navigator.of(context).pop(true);
          Navigator.pushNamed(context, '/mainpage');
        }
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Color.fromARGB(255, 220, 228, 111),
          title: Consumer<Controller>(
              builder:
                  (BuildContext context, Controller value, Widget? child) =>
                      Text(
                        cn.toString(),
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
        bottomNavigationBar: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) {
            return Container(
                padding: EdgeInsets.only(bottom: 5),
                height: 80,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: value.usedbagList.length == 0 || value.card_id == "0"
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: value.usedbagList.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Row(
                                                children: [
                                                  badges.Badge(
                                                    badgeStyle:
                                                        badges.BadgeStyle(
                                                            badgeColor:
                                                                Colors.black),
                                                    position:
                                                        badges.BadgePosition
                                                            .topEnd(
                                                                top: -5,
                                                                end: -10),
                                                    showBadge: true,
                                                    badgeContent: Text(
                                                      value.usedbagList[index]
                                                              ["Cnt"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    child: OutlinedButton(
                                                        onPressed: () {
                                                          Provider.of<Controller>(
                                                                  context,
                                                                  listen: false)
                                                              .getUsedBagsItems(
                                                                  context,
                                                                  date
                                                                      .toString(),
                                                                  value.usedbagList[
                                                                          index]
                                                                      [
                                                                      "Slot_Id"]);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => BagwiseItems(
                                                                    cardNumbr: value
                                                                        .cardNoctrl
                                                                        .text
                                                                        .toString())),
                                                          );
                                                        },
                                                        child: Text(value
                                                            .usedbagList[index]
                                                                ["Slot_Name"]
                                                            .toString()
                                                            .trimLeft())),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: badges.Badge(
                                      badgeStyle: badges.BadgeStyle(
                                          badgeColor: Colors.black),
                                      position: badges.BadgePosition.topEnd(
                                          top: -5, end: -10),
                                      showBadge: true,
                                      badgeContent: Text(
                                        value.allbagallcount.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      child: OutlinedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.orangeAccent)),
                                          onPressed: () {
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .getUsedBagsItems(context,
                                                    date.toString(), 0);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BagwiseItems(
                                                        cardNumbr: value
                                                            .cardNoctrl.text
                                                            .toString(),
                                                      )),
                                            );
                                          },
                                          child: Text("All")),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 190, 139, 199),
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.all(3),
                                height: 30,
                                child: Text(
                                  "FBills: ${value.usedbagList[0]["FBills"].toString()}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            )
                            // Container(height: 20,width: size.width,
                            // )
                          ],
                        ),
                      ));
          },
        ),
        body: Consumer<Controller>(
          builder: (context, value, child) => Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                          ),
                          Text(
                            date.toString(),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Image.asset(
                              "assets/bill.png",
                              height: 40,
                              width: 30,
                            ),
                            onPressed: () {
                              Provider.of<Controller>(context, listen: false)
                                  .getFBList(date.toString(), context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FloorBill()),
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 45,
                        width: size.width / 1.3,
                        child: TextFormField(
                          ignorePointers: value.showadduser ? true : false,
                          focusNode: cardfocus,
                          controller: value.cardNoctrl,
                          onChanged: (val) {},
                          validator: (text) {
                            // if (text == null || text.isEmpty) {
                            //   return 'Please Select Card Number';
                            // }
                            // return null;
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: new Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    Provider.of<Controller>(context,
                                            listen: false)
                                        .clearCardID("0");
                                    bagno.clear();
                                  });
                                },
                              ),
                              errorBorder: UnderlineInputBorder(),
                              // suffixIcon: IconButton(
                              //     icon: Icon(Icons.search),
                              //     onPressed: () {

                              //     }),
                              hintText: "Card Number"),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      IconButton(
                        icon: Image.asset(
                          "assets/barscan.png",
                          height: 40,
                          width: 30,
                        ),
                        onPressed: () {
                          scanBarcode("card");
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 45,
                    width: size.width / 1.1,
                    child: TextFormField(
                      focusNode: fonfocus,
                      // ignorePointers: value.typlock?true:false,
                      onFieldSubmitted: (value) {
                        if (value.length != 10) {
                          CustomSnackbar snackbar = CustomSnackbar();
                          snackbar.showSnackbar(
                              context, "Enter valid contact...", "");
                        }
                      },
                      keyboardType: TextInputType.phone,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Phone Number';
                        } else if (text.length != 10) {
                          return 'Please Enter Valid Phone No ';
                        }
                        return null;
                      },
                      controller: value.ccfon,
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
                    height: 15,
                  ),
                  SizedBox(
                    height: 45,
                    width: size.width / 1.1,
                    child: TextFormField(
                      // ignorePointers: value.typlock?true:false,
                      controller: value.ccname,
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
                  value.adduserError,
                  const SizedBox(
                    height: 10,
                  ),
                  value.showadduser
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (value.ccname.text == "" ||
                                    value.ccfon.text == "" ) {
                                  ep = "Please enter Name & Contact";
                                  value.setaDDUserError(
                                      "Please enter Name & Contact");
                                }
                                
                                 else {
                                  value.createFloorCardsNew(
                                      date,
                                      value.ccname.text,
                                      value.ccfon.text,
                                      context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      "NEW",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Theme.of(context)
                                              .secondaryHeaderColor),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Image.asset(
                                      "assets/name.png",
                                      color: Colors.black,
                                      height: 20,
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              child: IconButton(
                                  onPressed: () {
                                    value.userAddButtonDisable(false);
                                    value.ccfon.clear();
                                    value.ccname.clear();
                                    value.card_id = "";
                                    value.setaDDUserError("");
                                    Provider.of<Controller>(context,
                                            listen: false)
                                        .clearCardID("0");
                                  },
                                  icon: Icon(Icons.refresh)),
                            )
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 45,
                        width: 230,
                        child: TextFormField(
                          ignorePointers: value.igno
                              ? true
                              : false,
                          focusNode: bagFocus,
                          controller: bagno,
                          onFieldSubmitted: (_) {
                            Provider.of<Controller>(context, listen: false)
                                .setcusnameAndPhone(value.ccname.text,
                                    value.ccfon.text, context);
                            Provider.of<Controller>(context, listen: false)
                                .getBagDetails(
                                    bagno.text.toString(), context, "home");
                          },
                          onChanged: (val) {},
                          // validator: (text) {
                          //   if (text == null || text.isEmpty) {
                          //     Provider.of<Controller>(context, listen: false)
                          //         .setbagerror("Please Select Bag Number");
                          //   }
                          //   return null;
                          // },
                          decoration: InputDecoration(
                              errorBorder: UnderlineInputBorder(),
                              hintText: "Bag/Slot Number"),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      IconButton(
                        icon: Image.asset(
                          "assets/barscan.png",
                          height: 40,
                          width: 30,
                        ),
                        onPressed: () {
                          scanBarcode("bag");
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 30, width: 100, child: value.baggerror),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            // FocusScopeNode currentFocus = FocusScope.of(context);

                            // if (!currentFocus.hasPrimaryFocus) {
                            //   currentFocus.unfocus();
                            // }

                            if (bagno.text.toString().isEmpty ||
                                value.card_id.isEmpty) {
                              CustomSnackbar snackbar = CustomSnackbar();
                              snackbar.showSnackbar(
                                  context, "Please select Card & Bag ...", "");
                            } else if (value.bagDetailsList.isEmpty) {
                              CustomSnackbar snackbar = CustomSnackbar();
                              snackbar.showSnackbar(
                                  context, "Choose valid slot...", "");
                            } 
                            else if (Provider.of<Controller>(context,
                                        listen: false)
                                    .ccfon
                                    .text
                                    .length !=
                                10 && Provider.of<Controller>(context,
                                        listen: false)
                                    .ccfon
                                    .text.isNotEmpty) {
                              CustomSnackbar snackbar = CustomSnackbar();
                              snackbar.showSnackbar(
                                  context, "Enter valid contact...", "");
                            } 
                            else {
                              print("card---->${value.card_id.toString()}");
                              print("bag---->${value.bag_no.toString()}");
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                // Provider.of<Controller>(context, listen: false)
                                //     .getItemDetails(
                                //         context, value.bag_no.toString());
                                Provider.of<Controller>(context, listen: false)
                                    .getCart(context);
                                Provider.of<Controller>(context, listen: false)
                                    .setcusnameAndPhone(value.ccname.text,
                                        value.ccfon.text, context);
                              });
                              print(
                                  "namee------ ${value.ccname.text},  phone---${value.ccfon.text}");
                              bagno.clear();
                              // setState(() {});
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ItemAddPage(
                                          cardno: value.cardNoctrl.text,
                                          bagno: value.bag_no.toString(),
                                        )),
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
                  )
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
          Provider.of<Controller>(context, listen: false).cardNoctrl.text =
              _scanBarcode.toString();
          _scanBarcode = "";
          Provider.of<Controller>(context, listen: false).getCustData(
              date,
              Provider.of<Controller>(context, listen: false)
                  .cardNoctrl
                  .text
                  .toString(),
              context);
        } else {
          bagno.text = _scanBarcode.toString();
          _scanBarcode = "";
          Provider.of<Controller>(context, listen: false)
              .getBagDetails(bagno.text.toString(), context, "home");
        }
      });
    } on PlatformException {
      _scanBarcode = "hugugu";
    }
  }
}
