import 'package:floor_billing/SCREENs/FLOORBILL/1deliverybill.dart';
import 'package:floor_billing/SCREENs/FLOORBILL/HOME/homeFloorBilling.dart';
import 'package:floor_billing/SCREENs/FLOORBILL/deliverybill.dart';
import 'package:floor_billing/components/textfldCommon.dart';
import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  List l = ['Floor Bill', 'Delivery Bill', 'Free/alot Slot', 'Item Search'];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.yellow,
      //   elevation: 0,
      // ),
      body: SafeArea(
          child: Center(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: l.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    child: Container(
                      height: 60,
                      width: 250,
                      decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple,
                Colors.black87,
              ],
              stops: [0.112, 0.789],
            ),),
                   
                      child: Center(
                        child: Text(
                          l[index].toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeFloorBill()),
                        );
                      } else if (index == 1) {
                        Provider.of<Controller>(context, listen: false)
                            .getDeliveryBillList(0);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FirstDeleveryBill()),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              );
            }),
      )),
    ));
  }
}