import 'dart:async';
import 'dart:convert';
import 'package:floor_billing/SCREENs/db_selection.dart';
import 'package:floor_billing/SCREENs/HOME/homeFloorBilling.dart';
import 'package:floor_billing/MODEL/registration_model.dart';
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

  List<TextEditingController> qty = [];
  List<bool> isAdded = [];

  List<Map<String, dynamic>> tabllist = [
    {"tab": "Table 1", "tid": 1},
    {"tab": "Table 2", "tid": 2},
    {"tab": "Table 3", "tid": 3},
    {"tab": "Table 4", "tid": 4},
    {"tab": "Table 5", "tid": 5},
  ];
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
  String cus_name = "";
  String cus_contact = "";
  List barcodeList=[];
  List selectedBarcodeList=[];
  String selectedBarcode="";
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
        SqlConn.disconnect();
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
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }

  setUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    u_id = prefs.getString("UserID")!;
    disply_name = prefs.getString("Flt_Display_Name")!;
    notifyListeners();
  }

  setBagNo(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("BagNo", data);
    bag_no = data;
    notifyListeners();
  }
setSelectedBarcode(String data)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("SelBar", data);
    selectedBarcode=data;
    
    notifyListeners();
}
  getSalesman() async {
    var res = await SqlConn.readData("Flt_Sp_Get_Sm_List '$os'");
    var map = jsonDecode(res);
    print("Salesman Map--$map");
  }

  getItemDetails(BuildContext context, String barcodedata) async {
    await initYearsDb(context, "");
    var res =
        await SqlConn.readData("Flt_Sp_Get_Barcode_Item '$os','$barcodedata'");
    var map = jsonDecode(res);
    print("Item details Map--$map");
    selectedBarcode="";
    barcodeList.clear();
     if (map != null) {
      for (var item in map) {
        barcodeList.add(item);
      }
      
    }

    if (barcodeList.length==1) {
      selectedBarcode=barcodeList[0]["Barcode"].toString().trim();
      selectedBarcodeList.add(barcodeList);
      print("Selected BarcodeList----^^^___$selectedBarcodeList");
      notifyListeners();
    }
     notifyListeners();
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
            password: pw!);
      }
      debugPrint("Connected selected DB!----$ip------$db");
      // getDatabasename(context, type);

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

//////////////////////////////////////////////////////////
  initDb(BuildContext context, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? db = prefs.getString("old_db_name");
    String? ip = prefs.getString("ip");
    String? port = prefs.getString("port");
    String? un = prefs.getString("usern");
    String? pw = prefs.getString("pass_w");
    debugPrint("Connecting..initdb.");
    try {
      showDialog(
        context: context,
        builder: (context) {
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
      await SqlConn.connect(
          ip: ip!, port: port!, databaseName: db!, username: un!, password: pw!
          // ip:"192.168.18.37",
          // port: "1433",
          // databaseName: "epulze",
          // username: "sa",
          // password: "1"

          );
      debugPrint("Connected!");
      getDatabasename(context, type);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Navigator.pop(context);
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

//////////////////////................/////////////////////////
  getCustData(String cardNo, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("cardNo", cardNo);

    print('os ----- $os, cardNo ------->$cardNo');
    await initYearsDb(context, "");
    var res = await SqlConn.readData("Flt_Sp_GetFloor_Cards '$os','$cardNo'");
    var map = jsonDecode(res);
    SqlConn.disconnect();
    print("custdata------------>>$res");

    custDetailsList.clear();
    for (var item in map) {
      custDetailsList.add(item);
    }
    print("customer Data List ==$custDetailsList");
    prefs.setInt("CardID", custDetailsList[0]['CardID']);
    card_id = custDetailsList[0]['CardID'].toString();
    cus_name = custDetailsList[0]['Cust_Name'].toString();
    cus_contact = custDetailsList[0]['Cust_Phone'].toString();
    print("card ID--Name---Contact------->$card_id--$cus_name--$cus_contact");
  }

///////////////////////////////////////////////

  getTableList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? os = await prefs.getString("os");
    String? smid = await prefs.getString("Sm_id");
    print("tabl para---------$os---$smid");
    isTableLoading = true;
    notifyListeners();
    var res = await SqlConn.readData("Flt_Sp_Get_Tables '$os','$smid'");
    var map = jsonDecode(res);
    tabllist.clear();
    if (map != null) {
      for (var item in map) {
        tabllist.add(item);
      }
    }
    print("tablelist-$res");

    isTableLoading = false;
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

  /////////////////////////////////////////////////////////////////////
  getComnameAndUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    os = await prefs.getString("os");
    cName = await prefs.getString("cname");
    userName = await prefs.getString("st_uname");
    notifyListeners();
  }
}
