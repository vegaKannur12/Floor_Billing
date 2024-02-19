import 'package:floor_billing/SCREENs/FLOORBILL/2deleverybill.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FirstDeleveryBill extends StatefulWidget {
  const FirstDeleveryBill({super.key});

  @override
  State<FirstDeleveryBill> createState() => _FirstDeleveryBillState();
}

class _FirstDeleveryBillState extends State<FirstDeleveryBill> {
  TextEditingController seacrh = TextEditingController();
  @override
  Widget build(BuildContext context) {

     Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color.fromARGB(255, 220, 228, 111),
        title: Text("DELIVERY BILL"),
      ),
      body: Consumer<Controller>(
        builder: (context, value, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 50,
                width: size.width,
                child: TextFormField(
                  controller: seacrh,
                  //   decoration: const InputDecoration(,
                  onChanged: (val) {
                    Provider.of<Controller>(context, listen: false)
                        .searchItem(val);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                      icon: new Icon(Icons.cancel),
                      onPressed: () {
                        seacrh.clear();
                        Provider.of<Controller>(context, listen: false)
                            .searchItem("");
                      },
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    // filled: true,
                    hintStyle: TextStyle(color: Colors.black, fontSize: 13),
                    hintText: "Search Bill Number",
                    // fillColor: Colors.grey[100]
                  ),
                ),
              ),
            ),
            Expanded(child: DeliveryBillWidget())
          ],
        ),
      ),
    );
  }
}
