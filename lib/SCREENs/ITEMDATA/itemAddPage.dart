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
  final String cardno;
  final String bagno;
  const ItemAddPage({super.key, required this.cardno, required this.bagno});

  @override
  State<ItemAddPage> createState() => _ItemAddPageState();
}

class _ItemAddPageState extends State<ItemAddPage> {
  final _debouncer = Debouncer(milliseconds: 1000);
  TextEditingController itembarcodctrl = TextEditingController();
  // TextEditingController smanContrlr = TextEditingController();
  String sman = "";
  FocusNode smanfocus = FocusNode();
  FocusNode barfocus = FocusNode();
  String _scanBarcode = 'Unknown';
  String _topModalData = "";
  bool? ss = false;
  String date = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController bagno = TextEditingController();
  FocusNode bagFocus = FocusNode();
  // bool tapped = false;
  @override
  void initState() {
    super.initState();

    date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    print("dateeeeeeeeeeeeeee= $date");
    Provider.of<Controller>(context, listen: false).setBarerror("");
    Provider.of<Controller>(context, listen: false).setshowdata(false);
    //  FunctionUtils.runFunctionPeriodically(context);
    smanfocus.addListener(() async {
      if (!smanfocus.hasFocus) {
        print('sales vaaaaaaaaaaal${sman}');
        await Provider.of<Controller>(context, listen: false)
            .searchSalesMan(sman);
      }
    });
  }

