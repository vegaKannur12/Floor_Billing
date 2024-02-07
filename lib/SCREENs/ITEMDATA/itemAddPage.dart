import 'dart:async';

import 'package:floor_billing/SCREENs/ITEMDATA/topSheetData.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
      body: Consumer<Controller>(
          builder: (context, value, child) => Padding(
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
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
                            onPressed: () {
                              Provider.of<Controller>(context, listen: false)
                                  .getItemDetails(
                                      context, itembarcodctrl.text.toString());
                              if (value.selectedBarcode.toString() == "" &&
                                  value.selectedBarcode.toString() == " " &&
                                  value.selectedBarcode.toString().isEmpty) {
                                ShowBottomSeet(context);
                              }
                              else{
                                
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
                      // TextButton(
                      //     onPressed: _showTopModal,
                      //     child: Text(value.selectedBarcode.toString()))
                      ListView.builder(
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
                                        .toString());
                              },
                            ),
                          )));
                })
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
                                    .setSelectedBarcode(value.barcodeList[index]
                                            ["Barcode"]
                                        .toString());
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
