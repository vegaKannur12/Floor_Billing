import 'package:floor_billing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DummyModal extends StatelessWidget {
  const DummyModal({Key? key}) : super(key: key);

  static const _values = ["CF Cruz Azul", "Monarcas FC"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<Controller>(builder: (BuildContext context, Controller value, Widget? child) { 
        return ListView.builder(
                shrinkWrap: true,
                itemCount: value.barcodeList.length,
                itemBuilder: (context, index) {
                   return Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 2),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(title: Text(value.barcodeList[index]["Barcode"].toString()),),
                      )
                    )
                   );

                }
        );
       },)
    );
  }
  
}