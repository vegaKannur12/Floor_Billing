import 'package:floor_billing/components/custom_snackbar.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ADDCUSTOMER extends StatefulWidget {
  const ADDCUSTOMER({super.key});

  @override
  State<ADDCUSTOMER> createState() => _ADDCUSTOMERState();
}

class _ADDCUSTOMERState extends State<ADDCUSTOMER> {
  String date = "";
  // TextEditingController cardno = TextEditingController();
  // TextEditingController custname = TextEditingController();
  // TextEditingController custphon = TextEditingController();
  TextEditingController bagno = TextEditingController();
  TextEditingController itemname = TextEditingController();
  TextEditingController rate = TextEditingController();
  FocusNode cardfocus = FocusNode();
  FocusNode bagFocus = FocusNode();
  String _scanBarcode = 'Unknown';
  String ep = "";

  @override
  void initState() {
    super.initState();
    // FunctionUtils.runFunctionPeriodically(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Controller>(context, listen: false).clearCardID("0");
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
          // Provider.of<Controller>(context, listen: false).setcusnameAndPhone(
          //     Provider.of<Controller>(context, listen: false).ccname.text,
          //     Provider.of<Controller>(context, listen: false).ccfon.text,
          //     context);
          // Provider.of<Controller>(context, listen: false)
          //     .getBagDetails(bagno.text.toString(), context, "home");
          // Provider.of<Controller>(context, listen: false)
          //     .setBagNo(bagno.text.toString());
        }
      });
    });
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color.fromARGB(255, 220, 228, 111),
        title: Consumer<Controller>(
            builder: (BuildContext context, Controller value, Widget? child) =>
                Text(
                  "CREATE NEW CUSTOMER",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )),
      ),
      body: Consumer<Controller>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: 10,
              ),
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
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 60,
                child: TextFormField(
                  ignorePointers: value.showadduser ? true : false,
                  focusNode: cardfocus,
                  controller: value.cardNoctrl,
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
                  // ignorePointers: value.typlock?true:false,
                  keyboardType: TextInputType.phone,
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
                height: 55,
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
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (value.ccname.text == "" || value.ccfon.text == "") {
                        ep = "Please enter Name & Contact";
                        value.setaDDUserError("Please enter Name & Contact");
                        CustomSnackbar snackbar = CustomSnackbar();
                        // ignore: use_build_context_synchronously
                        snackbar.showSnackbar(
                            context, "Please enter Name & Contact", "");
                      } else if (value.ccfon.text.length != 10) {
                        ep = 'Please Enter Valid Phone No ';
                        value.setaDDUserError("Please Enter Valid Phone No");
                        CustomSnackbar snackbar = CustomSnackbar();
                        // ignore: use_build_context_synchronously
                        snackbar.showSnackbar(
                            context, "Please Enter Valid Phone No", "");
                      } else {
                        value.createFloorCardsNew(
                            date, value.ccname.text, value.ccfon.text, context);

                            // value.ccname.clear();
                            // value.ccfon.clear();
                            showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Customer Added ",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('OK'),
                  onPressed: () async {
                    
                        Provider.of<Controller>(context, listen: false)
                            .clearCardID("0");
                            Provider.of<Controller>(context, listen: false).setcusnameAndPhone("", "", context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "NEW",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Theme.of(context).secondaryHeaderColor),
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
                  ElevatedButton(
                    onPressed: () {},
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "PRINT",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            "assets/print.png",
                            color: Colors.black,
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ]),
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
        // if (field == "card") {
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
        // }
        // else {
        //   bagno.text = _scanBarcode.toString();
        //   _scanBarcode = "";
        //   Provider.of<Controller>(context, listen: false)
        //       .getBagDetails(bagno.text.toString(), context, "home");
        // }
      });
    } on PlatformException {
      _scanBarcode = "hugugu";
    }
  }
}
