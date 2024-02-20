import 'package:floor_billing/components/printclass.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class FloorBillWidget extends StatefulWidget {
  List list;
  FloorBillWidget({required this.list});
  @override
  State<FloorBillWidget> createState() => _FloorBillWidgetState();
}

class _FloorBillWidgetState extends State<FloorBillWidget> {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 30,
                          width: 40,
                          color: Color.fromARGB(255, 224, 235, 166),
                          child: Center(
                            child: Text(
                              widget.list[index]['Series'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                        Text(
                          "FB# ${widget.list[index]['FB_No']}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                    Text(
                      widget.list[index]['Slot_Name'].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
                Divider(),
                Column(
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
                              widget.list[index]['CardNo'].toString(),
                              // widget.slotname,
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/ph.png",
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.list[index]['Cus_Phone'].toString(),
                              // widget.slotname,
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/name.png",
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.list[index]['Cus_Name'].toString(),
                              // widget.slotname,
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/amt.png",
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "\u20B9 ${widget.list[index]['Amount'].toString()}",
                              // widget.slotname,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        widget.list[index]['Cancelled'] != 0
                            ? Container(
                                height: 30,
                                width: size.width / 1.4,
                                color: Colors.red,
                                child: Center(
                                    child: Text("Cancelled",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15))),
                              )
                            : Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: size.width / 4.2,
                                    decoration: BoxDecoration(
                                        color: widget.list[index]
                                                    ['Billed'] ==
                                                0
                                            ? Colors.white
                                            : Colors.amber,
                                        border:
                                            Border.all(color: Colors.black54)),
                                    child: Center(child: Text("Billed")),
                                  ),
                                  SizedBox(width: 3),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: widget.list[index]
                                                    ['Paid'] ==
                                                0
                                            ? Colors.white
                                            : Colors.blue,
                                        border:
                                            Border.all(color: Colors.black54)),
                                    height: 30,
                                    width: size.width / 4.2,
                                    child: Center(child: Text("Paid")),
                                  ),
                                  SizedBox(width: 3),
                                  Container(
                                    height: 30,
                                    width: size.width / 4.2,
                                    decoration: BoxDecoration(
                                        color: widget.list[index]
                                                    ['Delivered'] ==
                                                0
                                            ? Colors.white
                                            : Colors.green,
                                        border:
                                            Border.all(color: Colors.black54)),
                                    child: Center(child: Text("Delivered")),
                                  ),
                                ],
                              ),
                        SizedBox(width: 3),
                        IconButton(
                          icon: Image.asset(
                            "assets/print.png",
                            height: 30,
                            width: 20,
                          ),
                          onPressed: () {
                            Provider.of<Controller>(context, listen: false)
                                .getprintingFBdetails(
                                    date.toString(),
                                    widget.list[index]['Series'],
                                    widget.list[index]['Card_ID'],
                                    widget.list[index]['FB_No']);
                            PrintReport printer = PrintReport();
                            printer.printReport(value.printingList);

                            // Navigator.push(
                            // context,
                            // MaterialPageRoute(
                            //     builder: (context) => SunmiHome()),
                            // );
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    widget.list[index]['Billed'] != 0
                        ? Row(
                            children: [
                              Text(
                                "BillNo#${widget.list[index]['Billed'].toString()}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue),
                              ),
                            ],
                          )
                        : SizedBox()
                  ],
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
