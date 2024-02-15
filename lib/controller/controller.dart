import 'dart:async';
import 'dart:convert';
import 'package:floor_billing/SCREENs/FLOORBILL/HOME/homeFloorBilling.dart';
import 'package:floor_billing/SCREENs/db_selection.dart';
import 'package:floor_billing/MODEL/registration_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:floor_billing/components/custom_snackbar.dart';
import 'package:floor_billing/components/external_dir.dart';
import 'package:floor_billing/db_helper.dart';
import 'package:floor_billing/MODEL/customer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_conn/sql_conn.dart';
import '../components/network_connectivity.dart';

class Controller extends ChangeNotifier {
  // int? cartNo;
  String? fromDate;
  String? lastdate;
  String? cname;

  bool isSearch = false;
  DateTime? sdate;
  DateTime? ldate;
  String? os;
  String? cName;
  String? fp;
  String? cid;
  ExternalDir externalDir = ExternalDir();
  List<CD> c_d = [];
  String? sof;

  // ignore: prefer_typing_uninitialized_variables
  var jsonEncoded;
  DateTime d = DateTime.now();
  String? todate;

  bool isLoading = false;
  String? appType;
  bool isdbLoading = true;

  // List<Map<String, dynamic>> filteredList = [];

  List<bool> isAdded = [];

  List<Map<String, dynamic>> catlist = [
    {"catid": "C1", "catname": "Category1"},
    {"catid": "C2", "catname": "Category2"},
    {"catid": "C3", "catname": "Category3"},
    {"catid": "C4", "catname": "Category4"},
    {"catid": "C5", "catname": "Category5"},
    {"catid": "C6", "catname": "Category6"},
    {"catid": "C7", "catname": "Category7"},
  ];

  double itemcount = 0.0;

  String? userName;

  List<Map<String, dynamic>> db_list = [];
  bool isYearSelectLoading = false;
  bool isLoginLoading = false;
  bool isDBLoading = false;
  bool isTableLoading = false;
  bool isCategoryLoading = false;
  bool isItemLoading = false;

  String? catlID = "";
  Timer timer = Timer.periodic(Duration(seconds: 3), (timer) {});

  String u_id = "";
  String card_id = "";
  String disply_name = "";
  String bag_no = "";
  List custDetailsList = [];
  List unsavedList = [];
  List bagDetailsList = [];
  String cus_name = "";
  String cus_contact = "";
  List barcodeList = [];
  List selectedBarcodeList = [];
  String selectedBarcode = "";
  bool findsales = true;
  bool barcodeinvalid = false;
  List<Map<dynamic, dynamic>> salesManlist = [];
  List savedresult = [];
  Map selectedSalesMan = {};
  List<TextEditingController> qty = [];
  List<TextEditingController> persntage = [];
  List<TextEditingController> saved = [];
  TextEditingController ccname = TextEditingController();
  TextEditingController ccfon = TextEditingController();
  TextEditingController cardNoctrl = TextEditingController();
  List<Text> netamt = [];
  bool showdata = false;
  int slot_id = 0;
  Text baggerror = Text("");
  Text salesError = Text("ytuytu");
  Text barcodeerror = Text("");
  Text adduserError = Text("");
  int cart_id = 0;
  double srate = 0.0;
  double unsaved_tot = 0.0;
  List usedbagList = [];
  List usedbagITEMList = [];
  Map<int, double> floor_totl = {};
  double all_total = 0.0;
  Map<int, List<Map<String, dynamic>>> itemSortedList = {};
  int allbagallcount = 0;
  List fbList = [];
  bool showadduser = false;
  bool typlock = false;
  bool tapped=false;
  Future<void> sendHeartbeat() async {
    try {
      if (SqlConn.isConnected) {
        print("connected.........OK");
      } else {
        print("Not  connected.........OK");
      }
    } catch (error) {
      // Handle the error (connection issue)
      print("Connection lost: $error");
      // You can trigger a reconnection here
      // ...
    }
  }

