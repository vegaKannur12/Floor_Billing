import 'package:floor_billing/SCREENs/ADDCUST/addcust.dart';
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
  List l = [
    'FLOOR BILL',
    'DELIVERY BILL',
    'FREE/ALOT SlOT',
    'ITEM SEARCH',
    'CREATE CUSTOMER'
  ];

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
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 49, 83, 121),
                            Colors.black87,
                          ],
                          stops: [0.112, 0.789],
                        ),
                      ),
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
                      else if (index == 4) {
                        Provider.of<Controller>(context, listen: false)
                            .getDeliveryBillList(0);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ADDCUSTOMER()),
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
