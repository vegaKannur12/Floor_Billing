import 'package:floor_billing/SCREENs/FLOORBILL/floorBill2.dart';
import 'package:floor_billing/SUNMI/sunmi.dart';
import 'package:floor_billing/components/printclass.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FloorBill extends StatefulWidget {
  const FloorBill({super.key});

  @override
  State<FloorBill> createState() => _FloorBillState();
}

class _FloorBillState extends State<FloorBill> {
  String date = "";
  TextEditingController seacrh = TextEditingController();
  String _scanBarcode = 'Unknown';
  @override
  void initState() {
    // TODO: implement initState
    date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    print("dateeeeeeeeeeeeeee= $date");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color.fromARGB(255, 220, 228, 111),
        title: Text("FLOOR BILL DETAILS"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) {
            return Column(
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
                          onChanged: (val) {
                            Provider.of<Controller>(context, listen: false)
                                .searchCard(val);
                            setState(() {});
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
                                Provider.of<Controller>(context, listen: false)
                                    .searchCard("");
                              },
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0),
                            ),
                            // filled: true,
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 13),
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
                value.fbListLoading
                    ? Expanded(
                        child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ))
                    : value.isSearch ||value.fbListLoading
                        ? Expanded(
                            child: FloorBillWidget(list: value.fbResulList),
                          )
                        : Expanded(
                            child: FloorBillWidget(list: value.fbList),
                          )
                //  Expanded(child: FloorBillWidget())
              ],
            );
          },
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
              .searchCard(seacrh.text);
          setState(() {});
        }
      });
    } on PlatformException {
      _scanBarcode = "hugugu";
    }
  }
}