  /////////////////////////////////////////////
  Future<RegistrationData?> postRegistration(
      String companyCode,
      String? fingerprints,
      String phoneno,
      String deviceinfo,
      BuildContext context) async {
    NetConnection.networkConnection(context).then((value) async {
      print("Text fp...$fingerprints---$companyCode---$phoneno---$deviceinfo");
      // ignore: prefer_is_empty
      if (companyCode.length >= 0) {
        appType = companyCode.substring(10, 12);
      }
      if (value == true) {
        try {
          Uri url =
              Uri.parse("https://trafiqerp.in/order/fj/get_registration.php");
          Map body = {
            'company_code': companyCode,
            'fcode': fingerprints,
            'deviceinfo': deviceinfo,
            'phoneno': phoneno
          };
          // ignore: avoid_print
          print("register body----$body");
          isLoading = true;
          notifyListeners();
          http.Response response = await http.post(
            url,
            body: body,
          );
          // print("body $body");
          var map = jsonDecode(response.body);
          // ignore: avoid_print
          print("regsiter map----$map");
          RegistrationData regModel = RegistrationData.fromJson(map);

          sof = regModel.sof;
          fp = regModel.fp;
          String? msg = regModel.msg;

          if (sof == "1") {
            if (appType == 'UY') {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              /////////////// insert into local db /////////////////////
              String? fp1 = regModel.fp;

              // ignore: avoid_print
              print("fingerprint......$fp1");
              prefs.setString("fp", fp!);

              cid = regModel.cid;
              os = regModel.os;
              prefs.setString("cid", cid!);

              cname = regModel.c_d![0].cnme;

              prefs.setString("cname", cname!);
              prefs.setString("os", os!);
              print("cid----cname-----$cid---$cname....$os");
              notifyListeners();

              await externalDir.fileWrite(fp1!);

              // ignore: duplicate_ignore
              for (var item in regModel.c_d!) {
                print("ciddddddddd......$item");
                c_d.add(item);
              }
              // verifyRegistration(context, "");

              isLoading = false;
              notifyListeners();
              prefs.setString("user_type", appType!);
              prefs.setString("db_name", map["mssql_arr"][0]["db_name"]);
              prefs.setString("old_db_name", map["mssql_arr"][0]["db_name"]);
              prefs.setString("ip", map["mssql_arr"][0]["ip"]);
              prefs.setString("port", map["mssql_arr"][0]["port"]);
              prefs.setString("usern", map["mssql_arr"][0]["username"]);
              prefs.setString("pass_w", map["mssql_arr"][0]["password"]);
              prefs.setString("multi_db", map["mssql_arr"][0]["multi_db"]);

              String? user = prefs.getString("userType");
              await BILLING.instance
                  .deleteFromTableCommonQuery("companyRegistrationTable", "");
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DBSelection()),
              );
            } else {
              CustomSnackbar snackbar = CustomSnackbar();
              // ignore: use_build_context_synchronously
              snackbar.showSnackbar(context, "Invalid Apk Key", "");
            }
          }
          /////////////////////////////////////////////////////
          if (sof == "0") {
            CustomSnackbar snackbar = CustomSnackbar();
            // ignore: use_build_context_synchronously
            snackbar.showSnackbar(context, msg.toString(), "");
          }
          notifyListeners();
        } catch (e) {
          // ignore: avoid_print
          print(e);
          return null;
        }
      }
    });
    return null;
  }

  //////////////////////////////////////////////////////////
  getLogin(String userName, String password, BuildContext context) async {
    try {
      isLoginLoading = true;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? os = prefs.getString("os");

      print("unaaaaaaaaaaammmeeeeeeeee$userName");
      String oo = "Flt_Sp_Verify_User '$os','$userName','$password'";
      print("loginnnnnnnnnnnnnnn$oo");
      //  print("{Flt_Sp_Verify_User '$os','$userName','$password'}");
      // initDb(context, "from login");
      // initYearsDb(context, "");
      var res = await SqlConn.readData(
          "Flt_Sp_Verify_User '$os','$userName','$password'");
      var valueMap = json.decode(res);
      print("item list----------$res");
      if (valueMap != null) {
        print("user dataa----------$res");
        print(
            "UserID >>>>>> ${valueMap[0]["UserID"]}----Displynam>>>>> ${valueMap[0]["Flt_Display_Name"]}");
        prefs.setString("UserID", valueMap[0]["UserID"].toString());
        prefs.setString(
            "Flt_Display_Name", valueMap[0]["Flt_Display_Name"].toString());
        prefs.setString("st_uname", userName);
        prefs.setString("st_pwd", password);
        await getSalesman();
        await setUID();
        // SqlConn.disconnect();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeFloorBill()),
        );
      } else {
        CustomSnackbar snackbar = CustomSnackbar();
        snackbar.showSnackbar(context, "Incorrect Username or Password", "");
        isLoginLoading = false;
        notifyListeners();
      }

      isLoginLoading = false;
      notifyListeners();
    } on PlatformException catch (e) {
      print("PlatformException occurredcttr: $e");
      SqlConn.disconnect();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Connection Lost...! ",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Reconnect'),
                onPressed: () async {
                  await initYearsDb(context, "");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print(e);
      return null;
    } catch (e) {
      print("An unexpected error occurred: $e");
      // Handle other types of exceptions
    }
  }

  getCart(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? os = prefs.getString("os");
    try {
      var res = await SqlConn.readData("Flt_Sp_Get_Fb_CartID '$os'");
      var map = jsonDecode(res);
      print("caaaaaaaaaaaaaarrrrrrrttttttttt$map");
      cart_id = map[0]["CartId"];
      notifyListeners();
      print("cart iddddddddd ====== $cart_id");
      // SqlConn.disconnect();
    } on PlatformException catch (e) {
      print("PlatformException occurredcttr: $e");
      SqlConn.disconnect();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Connection Lost...! ",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Reconnect'),
                onPressed: () async {
                  await initYearsDb(context, "");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      // Handle the PlatformException here
      // You can log the exception, display an error message, or take other appropriate actions
    } catch (e) {
      print("An unexpected error occurred: $e");
      // Handle other types of exceptions
    }
  }

  setUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    u_id = prefs.getString("UserID")!;
    disply_name = prefs.getString("Flt_Display_Name")!;
    notifyListeners();
  }

  setshowdata(bool bbb) {
    showdata = bbb;
    notifyListeners();
  }

  setBagNo(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("BagNo", data);
    bag_no = data;
    notifyListeners();
  }

  getBagDetails(String bagNo, BuildContext context, String from) async {
    setbagerror("");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? os = prefs.getString("os");
    String? cardNo = prefs.getString("cardNo");
    print('os ----- $os, cardNo ------->$card_id,bagnum----$bagNo');
    setBagNo(bagNo);
    // await initYearsDb(context, "");
    try {
      print("${'Flt_Sp_Get_Bag $os, $card_id, $bagNo'}");
      var res =
          await SqlConn.readData("Flt_Sp_Get_Bag '$os',$card_id,'$bagNo'");
      var map = jsonDecode(res);
      // SqlConn.disconnect();
      if (map.isEmpty) {
        if (from == "home") {
          setbagerror("Invalid");
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bag already taken",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('OK'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );setBagNo("0");
          slot_id = 0;
          tapped=true;
          notifyListeners();
        }
      }
      tapped=false;
          notifyListeners();
      print("bag dataaa------------>>$res");

      bagDetailsList.clear();
      for (var item in map) {
        bagDetailsList.add(item);
      }
      slot_id = bagDetailsList[0]["Slot"];
      print("Bag List ==$bagDetailsList");
      print("SLot ==$slot_id");

      notifyListeners();
    } on PlatformException catch (e) {
      print("PlatformException occurredcttr: $e");
      SqlConn.disconnect();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Connection Lost...! ",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Reconnect'),
                onPressed: () async {
                  await initYearsDb(context, "");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      // Handle the PlatformException here
      // You can log the exception, display an error message, or take other appropriate actions
    } catch (e) {
      print("An unexpected error occurred: $e");
      // Handle other types of exceptions
    }
  }

  setbagerror(String err) {
    baggerror = Text(
      err,
      style: TextStyle(color: Colors.red),
    );
    notifyListeners();
  }

  setSalesrror(String err) {
    salesError = Text(
      err,
      style: TextStyle(color: Colors.red),
    );
    notifyListeners();
  }

  setBarerror(String err) {
    barcodeerror = Text(
      err,
      style: TextStyle(color: Colors.red),
    );
    notifyListeners();
  }

  changeSalesman(Map val) {
    selectedSalesMan = val;
    notifyListeners();
  }

  searchSalesMan(String smcode) async {
    bool isvalid = false;
    setSalesrror("");
    notifyListeners();
    print("7777777777777777$smcode");
    for (var sm in salesManlist) {
      if (sm['Sm_Code'] == smcode) {
        isvalid = true;
        break;
      }
    }
    if (!isvalid) {
      setSalesrror("Invalid");
      notifyListeners();
    }
    // for (var item in salesManlist) {
    //   if (item['Sm_Code'].toString().trim() == smcode) {
    //     print("0000000000000000000000000000000$smcode");
    //     findsales = true;

    //     notifyListeners();
    //   }
    //   if (findsales == false) {
    //     setSalesrror("Invalid");
    //     notifyListeners();
    //   }
    // }
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setBool("smbool", findsales);
    notifyListeners();
  }

  setSelectedBarcode(BuildContext context, String data) async {
    print("barcode select----------->>> $data");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("SelBar", data.toString());
    selectedBarcode = data.toString();
    getItemDetails(context, selectedBarcode);
    notifyListeners();
  }

  clearSelectedBarcode(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("SelBar", "");
    selectedBarcode = "";

    notifyListeners();
  }

  getSalesman() async {
    var res = await SqlConn.readData("Flt_Sp_Get_Sm_List '$os'");
    var map = jsonDecode(res);
    salesManlist.clear();
    for (var item in map) {
      salesManlist.add(item);
    }
    selectedSalesMan = salesManlist[0];
    notifyListeners();
    print("Salesman List--$salesManlist");
  }

  getItemDetails(BuildContext context, String barcodedata) async {
    // await initYearsDb(context, "");
    setBarerror("");
    notifyListeners();
    barcodeinvalid = false;
    notifyListeners();
    var res =
        await SqlConn.readData("Flt_Sp_Get_Barcode_Item '$os','$barcodedata'");
    var map = jsonDecode(res);
    if (map.isEmpty) {
      barcodeinvalid = true;
      setBarerror("Invalid code");
      notifyListeners();
    } else {
      barcodeinvalid = false;
      notifyListeners();
      print("Item details Map--$map");
      // selectedBarcode = "";
      notifyListeners();
      barcodeList.clear();
      if (map != null) {
        for (var item in map) {
          barcodeList.add(item);
        }
      }

      if (barcodeList.length == 1) {
        // selectedBarcode = barcodedata;
        selectedBarcode = barcodeList[0]["Barcode"].toString().trim();
        notifyListeners();

        for (var item in barcodeList) {
          var barcode = item['Barcode'];
          bool barcodeExists = selectedBarcodeList
              .any((element) => element['Barcode'] == barcode);
          if (!barcodeExists) {
            selectedBarcodeList.add(item);
          }
        }
        setshowdata(true);
        // notifyListeners();
        notifyListeners();
      }

      qty = List.generate(
          selectedBarcodeList.length, (index) => TextEditingController());
      persntage = List.generate(
          selectedBarcodeList.length, (index) => TextEditingController());
      netamt =
          List.generate(selectedBarcodeList.length, (index) => Text("0.0"));
      isAdded = List.generate(selectedBarcodeList.length, (index) => false);
      // response = List.generate(selectedBarcodeList.length, (index) => 0);
      for (int i = 0; i < selectedBarcodeList.length; i++) {
        if (selectedBarcodeList[i]["Barcode"].toString().trim() ==
            selectedBarcode.toString()) {
          qty[i].text = selectedBarcodeList[i]["Qty"].toString();
          persntage[i].text = selectedBarcodeList[i]["DiscPer"].toString();
          srate = selectedBarcodeList[i]["SRate"];
          notifyListeners();
          print("sratte ==== $srate");
          discount_calc(i, "from add");
        }
        // response[i] = 0;
      }
      isLoading = false;
      notifyListeners();
      print("Selected Barcode----^^^___$selectedBarcode");
      print("Selected BarcodeList----^^^___$selectedBarcodeList");
      notifyListeners();
    }
  }

  savefloorbill(String dt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? os = prefs.getString("os");

    int itemcount = unsavedList.length;
    print(
        "save floor ${'Flt_Sp_Save_FloorBill $cart_id,$dt,$card_id,$slot_id,$os,$u_id,$unsaved_tot,$itemcount'}");
    var res = await SqlConn.readData(
        "Flt_Sp_Save_FloorBill $cart_id,'$dt',$card_id,$slot_id,'$os',$u_id,$unsaved_tot,$itemcount");
    var map = jsonDecode(res);
    savedresult.clear();
    for (var item in map) {
      savedresult.add(item);
    }
    unsavedList.clear();
    notifyListeners();
    print("Saved result--$savedresult");
  }

  discount_calc(int index, String type) {
    if (type == "from add") {
      double srate =
          double.parse(selectedBarcodeList[index]["SRate"].toString().trim());
      double qua = double.parse(qty[index].text.toString());
      double disco = double.parse(persntage[index].text.toString());
      print("srate: $srate-------qty: $qua--------- discou: $disco");
      double total = (srate * qua) - ((srate * qua) * disco / 100);

      netamt[index] = Text(
        "${total.toString()}  \u20B9",
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      );
      print("neTTTTT-------------->$total");
      notifyListeners();
    }
  }

  ////////////////////////////////////////////////////////
  getDatabasename(BuildContext context, String type) async {
    isdbLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? db = prefs.getString("db_name");
    String? cid = await prefs.getString("cid");
    print("cid dbname---------$cid---$db");
    var res = await SqlConn.readData("Flt_LoadYears '$db','$cid'");
    var map = jsonDecode(res);
    db_list.clear();
    if (map != null) {
      for (var item in map) {
        db_list.add(item);
      }
    }
    print("years res-$res");
    print("tyyyyyyyyyp--------$type");
    isdbLoading = false;
    notifyListeners();
    SqlConn.disconnect();
    print("disconnected--------$db");
    if (db_list.length > 1) {
      if (type == "from login") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DBSelection()),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeFloorBill()),
      );
    }
  }