  Future<bool> _showBackDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Items in cart will be cleared'),
          content: const Text(
            'Sure to proceed ?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Provider.of<Controller>(context, listen: false).clearunsaved();
                Navigator.pushNamed(context, '/floorhome');
                // Navigator.pop(context);
                // Navigator.pop(context);
                //  setState(() {});
              },
            ),
          ],
        );
      },
    );
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
            "${widget.cardno.toString()}/${widget.bagno.toString()}",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                      badges.Badge(
                          badgeStyle:
                              badges.BadgeStyle(badgeColor: Colors.red),
                          position:
                              badges.BadgePosition.topEnd(top: -5, end: -10),
                          showBadge: true,
                          badgeContent: Text(
                            value.unsavedList.length == null
                                ? "0"
                                : value.unsavedList.length.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          child: IconButton(
                              onPressed: () async {
                                await Future.delayed(Duration.zero, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewCartPage(
                                              cardno:
                                                  widget.cardno.toString(),
                                              bagno: widget.bagno.toString(),
                                            )),
                                  );
                                });
                              },
                              icon: Icon(Icons.shopping_cart,
                                  color: Colors.white))),
    
                      // GestureDetector(
                      //   onTap: () {
                      //     setState(() {
                      //       value.tapped = true;
                      //     });
                      //   },
                      //   child: value.tapped
                      //       ? SizedBox(
                      //           height: 60,
                      //           width: 130,
                      //           child: TextFormField(
                      //             style: TextStyle(
                      //               color: Colors.white,
                      //             ),
                      //             focusNode: bagFocus,
                      //             controller: bagno,
                      //             onChanged: (val) {},
                      //             onFieldSubmitted: (_) {
                      //               setState(() {
                      //                 Provider.of<Controller>(context,
                      //                         listen: false)
                      //                     .getBagDetails(
                      //                         bagno.text.toString(),
                      //                         context,
                      //                         "add");
                      //                 // tapped = false;
                      //               });
                      //             },
                      //             validator: (text) {
                      //               if (text == null || text.isEmpty) {
                      //                 return 'Please Select Bag Number';
                      //               }
                      //               return null;
                      //             },
                      //             decoration: InputDecoration(
                      //                 errorBorder: UnderlineInputBorder(
                      //                     borderSide: BorderSide(
                      //                   color: Colors.white,
                      //                 )),
                      //                 suffixIcon: IconButton(
                      //                   icon: Icon(
                      //                     Icons.search,
                      //                     color: Colors.white,
                      //                   ),
                      //                   onPressed: () {
                      //                     scanBarcode("bag");
                      //                   },
                      //                 ),
                      //                 hintStyle: TextStyle(
                      //                   color: Colors.white,
                      //                 ),
                      //                 hintText: "Select Bag"),
                      //           ),
                      //         )
                      //       : Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             Icon(
                      //               Icons.shopping_bag,
                      //               color: Colors.white,
                      //               size: 35,
                      //             ),
                      //             Text(
                      //               "${value.bag_no.toString().toUpperCase()}",
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: 15,
                      //                   color: Colors.white),
                      //             ),
                      //           ],
                      //         ),
                      // ),
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
                padding: EdgeInsets.all(5),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 45,
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
                                                .clearSelectedBarcode(
                                                    context);
                                            itembarcodctrl.clear();
                                          },
                                          icon: Icon(Icons.close))),
                                  onFieldSubmitted: (_) async {
                                    print(
                                        "baaaaaaaaaaaaaaaaaarrrrrrrrrrr${itembarcodctrl.text.toString()}");
                                    await Provider.of<Controller>(context,
                                            listen: false)
                                        .getItemDetails(context,
                                            itembarcodctrl.text.toString());
                                    setState(() {});
                                    if (value.selectedBarcode.toString() ==
                                            "" &&
                                        value.selectedBarcode.toString() ==
                                            " " &&
                                        value.selectedBarcode
                                            .toString()
                                            .isEmpty &&
                                        value.selectedBarcode.toString() ==
                                            "null") {
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
                                  }),
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
                              scanBarcode("", 0);
                            },
                          ),
                        ],
                      ),
                      value.barcodeinvalid == false &&
                                  value.selectedBarcodeList.isEmpty ||
                              value.barcodeList.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Image.asset(
                                  "assets/nothing.png",
                                  height: 70,
                                  width: 60,
                                ),
                              ),
                            )
                          // ? Row(
                          //     children: [
                          //       SizedBox(
                          //           height: 50,
                          //           width: 100,
                          //           child: value.barcodeerror)
                          //     ],
                          //   )
                          : value.showdata &&
                                  value.selectedBarcodeList.isNotEmpty
                              ? Expanded(
                                  child: Container(
                                    color: Colors.orange[50],
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
                                                      const EdgeInsets.only(
                                                          left: 5, right: 5),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 35,
                                                        child: ListTile(
                                                          title: Text(
                                                              "BARCODE      : ${value.selectedBarcodeList[index]["Barcode"].toString().trimLeft()}"),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 35,
                                                        child: ListTile(
                                                          title: Text(
                                                            "EAN               : ${value.selectedBarcodeList[index]["EAN"].toString().trimLeft()}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 35,
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
                                                                "${value.selectedBarcodeList[index]["Item_Name"].toString().trimLeft()}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 35,
                                                        child: ListTile(
                                                          title: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "SRate             : ${value.selectedBarcodeList[index]["SRate"].toStringAsFixed(2)}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Text(
                                                                  " TAX    :${value.selectedBarcodeList[index]["TaxPer"].toString()} %"),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 8,
                                                                  bottom: 15),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: Colors
                                                                      .orange[
                                                                  100]),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 35,
                                                                child:
                                                                    ListTile(
                                                                  title: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                          height:
                                                                              25,
                                                                          width:
                                                                              155,
                                                                          child:
                                                                              Text("Discount        : ")),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                              height: 40,
                                                                              width: 50,
                                                                              color: Colors.greenAccent,
                                                                              child: TextFormField(
                                                                                keyboardType: TextInputType.phone,
                                                                                controller: value.persntage[index],
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                                                                                decoration: InputDecoration(
                                                                                  contentPadding: EdgeInsets.all(3),
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
                                                                                  ),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
                                                                                  ),
                                                                                ),
                                                                                onChanged: (value) {
                                                                                  Provider.of<Controller>(context, listen: false).discount_calc(index, "from add");
                                                                                },
                                                                              )),
                                                                          Text(
                                                                            " %",
                                                                            style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 40,
                                                                child:
                                                                    ListTile(
                                                                  title: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                          height:
                                                                              25,
                                                                          width:
                                                                              125,
                                                                          child:
                                                                              Text("Quantity         :")),
                                                                      Row(
                                                                        children: [
                                                                          InkWell(
                                                                              onTap: () {
                                                                                // value.response[index] = 0;
                                                                                Provider.of<Controller>(context, listen: false).setQty(value.selectedBarcodeList[index]["AllowDecimal"], index, "dec");
                                                                              },
                                                                              child: Icon(
                                                                                Icons.remove,
                                                                                color: Colors.red,
                                                                              )),
                                                                          SizedBox(
                                                                            width: 5,
                                                                          ),
                                                                          Container(
                                                                            margin: EdgeInsets.only(left: 7, right: 7),
                                                                            height: 35,
                                                                            width: 60,
                                                                            child: TextField(
                                                                              keyboardType: TextInputType.phone,
                                                                              onTap: () {
                                                                                value.qty[index].selection = TextSelection(baseOffset: 0, extentOffset: value.qty[index].value.text.length);
                                                                              },
                                                                              onSubmitted: (val) {},
                                                                              onChanged: (val) {},
                                                                              controller: value.qty[index],
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
                                                                              decoration: InputDecoration(
                                                                                contentPadding: EdgeInsets.all(3),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 5,
                                                                          ),
                                                                          InkWell(
                                                                              onTap: () {
                                                                                // value.response[index] = 0;
                                                                                Provider.of<Controller>(context, listen: false).setQty(value.selectedBarcodeList[index]["AllowDecimal"], index, "inc");
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
                                                              ),
                                                              SizedBox(
                                                                height: 40,
                                                                child:
                                                                    ListTile(
                                                                  title: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                          height:
                                                                              25,
                                                                          width:
                                                                              135,
                                                                          child:
                                                                              Text(
                                                                            "Salesman      : ",
                                                                            style: TextStyle(fontWeight: FontWeight.w800),
                                                                          )),
                                                                      SizedBox(
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            100,
                                                                        child:
                                                                            TextFormField(
                                                                          keyboardType:
                                                                              TextInputType.phone,
                                                                          focusNode:
                                                                              smanfocus,
                                                                          controller:
                                                                              value.smantext[index],
                                                                          onFieldSubmitted:
                                                                              (val) async {
                                                                            sman = value.smantext[index].text;
                                                                            print("smmmmmmmmmmm${value.smantext[index].text}");
                                                                            print('sales vaaaaaaaaaaal$val');
                                                                            await Provider.of<Controller>(context, listen: false).searchSalesMan(val);
                                                                          },
                                                                          // validator: (text) {
                                                                          //   print("$ss");
                                                                          //   print("object0000000000000$text");
                                                                          //   if (text == null || text.isEmpty) {
                                                                          //     return 'Please Select Salesman';
                                                                          //   }
    
                                                                          //   return null;
                                                                          // },
                                                                          decoration: InputDecoration(
                                                                              errorBorder: UnderlineInputBorder(),
                                                                              suffixIcon: IconButton(
                                                                                  icon: Icon(Icons.search),
                                                                                  onPressed: () {
                                                                                    scanBarcode("sale", index);
                                                                                  }),
                                                                              hintText: "SalesMan"),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                      // SizedBox(
                                                      //   height: 40,
                                                      //   child: ListTile(
                                                      //     title: Row(
                                                      //       children: [
                                                      //         SizedBox(
                                                      //           height: 50,
                                                      //           width: 150,
                                                      //         ),
                                                      //         // SizedBox(
                                                      //         //     height:
                                                      //         //         50,
                                                      //         //     width: 50,
                                                      //         //     child: value
                                                      //         //         .salesError)
                                                      //       ],
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      Divider(
                                                        thickness: 2,
                                                      ),
                                                      ListTile(
                                                        title: Row(
                                                          children: [
                                                            SizedBox(
                                                                height: 45,
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
                                                                          FontWeight.w600),
                                                                )),
                                                            SizedBox(
                                                                height: 50,
                                                                width: 140,
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
                                                                        () async {
                                                                      await Provider.of<Controller>(context, listen: false).searchSalesMan(value
                                                                          .smantext[index]
                                                                          .text);
                                                                      if (_formKey
                                                                          .currentState!
                                                                          .validate()) {}
                                                                      if (double.parse(value.qty[index].text) <=
                                                                          0.0) {
                                                                        // print("Quantity can't be null...");
                                                                        CustomSnackbar
                                                                            snackbar =
                                                                            CustomSnackbar();
                                                                        snackbar.showSnackbar(
                                                                            context,
                                                                            "Quantity can't be null...",
                                                                            "");
                                                                      } else if (value
                                                                          .smantext[
                                                                              index]
                                                                          .text
                                                                          .isEmpty) {
                                                                        CustomSnackbar
                                                                            snackbar =
                                                                            CustomSnackbar();
                                                                        snackbar.showSnackbar(
                                                                            context,
                                                                            "Select salesman...",
                                                                            "");
                                                                      } else if (Provider.of<Controller>(context, listen: false).isvalidsale !=
                                                                          true) {
                                                                        CustomSnackbar
                                                                            snackbar =
                                                                            CustomSnackbar();
                                                                        snackbar.showSnackbar(
                                                                            context,
                                                                            "Salesman Not Exist...",
                                                                            "");
                                                                      } else if (int.parse(Provider.of<Controller>(context, listen: false).smantext[index].text) <=
                                                                          -1) {
                                                                        CustomSnackbar
                                                                            snackbar =
                                                                            CustomSnackbar();
                                                                        snackbar.showSnackbar(
                                                                            context,
                                                                            "Salesman Not Exist...",
                                                                            "");
                                                                      }
                                                                      // else if (value.slot_id <=
                                                                      //     0) {
                                                                      //   CustomSnackbar
                                                                      //       snackbar =
                                                                      //       CustomSnackbar();
                                                                      //   snackbar.showSnackbar(
                                                                      //       context,
                                                                      //       "Select a Slot...",
                                                                      //       "");
                                                                      // }
                                                                      else {
                                                                        Provider.of<Controller>(context, listen: false).updateCart(
                                                                            context,
                                                                            date,
                                                                            value.smantext[index].text,
                                                                            0,
                                                                            value.selectedBarcode,
                                                                            double.parse(value.qty[index].text),
                                                                            double.parse(value.persntage[index].text),
                                                                            0);
                                                                        Provider.of<Controller>(context, listen: false)
                                                                            .getUnsavedCart(context);
                                                                        Provider.of<Controller>(context, listen: false)
                                                                            .setshowdata(false);
                                                                        itembarcodctrl
                                                                            .clear();
                                                                        setState(
                                                                            () {});
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
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 17,
                                                                            color: Theme.of(context).secondaryHeaderColor),
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
                                    "BARCODE : ${value.barcodeList[index]["Barcode"].toString().trimLeft()}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "EAN : ${value.barcodeList[index]["EAN"].toString().trimLeft()}"),
                                    Text(
                                        "Item Name : ${value.barcodeList[index]["Item_Name"].toString().trimLeft()}"),
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

  Future<void> scanBarcode(String field, int index) async {
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
          Provider.of<Controller>(context, listen: false).smantext[index].text =
              _scanBarcode.toString().trim();
          print(
              'sales vaaaaaaaaaaal${Provider.of<Controller>(context, listen: false).smantext[index].text}');
          await Provider.of<Controller>(context, listen: false).searchSalesMan(
              Provider.of<Controller>(context, listen: false)
                  .smantext[index]
                  .text);
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
