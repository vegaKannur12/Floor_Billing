import 'dart:async';

import 'package:floor_billing/SCREENs/ITEMDATA/topSheetData.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

class ItemAddPage extends StatefulWidget {
  const ItemAddPage({super.key});

  @override
  State<ItemAddPage> createState() => _ItemAddPageState();
}

class _ItemAddPageState extends State<ItemAddPage> {
  final _debouncer = Debouncer(milliseconds: 1000);
  TextEditingController itembarcodctrl = TextEditingController();
  FocusNode barfocus = FocusNode();
  String _scanBarcode = 'Unknown';
  String _topModalData = "";
  bool showdata = false;
  @override
  void initState() {
    super.initState();
//      WidgetsBinding.instance.addPostFrameCallback((_) {
// Provider.of<Controller>(context, listen: false)
//         .getItemDetails(context);
//     });
    // barfocus.addListener(() {
    //   if (!barfocus.hasFocus) {
    //     // getCustdetails(cardno.text.toString());
    //   }
    // });
  }

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
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 60,
                      width: 130,
                      padding: const EdgeInsets.only(right: 5, left: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButton<Map>(
                        underline: const SizedBox(),
                        value: value.selectedSalesMan,
                        items: value.salesManlist.map((sale) {
                          // cid = branch["CID"].toString();
                          return DropdownMenuItem<Map>(
                            value: sale,
                            child: Text(
                              sale["Sm_Code"],
                              style: GoogleFonts.ptSerif(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          print(
                              "selected sMAN -- ${val!["Sm_Code"].toString()}");

                          value.changeSalesman(val);
                        },
                        hint: const Text('Select SMan'),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          //  Provider.of<Controller>(context, listen: false)
                          //     .getLogin(
                          //         'floor4','997', context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                          child: Text(
                            "ADD",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
      ),
      body: Consumer<Controller>(
          builder: (context, value, child) => Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 60,
                          width: 200,
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
                                  hintText: "Barcode"),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        FloatingActionButton(
                          child: Text("Find"),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          onPressed: () async {
                            print("baaaaaaaaaaaaaaaaaarrrrrrrrrrr${itembarcodctrl.text.toString()}");
                            await Provider.of<Controller>(context,
                                    listen: false)
                                .getItemDetails(
                                    context, itembarcodctrl.text.toString());
                                     setState(() {
                               
                              });
                            if (value.selectedBarcode.toString() == "" ||
                                value.selectedBarcode.toString() == " " ||
                                value.selectedBarcode.toString().isEmpty ||
                                value.selectedBarcode.toString() == "null") {
                              ShowBottomSeet(context);
                            } else {
                              setState(() {
                                showdata = true;
                              });

                              print(
                                  "Not empty........................................");
                            }
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        FloatingActionButton(
                          child: Text("Scan"),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          onPressed: () {
                            scanBarcode("");
                          },
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: _showTopModal,
                        child: Text(value.selectedBarcode.toString())),
                    showdata
                        ? Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: value.selectedBarcodeList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      decoration: BoxDecoration(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                  "BARCODE  : ${value.selectedBarcodeList[index]["Barcode"].toString()}"),
                                            ),
                                            ListTile(
                                              title: Text(
                                                  "EAN           : ${value.selectedBarcodeList[index]["EAN"].toString()}"),
                                            ),
                                            ListTile(
                                              title: Text(
                                                  "Item Name: ${value.selectedBarcodeList[index]["Item_Name"].toString()}"),
                                            ),
                                            ListTile(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "SRate          : ${value.selectedBarcodeList[index]["SRate"].toString()}"),
                                                  Text(
                                                      "TAX    : ${value.selectedBarcodeList[index]["TaxPer"].toString()}"),
                                                ],
                                              ),
                                            ),
                                            ListTile(
                                              title: Row(
                                                children: [
                                                  Text("Discount       : "),
                                                  SizedBox(
                                                      height: 25,
                                                      width: 40,
                                                      child: TextFormField(
                                                        initialValue: value
                                                            .selectedBarcodeList[
                                                                index]
                                                                ["DiscPer"]
                                                            .toString(),
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                      height: 25,
                                                      width: 40,
                                                      child: TextFormField(
                                                        decoration: InputDecoration(
                                                            enabledBorder:
                                                                OutlineInputBorder()),
                                                        initialValue: "0",
                                                      ))
                                                ],
                                              ),
                                            ),
                                            ListTile(
                                              title: Row(
                                                children: [
                                                  Text("QUANTITY       : "),
                                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            // value.response[index] = 0;

                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .setQty(1.0, index, "dec");
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.red,
                                          )),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 7, right: 7),
                                        width: size.width * 0.14,
                                        height: size.height * 0.05,
                                        child: TextField(
                                          onTap: () {
                                            value.qty[index].selection =
                                                TextSelection(
                                                    baseOffset: 0,
                                                    extentOffset: value
                                                        .qty[index]
                                                        .value
                                                        .text
                                                        .length);
                                          },
                                          onSubmitted: (val) {
                                            // value.response[index] = 0;
                                            // Provider.of<Controller>(context,
                                            //         listen: false)
                                            //     .updateCart(
                                            //         context,
                                            //         widget.list[index],
                                            //         date!,
                                            //         value.customerId.toString(),
                                            //         double.parse(val),
                                            //         index,
                                            //         "from itempage",
                                            //         0,
                                            //         widget.catId);
                                          },
                                          onChanged: (val) {
                                            // value.response[index] = 0;
                                          },
                                          controller: value.qty[index],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(3),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors
                                                      .grey), //<-- SEE HERE
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors
                                                      .grey), //<-- SEE HERE
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            // value.response[index] = 0;
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .setQty(1.0, index, "inc");
                                          },
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.green,
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
                                            ListTile(
                                              title: Text(
                                                  "Net Amount    : ${value.netamt}"),
                                            ),
                                          ],
                                        ),
                                      ));
                                }),
                          )
                        : Container()
                  ],
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
                                    .setSelectedBarcode(value.barcodeList[index]
                                            ["Barcode"]
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

  Future<void> _showTopModal() async {
    final value = await showTopModalSheet<String?>(
      context,
      const DummyModal(),
      backgroundColor: Colors.white,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
    );
    if (value != null) setState(() => _topModalData = value);
  }

  Future<void> scanBarcode(String field) async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (!mounted) return;
      setState(() {
        _scanBarcode = barcode;

        itembarcodctrl.text = _scanBarcode.toString();
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