/////////////////////////////////////////////////////////////////////////////
  initYearsDb(
    BuildContext context,
    String type,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString("ip");
    String? port = prefs.getString("port");
    String? un = prefs.getString("usern");
    String? pw = prefs.getString("pass_w");
    String? db = prefs.getString("db_name");
    String? multi_db = prefs.getString("multi_db");

    debugPrint("Connecting selected DB...$db----");
    try {
      isYearSelectLoading = true;
      notifyListeners();
      // await SqlConn.disconnect();
      showDialog(
        context: context,
        builder: (context) {
          // Navigator.push(
          //   context,
          //   new MaterialPageRoute(builder: (context) => HomePage()),
          // );
          // Future.delayed(Duration(seconds: 5), () {
          //   Navigator.of(mycontxt).pop(true);
          // });
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Please wait",
                  style: TextStyle(fontSize: 13),
                ),
                SpinKitCircle(
                  color: Colors.green,
                )
              ],
            ),
          );
        },
      );
      if (multi_db == "1") {
        await SqlConn.connect(
          ip: ip!,
          port: port!,
          databaseName: db!,
          username: un!,
          password: pw!,
          timeout: 10,
        ).timeout(
          Duration(seconds: 10),
          onTimeout: () {
            print("time out............");
            showDialog(
              context: context,
              builder: (context) {
                // Navigator.push(
                //   context,
                //   new MaterialPageRoute(builder: (context) => HomePage()),
                // );
                // Future.delayed(Duration(seconds: 5), () {
                //   Navigator.of(mycontxt).pop(true);
                // });
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Timeout",
                        style: TextStyle(fontSize: 13),
                      ),
                      SpinKitCircle(
                        color: Colors.green,
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          await initYearsDb(context, "");
                        },
                        child: Text('Try again'))
                  ],
                );
              },
            );
          },
        );
      }
      debugPrint("Connected selected DB!----$ip------$db");
      // getDatabasename(context, type);
      CustomSnackbar snackbar = CustomSnackbar();
      snackbar.showSnackbar(context, "Connected successfully..", "");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // yr = prefs.getString("yr_name");
      // dbn = prefs.getString("db_name");
      cName = prefs.getString("cname");
      isYearSelectLoading = false;
      notifyListeners();
      // prefs.setString("db_name", dbn.toString());
      // prefs.setString("yr_name", yrnam.toString());
      // getDbName();
      // getBranches(context);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Navigator.pop(context);
    }
  }

