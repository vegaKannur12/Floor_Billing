import 'dart:async';

import 'package:floor_billing/SCREENs/ITEMDATA/viewcart.dart';
import 'package:floor_billing/components/custom_snackbar.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:floor_billing/peridic_fun.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import 'package:badges/badges.dart' as badges;

class ItemAddPage extends StatefulWidget {
  const ItemAddPage({super.key});

  @override
  State<ItemAddPage> createState() => _ItemAddPageState();
}

class _ItemAddPageState extends State<ItemAddPage> {
  final _debouncer = Debouncer(milliseconds: 1000);
  TextEditingController itembarcodctrl = TextEditingController();
  TextEditingController smanContrlr = TextEditingController();
  FocusNode smanfocus = FocusNode();
  FocusNode barfocus = FocusNode();
  String _scanBarcode = 'Unknown';
  String _topModalData = "";
  bool? ss = false;
  String date = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController bagno = TextEditingController();
  FocusNode bagFocus = FocusNode();
  bool tapped = false;
  @override
  void initState() {
    super.initState();

    date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    print("dateeeeeeeeeeeeeee= $date");
    //  FunctionUtils.runFunctionPeriodically(context);
    smanfocus.addListener(() async {
      if (!smanfocus.hasFocus) {
        print('sales vaaaaaaaaaaal${smanContrlr.text}');
        await Provider.of<Controller>(context, listen: false)
            .searchSalesMan(smanContrlr.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.purple,
        title: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) =>
              Text(
            value.card_id.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
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
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            tapped = true;
                          });
                        },
                        child: tapped
                            ? SizedBox(
                                height: 60,
                                width: 130,
                                child: TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  focusNode: bagFocus,
                                  controller: bagno,
                                  onChanged: (val) {
                                    Provider.of<Controller>(context,
                                            listen: false)
                                        .setBagNo(bagno.text.toString());
                                  },
                                  onFieldSubmitted: (_) {
                                    setState(() {
                                      tapped = false;
                                    });
                                  },
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please Select Bag Number';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.search,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          scanBarcode("bag");
                                        },
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                      hintText: "Select Bag"),
                                ),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.shopping_bag,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  Text(
                                    "${value.bag_no.toString().toUpperCase()}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      //   height: 70,
      //   width: size.width,
      //   decoration: BoxDecoration(
      //     borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(5),
      //       topRight: Radius.circular(5),
      //     ),
      //   ),
      //   // child: Consumer<Controller>(
      //   //     builder: (context, value, child) => ),
      // ),
      body: Consumer<Controller>(
          builder: (context, value, child) => Padding(
                padding: EdgeInsets.all(5),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          badges.Badge(
                            badgeStyle:
                                  badges.BadgeStyle(badgeColor: Colors.red),
                              position: badges.BadgePosition.topEnd(
                                  top: -5, end: -10),
                              showBadge: true,
                              badgeContent: Text(
                                value.unsavedList.length == null
                                    ? "0"
                                    : value.unsavedList.length.toString(),
                                 style: TextStyle(color: Colors.white),
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    Provider.of<Controller>(context,
                                            listen: false)
                                        .getUnsavedCart(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewCartPage()),
                                    );
                                  },
                                  icon: Icon(Icons.shopping_cart))),
                          Text(
                            value.card_id.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 60,
                            width: 230,
                            child: GestureDetector(
                              child: TextFormField(
                                // focusNode: barfocus,
                                controller: itembarcodctrl,
                                onChanged: (val) {
                                  // _debouncer.run(() {
                                  //   Provider.of<Controller>(context,
                                  //           listen: false)
                                  //       .getItemDetails(context,
                                  //           itembarcodctrl.text.toString());
                                  // });
                                },
                                decoration: InputDecoration(
                                    errorBorder: UnderlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(),
                                    hintText: "Barcode",
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          Provider.of<Controller>(context,
                                                  listen: false)
                                              .clearSelectedBarcode(context);
                                          itembarcodctrl.clear();
                                        },
                                        icon: Icon(Icons.close))),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            icon: Image.asset(
                              "assets/search.png",
                              color: Colors.black,
                              height: 40,
                              width: 30,
                            ),
                            onPressed: () async {
                              print(
                                  "baaaaaaaaaaaaaaaaaarrrrrrrrrrr${itembarcodctrl.text.toString()}");
                              await Provider.of<Controller>(context,
                                      listen: false)
                                  .getItemDetails(
                                      context, itembarcodctrl.text.toString());
                              setState(() {});
                              if (value.selectedBarcode.toString() == "" ||
                                  value.selectedBarcode.toString() == " " ||
                                  value.selectedBarcode.toString().isEmpty ||
                                  value.selectedBarcode.toString() == "null") {
                                ShowBottomSeet(context);
                              } else {
                                setState(() {
                                  Provider.of<Controller>(context,
                                          listen: false)
                                      .setshowdata(true);
                                });

                                print(
                                    "Not empty........................................");
                              }
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            icon: Image.asset(
                              "assets/barscan.png",
                              color: Colors.black,
                              height: 40,
                              width: 30,
                            ),
                            onPressed: () {
                              scanBarcode("");
                            },
                          ),
                        ],
                      ),
                      value.barcodeinvalid
                          ? Row(
                              children: [
                               
                                SizedBox(
                                    height: 50,
                                    width: 100,
                                    child: value.barcodeerror)
                              ],
                            )
                          : value.showdata
                              ? Expanded(
                                  child: Card(
                                    color: Colors.white,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            value.selectedBarcodeList.length,
                                        itemBuilder: (context, index) {
                                          if (value.selectedBarcodeList[index]
                                                      ["Barcode"]
                                                  .toString()
                                                  .trim() ==
                                              value.selectedBarcode
                                                  .toString()) {
                                            print('haiiiiiii');
                                            return Container(
                                                decoration: BoxDecoration(),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 45,
                                                        child: ListTile(
                                                          title: Text(
                                                              "BARCODE      : ${value.selectedBarcodeList[index]["Barcode"].toString()}"),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 45,
                                                        child: ListTile(
                                                          title: Text(
                                                            "EAN               : ${value.selectedBarcodeList[index]["EAN"].toString()}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 45,
                                                        child: ListTile(
                                                          title: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 25,
                                                                width: 110,
                                                                child: Text(
                                                                    "Item Name    : "),
                                                              ),
                                                              Text(
                                                                "${value.selectedBarcodeList[index]["Item_Name"].toString()}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 45,
                                                        child: ListTile(
                                                          title: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "SRate             : ${value.selectedBarcodeList[index]["SRate"].toString()}"),
                                                              Text(
                                                                  " TAX    :${value.selectedBarcodeList[index]["TaxPer"].toString()} %"),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 45,
                                                        child: ListTile(
                                                          title: Row(
                                                            children: [
                                                              SizedBox(
                                                                  height: 25,
                                                                  width: 155,
                                                                  child: Text(
                                                                      "Discount        : ")),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                      height:
                                                                          40,
                                                                      width: 50,
                                                                      color: Colors
                                                                          .greenAccent,
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            value.persntage[index],
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                        decoration:
                                                                            InputDecoration(
                                                                          contentPadding:
                                                                              EdgeInsets.all(3),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
                                                                          ),
                                                                        ),
                                                                        onChanged:
                                                                            (value) {
                                                                          Provider.of<Controller>(context, listen: false).discount_calc(
                                                                              index,
                                                                              "from add");
                                                                        },
                                                                      )),
                                                                  Text(
                                                                    " %",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            22,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 45,
                                                        child: ListTile(
                                                          title: Row(
                                                            children: [
                                                              SizedBox(
                                                                  height: 25,
                                                                  width: 125,
                                                                  child: Text(
                                                                      "Quantity         :")),
                                                              Row(
                                                                children: [
                                                                  InkWell(
                                                                      onTap:
                                                                          () {
                                                                        // value.response[index] = 0;
                                                                        Provider.of<Controller>(context, listen: false).setQty(
                                                                            1.0,
                                                                            index,
                                                                            "dec");
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .remove,
                                                                        color: Colors
                                                                            .red,
                                                                      )),
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        left: 7,
                                                                        right:
                                                                            7),
                                                                    height: 35,
                                                                    width: 50,
                                                                    child:
                                                                        TextField(
                                                                      onTap:
                                                                          () {
                                                                        value.qty[index].selection = TextSelection(
                                                                            baseOffset:
                                                                                0,
                                                                            extentOffset:
                                                                                value.qty[index].value.text.length);
                                                                      },
                                                                      onSubmitted:
                                                                          (val) {},
                                                                      onChanged:
                                                                          (val) {},
                                                                      controller:
                                                                          value.qty[
                                                                              index],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        contentPadding:
                                                                            EdgeInsets.all(3),
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width: 1,
                                                                              color: Colors.grey), //<-- SEE HERE
                                                                        ),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width: 1,
                                                                              color: Colors.grey), //<-- SEE HERE
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                      onTap:
                                                                          () {
                                                                        // value.response[index] = 0;
                                                                        Provider.of<Controller>(context, listen: false).setQty(
                                                                            1.0,
                                                                            index,
                                                                            "inc");
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: Colors
                                                                            .green,
                                                                      )),
                                                                ],
                                                              )
                                                              // SizedBox(
                                                              //     height: 25,
                                                              //     width: 40,
                                                              //     child: TextFormField(
                                                              //       initialValue: value
                                                              //           .selectedBarcodeList[
                                                              //               index]["Qty"]
                                                              //           .toString(),
                                                              //     ))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 45,
                                                        child: ListTile(
                                                          title: Row(
                                                            children: [
                                                              SizedBox(
                                                                  height: 25,
                                                                  width: 135,
                                                                  child: Text(
                                                                      "Salesman      : ")),
                                                              SizedBox(
                                                                height: 50,
                                                                width: 100,
                                                                child:
                                                                    TextFormField(
                                                                  focusNode:
                                                                      smanfocus,
                                                                  controller:
                                                                      smanContrlr,
                                                                  onFieldSubmitted:
                                                                      (val) async {
                                                                    print(
                                                                        'sales vaaaaaaaaaaal$val');
                                                                    await Provider.of<Controller>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .searchSalesMan(
                                                                            val);
                                                                  },
                                                                  validator:
                                                                      (text) {
                                                                    print(
                                                                        "$ss");
                                                                    print(
                                                                        "object0000000000000$text");
                                                                    if (text ==
                                                                            null ||
                                                                        text.isEmpty) {
                                                                      return 'Please Select Salesman';
                                                                    }

                                                                    return null;
                                                                  },
                                                                  decoration: InputDecoration(
                                                                      errorBorder: UnderlineInputBorder(),
                                                                      suffixIcon: IconButton(
                                                                          icon: Icon(Icons.search),
                                                                          onPressed: () {
                                                                            scanBarcode("sale");
                                                                          }),
                                                                      hintText: "SalesMan"),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 45,
                                                        child: ListTile(
                                                          title: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 50,
                                                                width: 150,
                                                              ),
                                                              SizedBox(
                                                                  height: 50,
                                                                  width: 50,
                                                                  child: value
                                                                      .salesError)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        thickness: 2,
                                                      ),
                                                      ListTile(
                                                        title: Row(
                                                          children: [
                                                            SizedBox(
                                                                height: 50,
                                                                width: 150,
                                                                child: Text(
                                                                  'Net Amount   :',
                                                                  style: TextStyle(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          134,
                                                                          93,
                                                                          93),
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                )),
                                                            SizedBox(
                                                                height: 50,
                                                                width: 100,
                                                                child: value
                                                                        .netamt[
                                                                    index]),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          value.showdata
                                                              ? SizedBox(
                                                                  height: 60,
                                                                  width: 200,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      if (_formKey
                                                                          .currentState!
                                                                          .validate()) {}
                                                                      if (double.parse(value
                                                                              .qty[index]
                                                                              .text) ==
                                                                          0.0) {
                                                                        CustomSnackbar
                                                                            snackbar =
                                                                            CustomSnackbar();
                                                                        snackbar.showSnackbar(
                                                                            context,
                                                                            "Quantity can't be null...",
                                                                            "");
                                                                      } else {
                                                                        Provider.of<Controller>(context, listen: false).updateCart(
                                                                            context,
                                                                            date,
                                                                            smanContrlr.text,
                                                                            value.selectedBarcode,
                                                                            double.parse(value.qty[index].text),
                                                                            double.parse(value.persntage[index].text),
                                                                            0);
                                                                      }
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            Colors.red),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              12.0,
                                                                          bottom:
                                                                              12),
                                                                      child:
                                                                          Text(
                                                                        "ADD TO BAG ${value.bag_no.toString().toUpperCase()}",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                17,
                                                                            color:
                                                                                Theme.of(context).secondaryHeaderColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : SizedBox()
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ));
                                          } else {
                                            return Container(
                                              child: Text(""),
                                            );
                                          }
                                        }),
                                  ),
                                )
                              : Container(
                                  child: Text(""), ////nodar
                                )
                    ],
                  ),
                ),
              )),
    );
  }

  Future<void> ShowBottomSeet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: value.barcodeList.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 238, 231, 212)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              child: ListTile(
                                title: Text(
                                    "BARCODE : ${value.barcodeList[index]["Barcode"].toString()}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "EAN : ${value.barcodeList[index]["EAN"].toString()}"),
                                    Text(
                                        "Item Name : ${value.barcodeList[index]["Item_Name"].toString()}"),
                                    Text(
                                        "SRate : ${value.barcodeList[index]["SRate"].toString()}"),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);

                                Provider.of<Controller>(context, listen: false)
                                    .setSelectedBarcode(
                                        context,
                                        value.barcodeList[index]["Barcode"]
                                            .toString()
                                            .trim());
                              },
                            ),
                          )));
                });
          },
        );
      },
    );
  }

  // Future<void> _showTopModal() async {
  //   final value = await showTopModalSheet<String?>(
  //     context,
  //     const DummyModal(),
  //     backgroundColor: Colors.white,
  //     borderRadius: const BorderRadius.vertical(
  //       bottom: Radius.circular(20),
  //     ),
  //   );
  //   if (value != null) setState(() => _topModalData = value);
  // }

  Future<void> scanBarcode(String field) async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (!mounted) return;
      setState(() async {
        _scanBarcode = barcode;
        if (field == "bag") {
          bagno.text = _scanBarcode.toString().trim();
          _scanBarcode = "";
        } else if (field == "sale") {
          smanContrlr.text = _scanBarcode.toString().trim();
          print('sales vaaaaaaaaaaal${smanContrlr.text}');
          await Provider.of<Controller>(context, listen: false)
              .searchSalesMan(smanContrlr.text);
          _scanBarcode = "";
        } else {
          itembarcodctrl.text = _scanBarcode.toString().trim();
          _scanBarcode = "";
          await Provider.of<Controller>(context, listen: false)
              .getItemDetails(context, itembarcodctrl.text.toString());
          setState(() {});
          if (Provider.of<Controller>(context, listen: false)
                      .selectedBarcode
                      .toString() ==
                  "" ||
              Provider.of<Controller>(context, listen: false)
                      .selectedBarcode
                      .toString() ==
                  " " ||
              Provider.of<Controller>(context, listen: false)
                  .selectedBarcode
                  .toString()
                  .isEmpty ||
              Provider.of<Controller>(context, listen: false)
                      .selectedBarcode
                      .toString() ==
                  "null") {
            ShowBottomSeet(context);
          } else {
            setState(() {
              Provider.of<Controller>(context, listen: false).setshowdata(true);
            });

            print("Not empty........................................");
          }
        }
      });
    } on PlatformException {
      _scanBarcode = "hugugu";
    }
  }
}

class Debouncer {
  late int milliseconds;
  late VoidCallback action;
  late Timer _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
