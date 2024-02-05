import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:floor_billing/components/sizeScaling.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:floor_billing/db_helper.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? date;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<Controller>(context, listen: false).getTableList();
      // // Provider.of<Controller>(context, listen: false)
      // //     .qtyadd();           //tempry adding qty

      // Provider.of<Controller>(context, listen: false).getOs();
    });
    date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  }

  TextEditingController seacrh = TextEditingController();
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
                  value.os.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                )),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  date.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // IconButton(
          //   onPressed: () async {
          //     // List<Map<String, dynamic>> list =
          //     //     await KOT.instance.getListOfTables();
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) => TableList(list: list)),
          //     // );
          //   },
          //   icon: Icon(Icons.table_bar, color: Colors.green),
          // ),
        ],
      ),
    
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<Controller>(
          builder: (context, value, child) => Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextFormField(
                  controller: seacrh,
                  //   decoration: const InputDecoration(,
                  onChanged: (val) {
                    // Provider.of<Controller>(context, listen: false)
                    //     .searchTable(val.toString());
                  },
                  decoration: InputDecoration(
                      // prefixIcon: Icon(
                      //   Icons.search,
                      //   color: Colors.blue,
                      // ),
                      suffixIcon: IconButton(
                        icon: new Icon(Icons.search),
                        onPressed: () {
                         
                        },
                      ),
                      hintText: "Card Number"),
                ),
                const SizedBox(
                  height: 15,
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }

// ItemList(catlId: map["catid"],catName: map["catname"],)
/////////////////////////////////////////////////////////////////
}
