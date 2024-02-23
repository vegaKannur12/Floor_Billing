import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DeliveryBill extends StatefulWidget {
  const DeliveryBill({super.key});

  @override
  State<DeliveryBill> createState() => _DeliveryBillState();
}

class _DeliveryBillState extends State<DeliveryBill> {
  String date = "";
  List slotIds = [];
  Set<int> uniqueSlotIDs = Set<int>();
  @override
   void initState() {
    // TODO: implement initState
     date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    print("dateeeeeeeeeeeeeee= $date");
       Provider.of<Controller>(context, listen: false).getDeliveryBillList(0,context);
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Color.fromARGB(255, 220, 228, 111),
          title: Text("DELIVERY BILL DETAILS"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<Controller>(
            builder: (BuildContext context, Controller value, Widget? child) {
              return ListView.builder(
                itemCount: value.sortedDelvryList.length,
                itemBuilder: (context, index) {
                  int key = value.sortedDelvryList.keys.elementAt(index);
                  List<Map<String, dynamic>> list =
                      value.sortedDelvryList[key]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$key',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
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
                          
                          for (var item in list) {
                            if (item.containsKey('Slot_ID')) {
                              uniqueSlotIDs.add(item['Slot_ID']);
                            }
                          }
                          slotIds=uniqueSlotIDs.toList();
                          Map<String, dynamic> item = list[listIndex];

                          return Card(
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
                                          Image.asset(
                                            "assets/card.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            item['CardNo'].toString(),
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/bagimg.png",
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 50,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: slotIds.length,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        width: 40,
                                        height: 50,
                                        child: Row(
                                          children: [
                                            Row(
                                              children: [
                                                Text(slotIds[index].toString()),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              ),
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
              );
            },
          ),
        ));
  }

  List<int> getUniqueSlotIDs(List<Map<String, dynamic>> list) {
    Set<int> uniqueSlotIDs = Set<int>();

    for (var item in list) {
      if (item.containsKey('Slot_ID')) {
        uniqueSlotIDs.add(item['Slot_ID']);
      }
    }

    return uniqueSlotIDs.toList();
  }
}
