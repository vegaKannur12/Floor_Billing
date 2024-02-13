import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BagwiseItems extends StatefulWidget {
  final String slotname;
  const BagwiseItems({super.key, required this.slotname});

  @override
  State<BagwiseItems> createState() => _BagwiseItemsState();
}

class _BagwiseItemsState extends State<BagwiseItems> {
  double totl = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color.fromARGB(255, 220, 228, 111),
        title: Consumer<Controller>(
            builder: (BuildContext context, Controller value, Widget? child) =>
                Text(
                  widget.slotname,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )),
      ),
      bottomNavigationBar: Container(
        child: Text(totl.toStringAsFixed(2)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) {
            return ListView.builder(
              itemCount: value.itemSortedList.length,
              itemBuilder: (context, index) {
                int key = value.itemSortedList.keys.elementAt(index);
                List<Map<String, dynamic>> list = value.itemSortedList[key]!;
                totl = totl + double.parse(list[index]['Amount'].toString());
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
                          widget.slotname,
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

                        print(totl);
                        return Card(
                          child: ListTile(
                            title: Text(item['Item_Name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['Barcode'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Rate: ${item['Rate']}'),
                                    Text('Qty: ${item['Qty']}'),
                                  ],
                                ),
                                Text('\u20B9 ${item['Amount']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                            ),
                            // Add more information if needed
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
