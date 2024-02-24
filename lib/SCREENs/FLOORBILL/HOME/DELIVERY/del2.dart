import 'package:floor_billing/components/printclass.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class DeliveryBillWid extends StatefulWidget {
  List list;
  DeliveryBillWid({required this.list});
  @override
  State<DeliveryBillWid> createState() => _DeliveryBillWidState();
}

class _DeliveryBillWidState extends State<DeliveryBillWid> {
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
      builder: (context, value, child) => widget.list.isEmpty
          ? Container(
              height: size.height * 0.8,
              child: Center(
                  child: LottieBuilder.asset(
                "assets/noData.json",
                height: size.height * 0.24,
              )))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: widget.list.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black45),
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      // Text(widget.list[index].toString())
                    
                      SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.list.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black45),
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(bottom: 10),
                            child: Column(children: [
                                // Text(widget.list[index].toString())
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
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
                                            widget.list[index]['CardNo']
                                                .toString()
                                                .trimLeft(),
                                            // widget.slotname,
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ],
                                      ),
                                      Text(
                                          "FB# ${widget.list[index]['Fb_No'].toString()}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                              ]),
                            
                          );
                        },
                      ),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}
