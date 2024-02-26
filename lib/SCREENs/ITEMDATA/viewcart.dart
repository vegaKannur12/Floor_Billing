import 'package:floor_billing/components/printclass.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewCartPage extends StatefulWidget {
  final String cardno;
  final String bagno;
  ViewCartPage({super.key, required this.cardno, required this.bagno});

  @override
  State<ViewCartPage> createState() => _ViewCartPageState();
}

class _ViewCartPageState extends State<ViewCartPage> {
  String date = "";
  bool _printDialogShown = false;
  void initState() {
    super.initState();
    date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    print("dateeeeeeeeeeeeeee= $date");
    //  FunctionUtils.runFunctionPeriodically(context);
    // smanfocus.addListener(() {
    //   if (!smanfocus.hasFocus) {
    //     salespresent();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    //  Provider.of<Controller>(context, listen: false).getUnsavedCart(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color.fromARGB(255, 220, 228, 111),
        title: Consumer<Controller>(
            builder: (BuildContext context, Controller value, Widget? child) =>
                Text(
                  value.cart_id.toString(),
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
                        "${widget.cardno.toString()}/${widget.bagno.toString()}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Consumer<Controller>(
        builder: (context, value, child) => Container(
          padding: EdgeInsets.only(bottom: 20, left: 10, right: 10, top: 10),
          height: 80,
          width: size.width,
          decoration: BoxDecoration(
            color: Provider.of<Controller>(context, listen: false)
                    .unsavedList
                    .isEmpty
                ? Colors.white
                : Colors.amber,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: value.unsavedList.isEmpty
              ? Row()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "\u{20B9} ${value.unsaved_tot.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    ),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            textStyle: TextStyle(fontSize: 18)),
                        onPressed: () {
                          Provider.of<Controller>(context, listen: false)
                              .savefloorbill(date.toString(), context);
                          Provider.of<Controller>(context, listen: false)
                              .getUsedBagsItems(context, date.toString(), 0);
                          Provider.of<Controller>(context, listen: false)
                              .getUnsavedCart(context);
                          if (!_printDialogShown) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Want Print ?",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: const Text('No'),
                                      onPressed: () async {
                                        Provider.of<Controller>(context,
                                                listen: false)
                                            .clearCardID("0");
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, '/floorhome');
                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: const Text('Yes'),
                                      onPressed: () async {
                                        Provider.of<Controller>(context,
                                                listen: false)
                                            .clearCardID("0");
                                        PrintReport printer = PrintReport();
                                        printer.printReport(
                                            value.printingList, "bill");
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, '/floorhome');
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            _printDialogShown = true;
                          }
                          // setState(() {});
                        },
                        icon: Icon(Icons.shopping_cart),
                        label: Text("SAVE CART"))
                  ],
                ),
        ),
      ),
      body: Consumer<Controller>(
        builder: (BuildContext context, Controller value, Widget? child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                value.cartloading
                            ? Expanded(
                                child: SpinKitCircle(
                                size: 50,
                                color: Colors.blue,
                              )):
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: value.unsavedList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black38),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      child: ListTile(
                                        title: Text(
                                          "${value.unsavedList[index]["Prod_Name"].toString().trimLeft()}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.brown),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "\u20B9 ${value.unsavedList[index]["Cart_Rate"].toStringAsFixed(2)} ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${value.unsavedList[index]["Cart_Qty"].toString()} ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("Discount: "),
                                                Text(
                                                    "\u20B9 ${value.unsavedList[index]["DiscValue"].toString()}"),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Total : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 22),
                                                    ),
                                                    Text(
                                                      "\u{20B9}${value.unsavedList[index]["Total"].toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 22,
                                                          color: Colors.green),
                                                    ),
                                                  ],
                                                ),
                                                InkWell(
                                                    onTap: () async {
                                                      await showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              content: Text(
                                                                  'Delete ${value.unsavedList[index]["Prod_Name"].toString().trimLeft()}?'),
                                                              actions: <Widget>[
                                                                new TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context,
                                                                            rootNavigator:
                                                                                true)
                                                                        .pop(
                                                                            false); // dismisses only the dialog and returns false
                                                                  },
                                                                  child: Text(
                                                                      'No'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Provider.of<Controller>(context, listen: false).updateCart(
                                                                        context,
                                                                        date
                                                                            .toString(),
                                                                        value.unsavedList[index]["Cart_Sm_Code"]
                                                                            .toString(),
                                                                        value.unsavedList[index]
                                                                            [
                                                                            "Cart_Row"],
                                                                        value
                                                                            .unsavedList[index][
                                                                                "Cart_Batch"]
                                                                            .toString()
                                                                            .trim(),
                                                                        double.parse(value
                                                                            .unsavedList[index][
                                                                                "Cart_Qty"]
                                                                            .toString()),
                                                                        double.parse(value
                                                                            .unsavedList[index]["Cart_Disc_Per"]
                                                                            .toString()),
                                                                        1);
                                                                    Provider.of<Controller>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getUnsavedCart(
                                                                            context);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      'Yes'),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ));
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}
