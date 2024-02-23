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

class Menus {
  final String iconname;
  final String iconimg;
  Menus({required this.iconname, required this.iconimg});
}

class _MainHomeState extends State<MainHome> {
  List<Menus> l = [
    Menus(iconname: 'CREATE CUSTOMER', iconimg: 'assets/Cus.png'),
    Menus(iconname: 'FLOOR BILL', iconimg: 'assets/Fb.png'),
    Menus(iconname: 'DELIVERY BILL', iconimg: 'assets/Del.png'),
  // Menus(iconname: 'FREE/ALOT SlOT', iconimg: 'assets/lock.png'),
  // Menus(iconname: 'FREE/ALOT SlOT', iconimg: 'assets/lock.png'),
  // Menus(iconname: 'ITEM SEARCH', iconimg: 'assets/lock.png'),
  
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
      backgroundColor: Colors.amber,
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
                      height: 100,
                      width: 280,
                     
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                         color: Colors.amber,
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 40,width: 40,
                                child: Image.asset(l[index].iconimg.toString(),)),
                                SizedBox(width: 20,),
                              Text(
                                l[index].iconname.toString(),
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (index == 0) {
                        // Provider.of<Controller>(context, listen: false)
                        //     .getDeliveryBillList(0,context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ADDCUSTOMER()),
                        );
                      }
                     else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeFloorBill()),
                        );
                      } else if(index == 2) {
                        Provider.of<Controller>(context, listen: false)
                            .getDeliveryBillList(0, context);
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
