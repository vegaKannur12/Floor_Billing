import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class BagwiseItems extends StatefulWidget {
  final String cardNumbr;
  const BagwiseItems({super.key, required this.cardNumbr});

  @override
  State<BagwiseItems> createState() => _BagwiseItemsState();
}

class _BagwiseItemsState extends State<BagwiseItems> {
  double totl = 0.0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color.fromARGB(255, 220, 228, 111),
        title: Consumer<Controller>(
            builder: (BuildContext context, Controller value, Widget? child) =>
                Text(
                  widget.cardNumbr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )),
      ),
      bottomNavigationBar: Consumer<Controller>(
        builder: (BuildContext context, Controller value, Widget? child) => value.isbagloading?
            Container()
            :
          Container(
            color: Colors.black,
            height: 40,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "GRAND TOTAL",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "${value.all_total.toStringAsFixed(2)}",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          )
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) =>
            value.isbagloading?
            SpinKitCircle(size: 50,color: Colors.blue,)
            :
          
             ListView.builder(
              itemCount: value.itemSortedList.length,
              itemBuilder: (context, index) {
                totl = 0.0;
                int key = value.itemSortedList.keys.elementAt(index);
                List<Map<String, dynamic>> list = value.itemSortedList[key]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'FB#$key / ${value.os.toString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          list.first['Slot_Name'].toString().trimLeft(),
                          // widget.slotname,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, listIndex) {
                        Map<String, dynamic> item = list[listIndex];
                        totl = totl + double.parse(item['Amount'].toString());
                        print(totl);
                        return Card(
                          child: ListTile(
                            title: Text(item['Item_Name'].toString().trimLeft()),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['Barcode'].toString().trimLeft(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Rate: ${item['Rate']}'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Qty: ${item['Qty']}'),
                                    Text('\u20B9 ${item['Amount']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ],
                                ),
                              ],
                            ),
                            // Add more information if needed
                          ),
                        );
                      },
                    ),
                    Container(
                        padding: EdgeInsets.only(right: 20),
                        height: 40,
                        width: size.width,
                        color: Colors.blue,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                "\u20B9 ${value.floor_totl[key]!.toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)))),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            )
          
        ),
      ),
    );
  }
}
