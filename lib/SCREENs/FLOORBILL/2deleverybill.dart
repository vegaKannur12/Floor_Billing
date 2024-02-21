import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class DeliveryBillWidget extends StatefulWidget {
  DeliveryBillWidget();
  @override
  State<DeliveryBillWidget> createState() => _DeliveryBillWidgetState();
}

class _DeliveryBillWidgetState extends State<DeliveryBillWidget> {
  String date = "";

  @override
  void initState() {
    date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    print("dateeeeeeeeeeeeeee= $date");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<Controller>(
      builder: (context, value, child) => ListView.builder(
        shrinkWrap: true,
        itemCount: value.resultList.length,
        itemBuilder: (context, index) {
          int key = value.resultList.keys.elementAt(index);
          List<Map<String, dynamic>> list = value.resultList[key]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$key',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
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
                  return Card(
                    child: ListTile(
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    item['CardNo'].toString().trimLeft(),
                                    // widget.slotname,
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                              Text("FB# ${item['Fb_No'].toString()}")
                            ],
                          ),
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
                                "\u20B9 ${item['Amount'].toStringAsFixed(2)}",
                                // widget.slotname,
                                style: TextStyle(fontSize: 18),
                              )
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
                color: Colors.blueGrey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: value.slotIds.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 40,
                                height: 50,
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      "assets/bagimg.png",
                                      color: Colors.yellow,
                                      height: 40,
                                      width: 40,
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          value.slotIds[index].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            // // Provider.of<Controller>(context,
                            // //         listen: false)
                            // //     .getLogin(username.text, password.text,
                            // //         context);
                             Provider.of<Controller>(context, listen: false)
                                .getDelivery(key);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: Text(
                              "DELIVER",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
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
          );
        },
      ),
    );
  }
}