//////////////////////////////////////////////////////////time out
  Future<void> initDb(BuildContext context, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? db = prefs.getString("old_db_name");
    String? ip = prefs.getString("ip");
    String? port = prefs.getString("port");
    String? un = prefs.getString("usern");
    String? pw = prefs.getString("pass_w");
    print("db: $db \n ip : $ip \n port : $port \n uname: $un \n pawd: $pw");
    debugPrint("Connecting..initdb.");
    try {
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Text(
      //             "Please wait",
      //             style: TextStyle(fontSize: 13),
      //           ),
      //           SpinKitCircle(
      //             color: Colors.green,
      //           )
      //         ],
      //       ),
      //     );
      //   },
      // );
      await SqlConn.connect(
        ip: ip!, port: port!, databaseName: db!, username: un!, password: pw!,
        // ip:"192.168.18.37",
        // port: "1433",
        // databaseName: "TL169715",
        // username: "sa",
        // password: "1"
        timeout: 8,
      );

      debugPrint("Connected!");
      getDatabasename(context, type);
      throw PlatformException(
        code: 'ERROR',
        message: 'Network error IOException: failed to connect...',
      );
    } on TimeoutException catch (_) {
      // Handle timeout exception
      await SqlConn.disconnect();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Timeout",
                  style: TextStyle(fontSize: 13),
                ),
                SpinKitCircle(
                  color: Colors.green,
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await initDb(context, "");
                  Navigator.of(context).pop();
                },
                child: Text('Try again'),
              ),
            ],
          );
        },
      );
    } on PlatformException catch (e) {
      print("PlatformException occurredcttr: $e");
      // await SqlConn.disconnect();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Not Connected.! ",
                  style: TextStyle(fontSize: 18),
                ),
                SpinKitCircle(
                  color: Colors.green,
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Connect'),
                onPressed: () async {
                  await initDb(context, "");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print(e);
      return null;
    } catch (e) {
      print("An unexpected error occurred: $e");
      // Handle other types of exceptions
    } finally {
      if (SqlConn.isConnected) {
        // If connected, do not pop context as it may dismiss the error dialog
        Navigator.pop(context);
        debugPrint("Database connected, not popping context.");
      } else {
        // If not connected, pop context to dismiss the dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Not Connected.!",
                    style: TextStyle(fontSize: 13),
                  ),
                  SpinKitCircle(
                    color: Colors.green,
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await initDb(context, "");
                    Navigator.of(context).pop();
                  },
                  child: Text('Connect'),
                ),
              ],
            );
          },
        );
        debugPrint("Database not connected, popping context.");
      }
    }
  }

