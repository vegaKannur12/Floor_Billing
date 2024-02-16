import 'package:floor_billing/SUNMI/sunmi.dart';
import 'package:floor_billing/components/printclass.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FloorBill extends StatefulWidget {
  const FloorBill({super.key});

  @override
  State<FloorBill> createState() => _FloorBillState();
}

class _FloorBillState extends State<FloorBill> {
  String date="";
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
            return ListView.builder(
              itemCount: value.fbList.length,
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
                                    value.fbList[index]['Series'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                              Text(
                                "FB# ${value.fbList[index]['FB_No']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          Text(
                            value.fbList[index]['Slot_Name'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
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
                                    value.fbList[index]['CardNo'].toString(),
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
                                    value.fbList[index]['Cus_Phone'].toString(),
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
                                    value.fbList[index]['Cus_Name'].toString(),
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
                                    "\u20B9 ${value.fbList[index]['Amount'].toString()}",
                                    // widget.slotname,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
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
                              value.fbList[index]['Cancelled'] != 0
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
                                              color: value.fbList[index]
                                                          ['Billed'] ==
                                                      0
                                                  ? Colors.white
                                                  : Colors.amber,
                                              border: Border.all(
                                                  color: Colors.black54)),
                                          child: Center(child: Text("Billed")),
                                        ),
                                        SizedBox(width: 3),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: value.fbList[index]
                                                          ['Paid'] ==
                                                      0
                                                  ? Colors.white
                                                  : Colors.blue,
                                              border: Border.all(
                                                  color: Colors.black54)),
                                          height: 30,
                                          width: size.width / 4.2,
                                          child: Center(child: Text("Paid")),
                                        ),
                                        SizedBox(width: 3),
                                        Container(
                                          height: 30,
                                          width: size.width / 4.2,
                                          decoration: BoxDecoration(
                                              color: value.fbList[index]
                                                          ['Delivered'] ==
                                                      0
                                                  ? Colors.white
                                                  : Colors.green,
                                              border: Border.all(
                                                  color: Colors.black54)),
                                          child:
                                              Center(child: Text("Delivered")),
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
                              .getprintingFBdetails(date.toString(),value.fbList[index]['Series'],value.fbList[index]['Card_ID'],value.fbList[index]['FB_No']);
                               PrintReport printer = PrintReport();
                                  printer.printReport(
                                      value.printingList);
                              
                              
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
                          )
                        ],
                      ),
                    ]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
