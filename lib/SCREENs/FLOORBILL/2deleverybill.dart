import 'package:floor_billing/components/custom_snackbar.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';

class DeliveryBillWidget extends StatefulWidget {
  Map<int, List<Map<String, dynamic>>> dellist;
  DeliveryBillWidget({required this.dellist});
  @override
  State<DeliveryBillWidget> createState() => _DeliveryBillWidgetState();
}

class _DeliveryBillWidgetState extends State<DeliveryBillWidget> {
  String date = "";

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

    return Consumer<Controller>(
      builder: (context, value, child) =>
      widget.dellist.isEmpty
          ? Container(
              height: size.height * 0.8,
              child: Center(
                  child: LottieBuilder.asset(
                "assets/noData.json",
                height: size.height * 0.24,
              )))
          :
       ListView.builder(
        shrinkWrap: true,
        itemCount: widget.dellist.length,
        itemBuilder: (context, index) {
          int key = widget.dellist.keys.elementAt(index);
          List<Map<String, dynamic>> list = widget.dellist[key]!;

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
                        'BillNo# $key \u20B9',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Row(
                        children: [
                          Text(
                            "${list[0]['Amount'].toStringAsFixed(2)} \u20B9 ",
                            // widget.slotname,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               Row(
                                children: [ Row(
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
                                ), SizedBox(
                                      width: 40,
                                    ),
                                Row(children: [
                                  Image.asset(
                                        "assets/bagimg.png",
                                        color: Color.fromARGB(255, 61, 131, 63),
                                        height: 27,
                                        width: 27,
                                      ),
                                      Text(item['Slot_Name'].toString().trimLeft(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),)
                                ],),],),
                                Text("FB# ${item['Fb_No'].toString()}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500))
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
                              Provider.of<Controller>(context, listen: false)
                                  .getDelivery(key, context);
                              CustomSnackbar snackbar = CustomSnackbar();
                              snackbar.showSnackbar(
                                  context, "Item Delevered...", "");
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
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
            ),
          );
        },
      ),
    );
  }
}
