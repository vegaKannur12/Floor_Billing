// import 'package:floor_billing/controller/controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
// import 'package:sql_conn/sql_conn.dart';

// class ConnectCheck
// {
//   checkconnection(BuildContext context)
//    {
//     try {
//       if (SqlConn.isConnected) {
//         print("connected.........OK");
//         Navigator.pop(context);
//       } 
//       else {
//         print("Not  connected.........OK");
//       }
//     } on PlatformException catch (e) {
//       print("PlatformException occurredcttr: $e");
//       // await SqlConn.disconnect();
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Not Connected.! ",
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SpinKitCircle(
//                   color: Colors.green,
//                 )
//               ],
//             ),
//             actions: <Widget>[
//               TextButton(
//                 style: TextButton.styleFrom(
//                   textStyle: Theme.of(context).textTheme.labelLarge,
//                 ),
//                 child: const Text('Connect'),
//                 onPressed: () async {
//                   await Provider.of<Controller>(context,
//                                           listen: false).initYearsDb(context, "");
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//       print(e);
//       return null;
//     } catch (e) {
//       print("An unexpected error occurred: $e");
//       // Handle other types of exceptions
//     } finally {
//       if (SqlConn.isConnected) {
//         // If connected, do not pop context as it may dismiss the error dialog
//         Navigator.pop(context);
//         debugPrint("Database connected, not popping context.");
//       } else {
//         // If not connected, pop context to dismiss the dialog
//         showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Not Connected.!",
//                     style: TextStyle(fontSize: 13),
//                   ),
//                   SpinKitCircle(
//                     color: Colors.green,
//                   )
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () async {
//                     await Provider.of<Controller>(context,
//                                           listen: false).initYearsDb(context, "");
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Connect'),
//                 ),
//               ],
//             );
//           },
//         );
//         // debugPrint("Database not connected, popping context.");
//       }
//     }

//    }
// }