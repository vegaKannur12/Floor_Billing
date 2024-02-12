import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sql_conn/sql_conn.dart';
// Import your SQL connection class

class FunctionUtils {
  static void checkForPlatformExceptions() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      callFunctionFrequently();
    });
  }

  static void callFunctionFrequently() async {
    try {
      if (SqlConn.isConnected) {
        print("Connected...OK");
      }
    } on PlatformException catch (e) {
      print("PlatformException occurred: $e");
      // Handle the PlatformException here
      // You can log the exception, display an error message, or take other appropriate actions
    } catch (e) {
      print("An unexpected error occurred: $e");
      // Handle other types of exceptions
    }
  }

  static void runFunctionPeriodically(BuildContext context) {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!Navigator.of(context).canPop()) {
        // Check if there's no route to pop (i.e., if current page is not being displayed)
        return;
      }
      (context as Element).markNeedsBuild(); // Trigger a rebuild of the widget tree
      callFunctionFrequently();
    });
  }
}
