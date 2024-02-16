import 'dart:typed_data';

import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class PrintReport {
  Future<void> initialize() async {
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
  }

  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer
        .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  //////////////////////////////////////////////
  Future<void> saleReportPrint(List result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cName = prefs.getString("cname");
    Set<String> ss = result.map((e) => e['Series'].toString().trim()).toSet();
    String originalDate = result[0]["FBDate"].toString();
    String dt = originalDate.substring(8, 10) +
        '-' +
        originalDate.substring(5, 7) +
        '-' +
        originalDate.substring(0, 4);
    await SunmiPrinter.bold();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: cName.toString(),
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: result[0]["Series"].toString(),
        width: 10,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    await SunmiPrinter.resetBold();
    await SunmiPrinter.lineWrap(1);
     await SunmiPrinter.printText(dt.toString(),
                              style: SunmiStyle(bold: true,align: SunmiPrintAlign.RIGHT,fontSize: SunmiFontSize.MD));
   
   
    await SunmiPrinter.printText('FB # ${result[0]["FB_No"].toString()}',
                              style: SunmiStyle(bold: true,align: SunmiPrintAlign.LEFT,fontSize: SunmiFontSize.XL));
    await SunmiPrinter.printText('Slot :${result[0]["Slot_Name"].toString()}',
                              style: SunmiStyle(bold: true,align: SunmiPrintAlign.LEFT,fontSize: SunmiFontSize.XL));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Customer Name ",
        width: 13,
        align: SunmiPrintAlign.LEFT,
      ),
       ColumnMaker(
        text: ":",
        width: 2,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: result[0]["Cus_Name"].toString(),
        width: 25,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Contact",
        width: 13,
        align: SunmiPrintAlign.LEFT,
      ),
       ColumnMaker(
        text: ":",
        width: 2,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: result[0]["Cus_Phone"].toString(),
        width: 25,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printBarCode(result[0]["CardNo"].toString(),
        barcodeType: SunmiBarcodeType.CODE128,
        textPosition: SunmiBarcodeTextPos.NO_TEXT,
        height: 80,
        width: 4);
    await SunmiPrinter.printText(
      "Customer code : ${result[0]["CardNo"].toString()}",
      style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
          bold: true,
          fontSize: SunmiFontSize.LG),
    );
    await SunmiPrinter.lineWrap(1); // creates one line space
    double tot = 0.0;
    // set alignment center
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.setCustomFontSize(20);
    await SunmiPrinter.bold();

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Description",
        width: 30,
        align: SunmiPrintAlign.CENTER,
      ),

     
    ]);
    await SunmiPrinter.line();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

    await SunmiPrinter.setCustomFontSize(20);
    await SunmiPrinter.bold();

    for (int i = 0; i < result.length; i++) {
      tot = tot + result[i]["Amount"];
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          // text:"jhdjsdjhdjsdjdhhhhhhhhhhhhhhhhh",
          text: result[i]["Item_Name"].toString(),
          width: 30,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          // text:"jhdjsdjhdjsdjdhhhhhhhhhhhhhhhhh",
          text: result[i]["Qty"].toString(),
          width: 10,
          align: SunmiPrintAlign.LEFT,
        ),
        
      ]);
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          // text:"jhdjsdjhdjsdjdhhhhhhhhhhhhhhhhh",
          text: result[i]["Barcode"].toString(),
          width: 30,
          align: SunmiPrintAlign.LEFT,
        ),
        
       ColumnMaker(
          
          text: "\u20B9 ${result[i]["Rate"].toString()}",
          width: 10,
          align: SunmiPrintAlign.LEFT,
        ),
      ]);
      
      // await SunmiPrinter.lineWrap(1);
    }
    await SunmiPrinter.line();
    await SunmiPrinter.bold();
    await SunmiPrinter.setCustomFontSize(23);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Total Amount",
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "\u20B9 ${tot.toString()}",
        width: 16,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    await SunmiPrinter.lineWrap(2);
   
  }
Future<void> secondpart(List result) async {
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "fgxdfgdgdf",
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: result[0]["Series"].toString(),
        width: 10,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
}
////////////////////////////////////////////////////////////

  Future<Uint8List> _getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }

  Future<void> closePrinter() async {
    await SunmiPrinter.unbindingPrinter();
  }

  Future<void> printReport(List reportData) async {
    print("printdata--${reportData}");
    await initialize();

    await saleReportPrint(reportData);

    await SunmiPrinter.lineWrap(3);
    await SunmiPrinter.submitTransactionPrint();
    await SunmiPrinter.cut();
   
    await initialize();
    await secondpart(reportData);
    await closePrinter();
  }
}