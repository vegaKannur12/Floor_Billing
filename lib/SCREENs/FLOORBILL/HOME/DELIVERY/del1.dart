import 'package:floor_billing/SCREENs/FLOORBILL/2deleverybill.dart';
import 'package:floor_billing/SCREENs/FLOORBILL/HOME/DELIVERY/del2.dart';
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
    // Provider.of<Controller>(context, listen: false)
    //     .getDeliveryBillList(0, context);
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
                      controller: seacrh,
                      //   decoration: const InputDecoration(,
                      onFieldSubmitted: (_) {
                        Provider.of<Controller>(context, listen: false)
                            .getDELList(int.parse(seacrh.text), context);
                        // Provider.of<Controller>(context, listen: false)
                        //     .searchDelevery(val);
                        setState(() {});
                      },
                      // onChanged: (val) {
                      //   Provider.of<Controller>(context, listen: false)
                      //   .getDELList(int.parse(seacrh.text), context);
                      //   // Provider.of<Controller>(context, listen: false)
                      //   //     .searchDelevery(val);
                      //   setState(() {});
                      // },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        suffixIcon: IconButton(
                          icon: new Icon(Icons.cancel),
                          onPressed: () {
                            seacrh.clear();
                            Provider.of<Controller>(context, listen: false)
                                .getDELList(0, context);
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
                        hintText: "Search Card Number",
                        // fillColor: Colors.grey[100]
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
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
            ),

            //  value.isDelSearch
            //           ? Expanded(
            //               child: DeliveryBillWid(list: value.delResulList),
            //             )
            //           :

            Expanded(
                child: ListView.builder(
                    itemCount: value.delWidget.length,
                    itemBuilder: (BuildContext context, int index) {
                      return value.delWidget[index];
                    }))

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
              .getDELList(int.parse(seacrh.text), context);

          setState(() {});
        }
      });
    } on PlatformException {
      _scanBarcode = "hugugu";
    }
  }
}
