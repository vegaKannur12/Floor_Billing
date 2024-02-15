import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewCartPage extends StatefulWidget {
  const ViewCartPage({super.key});

  @override
  State<ViewCartPage> createState() => _ViewCartPageState();
}

class _ViewCartPageState extends State<ViewCartPage> {
  String date = "";
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
                        value.card_id.toString().toUpperCase(),
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
      bottomNavigationBar:Provider.of<Controller>(context, listen: false).unsavedList.isEmpty?Container(): Container(
        padding: EdgeInsets.only(bottom: 20, left: 10, right: 10, top: 10),
        height: 80,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: Consumer<Controller>(
            builder: (context, value, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      value.unsaved_tot.toStringAsFixed(2),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            textStyle: TextStyle(fontSize: 18)),
                        onPressed: () {
                          Provider.of<Controller>(context, listen: false)
                              .savefloorbill(date.toString());
                          Provider.of<Controller>(context, listen: false)
                              .getUsedBagsItems(context, date.toString(), 0);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Item saved",
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
                                    child: const Text('Ok'),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.shopping_cart),
                        label: Text("SAVE CART"))
                  ],
                )),
      ),
      body: Consumer<Controller>(
        builder: (BuildContext context, Controller value, Widget? child) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: value.unsavedList.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: ListTile(
                              title: Text(
                                "${value.unsavedList[index]["Prod_Name"].toString()}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.brown),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\u20B9 ${value.unsavedList[index]["Cart_Rate"].toString()} ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${value.unsavedList[index]["Cart_Qty"].toString()} ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          Text("Nos.")
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
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Total : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22),
                                          ),
                                          Text(
                                            "\u{20B9}${value.unsavedList[index]["Total"].toString()}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
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
                                                        'Delete ${value.unsavedList[index]["Prod_Name"]}?'),
                                                    actions: <Widget>[
                                                      new TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop(
                                                                  false); // dismisses only the dialog and returns false
                                                        },
                                                        child: Text('No'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Provider.of<Controller>(context, listen: false).updateCart(
                                                              context,
                                                              date.toString(),
                                                              value.unsavedList[index]["Cart_Sm_Code"]
                                                                  .toString(),
                                                              value.unsavedList[index]
                                                                  ["Cart_Row"],
                                                              value
                                                                  .unsavedList[index]
                                                                      [
                                                                      "Cart_Batch"]
                                                                  .toString()
                                                                  .trim(),
                                                              double.parse(value
                                                                  .unsavedList[index]
                                                                      [
                                                                      "Cart_Qty"]
                                                                  .toString()),
                                                              double.parse(value
                                                                  .unsavedList[index]
                                                                      ["Cart_Disc_Per"]
                                                                  .toString()),
                                                              1);
                                                          Provider.of<Controller>(
                                                                  context,
                                                                  listen: false)
                                                              .getUnsavedCart(
                                                                  context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Yes'),
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
                        )));
              });
        },
      ),
    );
  }
}
