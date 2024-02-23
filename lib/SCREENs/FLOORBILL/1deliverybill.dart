import 'package:floor_billing/SCREENs/FLOORBILL/2deleverybill.dart';
import 'package:floor_billing/components/custom_snackbar.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class FirstDeleveryBill extends StatefulWidget {
  const FirstDeleveryBill({super.key});

  @override
  State<FirstDeleveryBill> createState() => _FirstDeleveryBillState();
}

class _FirstDeleveryBillState extends State<FirstDeleveryBill> {
  TextEditingController seacrh = TextEditingController();
  String _scanBarcode = 'Unknown';
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<Controller>(context, listen: false)
        .getDeliveryBillList(0, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color.fromARGB(255, 220, 228, 111),
        title: Text("DELIVERY BILL"),
      ),
      body: Consumer<Controller>(
        builder: (context, value, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: size.width / 1.4,
                    child: TextFormField(
                      onFieldSubmitted: (_) {
                        Provider.of<Controller>(context, listen: false)
                            .getDeliveryBillList(
                                int.parse(seacrh.text), context);
                      },
                      controller: seacrh,
                      //   decoration: const InputDecoration(,
                      onChanged: (val) {
                        // Provider.of<Controller>(context, listen: false)
                        //     .searchItem(val);
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        suffixIcon: IconButton(
                          icon: new Icon(Icons.cancel),
                          onPressed: () {
                            seacrh.clear();

                            // Provider.of<Controller>(context, listen: false)
                            //     .searchItem("");
                          },
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        // filled: true,
                        hintStyle: TextStyle(color: Colors.black, fontSize: 13),
                        hintText: "Search Bill Number",
                        // fillColor: Colors.grey[100]
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 14,
                  // ),
                  // IconButton(
                  //   icon: Image.asset(
                  //     "assets/barscan.png",
                  //     height: 40,
                  //     width: 30,
                  //   ),
                  //   onPressed: () {
                  //     scanBarcode("card");
                  //   },
                  // ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: value.resultList.length,
                itemBuilder: (context, index) 
                {
                  int key = value.resultList.keys.elementAt(index);
                  List<Map<String, dynamic>> list = value.resultList[key]!;
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'BillNo# $key ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${list[0]['Amount'].toStringAsFixed(2)} \u20B9 ",
                                    // widget.slotname,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, listIndex) {
                            // slotIds = list.map((map) => map["Slot_ID"]).toList();
                            // slotIds=getUniqueSlotIDs(lb);
                            Set<int> uniqueSlotIDs = Set<int>();
                            for (var item in list) {
                              if (item.containsKey('Slot_ID')) {
                                uniqueSlotIDs.add(item['Slot_ID']);
                              }
                            }

                            value.setslotID(uniqueSlotIDs.toList());
                            //  value.slotIds = uniqueSlotIDs.toList();
                            Map<String, dynamic> item = list[listIndex];
                            return Container(
                              height: 40,
                              child: ListTile(
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/card.png",
                                                  height: 20,
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  item['CardNo']
                                                      .toString()
                                                      .trimLeft(),
                                                  // widget.slotname,
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              width: 40,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/bagimg.png",
                                                  color: Color.fromARGB(
                                                      255, 61, 131, 63),
                                                  height: 27,
                                                  width: 27,
                                                ),
                                                Text(
                                                  item['Slot_Name']
                                                      .toString()
                                                      .trimLeft(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text("FB# ${item['Fb_No'].toString()}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  ],
                                ),
                                // Add more information if needed
                              ),
                            );
                          },
                        ),
                        Card(
                          color: Color.fromARGB(255, 193, 207, 214),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // SizedBox(
                                //   height: 50,
                                //   child: ListView.builder(
                                //       shrinkWrap: true,
                                //       scrollDirection: Axis.horizontal,
                                //       itemCount: value.slotIds.length,
                                //       itemBuilder: (context, index) {
                                //         return SizedBox(
                                //           width: 40,
                                //           height: 50,
                                //           child: Stack(
                                //             children: [
                                //               Image.asset(
                                //                 "assets/bagimg.png",
                                //                 color: Colors.yellow,
                                //                 height: 40,
                                //                 width: 40,
                                //               ),
                                //               Positioned.fill(
                                //                 child: Align(
                                //                   alignment: Alignment.center,
                                //                   child: Text(
                                //                     value.slotIds[index].toString(),
                                //                     style: TextStyle(
                                //                         color: Colors.black,
                                //                         fontWeight: FontWeight.w600),
                                //                   ),
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         );
                                //       }),
                                // ),
                                SizedBox(
                                  height: 35,
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // // Provider.of<Controller>(context,
                                      // //         listen: false)
                                      // //     .getLogin(username.text, password.text,
                                      // //         context);
                                      Provider.of<Controller>(context,
                                              listen: false)
                                          .getDelivery(key, context);
                                      CustomSnackbar snackbar =
                                          CustomSnackbar();
                                      snackbar.showSnackbar(
                                          context, "Item Delevered...", "");
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12, bottom: 12),
                                      child: Text(
                                        "DELIVER",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Theme.of(context)
                                                .secondaryHeaderColor),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
            // Expanded(child: DeliveryBillWidget(dellist: value.resultList)),
            // value.isSearch
            //         ? Expanded(
            //             child:
            //           )
            //         : Expanded(
            //             child: DeliveryBillWidget(dellist: value.sortedDelvryList),
            //           )
            // Expanded(child: DeliveryBillWidget())
          ],
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
          seacrh.text = _scanBarcode.toString();
          _scanBarcode = "";
          Provider.of<Controller>(context, listen: false)
              .searchItem(seacrh.text);
          setState(() {});
        }
      });
    } on PlatformException {
      _scanBarcode = "hugugu";
    }
  }
}
