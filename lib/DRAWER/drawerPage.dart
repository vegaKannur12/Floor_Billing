
import 'package:floor_billing/SCREENs/FLOORBILL/HOME/homeFloorBilling.dart';
import 'package:floor_billing/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

List<DrawerlistClass> drawer_list = [
  DrawerlistClass(
      title: "Floor Billing",
      icon: Image.asset(
        "assets/lock.png",
        color: Colors.black54,
      ),
      menuindex: 0),
  DrawerlistClass(
      title: "Other",
      icon: Image.asset(
        "assets/lock.png",
        color: Colors.black54,
      ),
      menuindex: 1),
      DrawerlistClass(
      title: "Logout",
      icon: Image.asset(
        "assets/leave.png",
        color: Colors.black54,
      ),
      menuindex: 2),
 
];

class DrawerlistClass {
  final String title;
  final Image icon;
  final int menuindex;
  DrawerlistClass({
    required this.title,
    required this.icon,
    required this.menuindex,
  });
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  void initState() {
    // TODO: implement initState
    // Provider.of<Controller>(context, listen: false)
    //     .getDailyProductionReport(context);
    // Provider.of<Controller>(context, listen: false)
    //     .getDamageProductionReport(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    int i = -1;
    return Consumer(builder: (BuildContext context, value, Widget? child) {
      return Drawer(
          backgroundColor: Colors.white,
          width: 300,
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  SizedBox(
                    height: 80,
                  ),
                  const Divider(),
                  ...List.generate(
                      drawer_list.length,
                      (index) => Column(
                            children: [
                              InkWell(
                                child: ListTile(
                                  title: Text(
                                    drawer_list[index].title,
                                    style: GoogleFonts.ptSerif(fontSize:20,fontWeight:FontWeight.bold),
                                  ),
                                  leading: index > 1
                                      ? Image.asset(
                                          "assets/leave.png",
                                          color: Colors.black54,height: 30,width: 25,
                                        )
                                      : SizedBox(
                                        height: 25,width: 25,
                                        child: Icon(Icons.circle,color:Colors.black54 ,size: 10,)),
                                  // trailing: SizedBox(
                                  //     height: 35,
                                  //     width: 40,
                                  //     child: drawer_list[index].icon),
                                ),
                                onTap: () {
                                  setState(() {
                                    i = index;
                                    if (i == 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeFloorBill()),
                                      );
                                    } else if (i == 1) {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           LoginPage()),
                                      // );
                                    } else {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              LoginPage()
                                        ),
                                        (Route route) => false,
                                      );
                                    }
                                  });
                                },
                              ),
                              const Divider(),
                            ],
                          ))
                ],
              ),
            ),
          ));
    });
  }
}