///////////////////////.................////////////////////////////////
  disconnectDB(BuildContext context) async {
    debugPrint("Disconnecting...!!!");
    try {
      await SqlConn.disconnect();
      debugPrint("DisConnected----------!!!!!!!!!!!!!!");
    } catch (e) {
      debugPrint("Disconnection error--->>>${e.toString()}");
    } finally {
      Navigator.pop(context);
    }
  }

/////////////////////////////////////////////////////////////////
  ///
  updateCart(BuildContext context, String dd, String sm, int? cartrow,
      String bch, double qt, double dic, int status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    os = await prefs.getString("os");
    try {
      if (status == 0) {
        print(
            "update data====== ${'Flt_Update_FB_Cart $cart_id, $dd, $card_id, $cus_name, $cus_contact, $slot_id, $cartrow, $sm, $os, $bch ,$qt , $srate, $dic, $status'}");
        var res = await SqlConn.readData(
            "Flt_Update_FB_Cart '$cart_id','$dd','$card_id','$cus_name','$cus_contact','$slot_id',$cartrow,'$sm','$os','$bch','$qt','$srate','$dic',$status");
        var map = jsonDecode(res);
        if (map.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Added to cart",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Ok'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          print("update Map------------>>$map");
        }
      } else {
        print(
            "delete data====== ${'Flt_Update_FB_Cart $cart_id, $dd, $card_id, $cus_name, $cus_contact, $slot_id, $cartrow, $sm, $os, $bch ,$qt , $srate, $dic, $status'}");
        var res = await SqlConn.readData(
            "Flt_Update_FB_Cart '$cart_id','$dd','$card_id','$cus_name','$cus_contact','$slot_id',$cartrow,'$sm','$os','$bch','$qt','$srate','$dic',$status");
        var map = jsonDecode(res);
        if (map.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Item deleted",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Ok'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          print("update Map------------>>$map");
        }
      }

      // SqlConn.disconnect();
    } on PlatformException catch (e) {
      print("PlatformException occurredcttr: $e");
      SqlConn.disconnect();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Connection Lost...! ",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Reconnect'),
                onPressed: () async {
                  await initYearsDb(context, "");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      // Handle the PlatformException here
      // You can log the exception, display an error message, or take other appropriate actions
    } catch (e) {
      print("An unexpected error occurred: $e");
      // Handle other types of exceptions
    }
  }

//////////////////////................/////////////////////////
  getCustData(String date, String cardNo, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("cardNo", cardNo);
    os = await prefs.getString("os");
    print('os ----- $os, cardNo ------->$cardNo');
    // await initYearsDb(context, "");
    // setcusnameAndPhone(" ", " ", context);
    notifyListeners();
    try {
      var res = await SqlConn.readData("Flt_Sp_GetFloor_Cards '$os','$cardNo'");
      var map = jsonDecode(res);
      // SqlConn.disconnect();
      print("custdata------------>>$res");

      custDetailsList.clear();
      for (var item in map) {
        custDetailsList.add(item);
      }
      print("customer Data List ==$custDetailsList");

      if (custDetailsList.length == 0) {
        setcusnameAndPhone("", "", context);
        cardNoctrl.clear();
        userAddButtonDisable(true);
        notifyListeners();
      } else {
        //  prefs.setInt("CardID", custDetailsList[0]['CardID']);
        card_id = custDetailsList[0]['CardID'].toString();
        setcusnameAndPhone(custDetailsList[0]['Cust_Name'].toString().trim(),
            custDetailsList[0]['Cust_Phone'].toString().trim(), context);
        getUsedBags(context, date, card_id);
        notifyListeners();
      }

      notifyListeners();
      print("card ID--Name---Contact------->$card_id--$cus_name--$cus_contact");
    } on PlatformException catch (e) {
      print("PlatformException occurredcttr: $e");
      SqlConn.disconnect();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Connection Lost...! ",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Reconnect'),
                onPressed: () async {
                  await initYearsDb(context, "");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      // Handle the PlatformException here
      // You can log the exception, display an error message, or take other appropriate actions
    } catch (e) {
      print("An unexpected error occurred: $e");
      // Handle other types of exceptions
    }
  }

  userAddButtonDisable(bool bb) {
    showadduser = bb;
    notifyListeners();
  }

  setaDDUserError(String er) {
    adduserError = Text(er);
    notifyListeners();
  }

/////////////////////////////////////////////////
  createFloorCardsNew(
      String date, String cn, String ph, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    os = await prefs.getString("os");

    try {
      var res = await SqlConn.readData(
          "Flt_Sp_Create_Floor_Cards_As_Customer '$os','$ph','$cn'");
      var map = jsonDecode(res);
      // SqlConn.disconnect();
      if (map.isNotEmpty) {
        print("newcustomer------------>>$res");

        prefs.setInt("CardID", map[0]['Card_ID']);
        card_id = map[0]['Card_ID'].toString();

        cardNoctrl.text = map[0]['Card_Name'].toString().trim();
        setcusnameAndPhone(cn, ph, context);
        userAddButtonDisable(false);
        setaDDUserError(" ");
        typlock = true;
        // getUsedBags(context, date, card_id);
        notifyListeners();
        print(
            "card ID--Name---Contact------->$card_id--$cus_name--$cus_contact");
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Customer Added ",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('OK'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } on PlatformException catch (e) {
      print("PlatformException occurredcttr: $e");
      SqlConn.disconnect();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Connection Lost...! ",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Reconnect'),
                onPressed: () async {
                  await initYearsDb(context, "");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      // Handle the PlatformException here
      // You can log the exception, display an error message, or take other appropriate actions
    } catch (e) {
      print("An unexpected error occurred: $e");
      // Handle other types of exceptions
    }
  }

///////////////////////////////////////////////
  getUsedBags(BuildContext context, String date, String cardid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    os = await prefs.getString("os");
    try {
      var res = await SqlConn.readData(
          "Flt_Sp_Used_Bags_For_Card '$date',$card_id,'$os'");
      var map = jsonDecode(res);
      // SqlConn.disconnect();
      usedbagList.clear();
      allbagallcount = 0;
      notifyListeners();
      for (var item in map) {
        usedbagList.add(item);
      }
      print("used bag list------------>>$res");
      for (int i = 0; i < usedbagList.length; i++) {
        allbagallcount =
            allbagallcount + int.parse(usedbagList[i]["Cnt"].toString());
        print("alll count======$allbagallcount");
        notifyListeners();
      }

      notifyListeners();
    } on PlatformException catch (e) {
      print("PlatformException occurredcttr: $e");
      SqlConn.disconnect();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Connection Lost...! ",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Reconnect'),
                onPressed: () async {
                  await initYearsDb(context, "");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      // Handle the PlatformException here
      // You can log the exception, display an error message, or take other appropriate actions
    } catch (e) {
      print("An unexpected error occurred: $e");
      // Handle other types of exceptions
    }
  }

/////////////////////////////////////////////////////
  getUsedBagsItems(BuildContext context, String date, int slot_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    os = await prefs.getString("os");
    try {
      var res = await SqlConn.readData(
          "Flt_Sp_GetSaved_Fb_Items '$date',$card_id,$slot_id,'$os'");
      var map = jsonDecode(res);
      usedbagITEMList.clear();
      itemSortedList.clear();
      floor_totl.clear();
      all_total = 0.0;
      notifyListeners();
      for (var item in map) {
        usedbagITEMList.add(item);
        int fbNo = item['FB_No'];
        if (!itemSortedList.containsKey(fbNo)) {
          itemSortedList[fbNo] = [];
        }
        itemSortedList[fbNo]!.add(item);
      }

      itemSortedList.forEach((key, value) {
        double sum = 0;
        for (var element in value) {
          sum += element['Amount'];
        }
        floor_totl[key] = sum;
        notifyListeners();
        print("fffffffffffffffffffffffffoooooooooooooooooo${floor_totl[key]}");
      });
      all_total = floor_totl.values.fold(0, (prev, value) => prev + value);
      notifyListeners();

      print("used bag ITEMS------------>>$usedbagITEMList");
      print("SorteD ITEMS------------>>$itemSortedList");

      notifyListeners();
    } on PlatformException catch (e) {
      print("PlatformException occurredcttr: $e");
      SqlConn.disconnect();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Connection Lost...! ",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Reconnect'),
                onPressed: () async {
                  await initYearsDb(context, "");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      // Handle the PlatformException here
      // You can log the exception, display an error message, or take other appropriate actions
    } catch (e) {
      print("An unexpected error occurred: $e");
      // Handle other types of exceptions
    }
  }

  ////////////////////////////////////////
  getUnsavedCart(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("cardNo", cardNo);
    os = await prefs.getString("os");
    print(
      'os ----- $os, cardId ------->$card_id, cart No----------$cart_id',
    );
    // await initYearsDb(context, "");
    try {
      var res = await SqlConn.readData(
          "Flt_Sp_Get_Unsaved_FBCart '$cart_id','$card_id','$os'");
      var map = jsonDecode(res);
      // SqlConn.disconnect();
      print("unsaved cart------------>>$res");

      unsavedList.clear();
      for (var item in map) {
        unsavedList.add(item);
      }
      qty =
          List.generate(unsavedList.length, (index) => TextEditingController());
      persntage =
          List.generate(unsavedList.length, (index) => TextEditingController());
      print("Unsaved List ==$unsavedList");
      unsaved_tot = 0.0;
      notifyListeners();
      for (int i = 0; i < unsavedList.length; i++) {
        qty[i].text = unsavedList[i]["Cart_Qty"].toString();
        persntage[i].text = unsavedList[i]["Cart_Disc_Per"].toString();
        unsaved_tot = unsaved_tot +
            double.parse(unsavedList[i]["Total"].toStringAsFixed(2));
        print('unsaved total :$unsaved_tot');
        notifyListeners();
      }
      notifyListeners();
    } on PlatformException catch (e) {
      print("PlatformException occurredcttr: $e");
      SqlConn.disconnect();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Connection Lost...! ",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Reconnect'),
                onPressed: () async {
                  await initYearsDb(context, "");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      // Handle the PlatformException here
      // You can log the exception, display an error message, or take other appropriate actions
    } catch (e) {
      print("An unexpected error occurred: $e");
      // Handle other types of exceptions
    }
  }
//////////////////////////////////////////////

  getFBList(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? os = await prefs.getString("os");
    int car;
    card_id == "" ? car = 0 : car = int.parse(card_id);

    print("tabl para------$date----$os----$car");

    var res = await SqlConn.readData("Flt_Sp_Get_Fb_List '$date',$car,'$os'");
    var map = jsonDecode(res);
    fbList.clear();
    if (map != null) {
      for (var item in map) {
        fbList.add(item);
      }
    }
    print("fbList-----$res");
    notifyListeners();
  }

  ////////////////////////////////////
  setDate(String date1, String date2) {
    fromDate = date1;
    todate = date2;
    print("gtyy----$fromDate----$todate");
    notifyListeners();
  }

  ///////////////////////////////////////////////////////
  setQty(double val, int index, String type) {
    if (type == "inc") {
      double d = double.parse(qty[index].text) + val;
      qty[index].text = d.toString();
      discount_calc(index, "from add");
      notifyListeners();
    } else if (type == "dec") {
      if (double.parse(qty[index].text) > 1) {
        double d = double.parse(qty[index].text) - val;
        qty[index].text = d.toString();
        notifyListeners();
      } else {
        isAdded[index] = false;
        notifyListeners();
      }
      discount_calc(index, "from add");
      notifyListeners();
    }
  }

  ///////////////////////////////////
  totalItemCount(String val, String type) {
    if (type == "inc") {
      itemcount = itemcount + double.parse(val);
      notifyListeners();
    } else if (type == "dec") {
      if (itemcount > 1) {
        itemcount = itemcount - double.parse(val);
        notifyListeners();
      }
    }
    print("object$itemcount");
  }

  ///////////////........................../////////////////////////////
  setCatID(String id, BuildContext context) {
    catlID = id;

    print("catlID----$catlID");
    notifyListeners();
  }

  setcusnameAndPhone(String na, String ph, BuildContext context) {
    cus_name = na;
    cus_contact = ph;
    ccname.text = cus_name.toString();
    ccfon.text = cus_contact.toString();
    notifyListeners();
    print("getcusnamfon---->$cus_name , $cus_contact");
    print("catlID----$catlID");
  }

  /////////////////////////////////////////////////////////////////////
  getComnameAndUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    os = await prefs.getString("os");
    cName = await prefs.getString("cname");
    userName = await prefs.getString("st_uname");
    notifyListeners();
  }
}
