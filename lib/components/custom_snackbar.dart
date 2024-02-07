import 'package:flutter/material.dart';
class CustomSnackbar {
  showSnackbar(BuildContext context, String content,String type) {
    ScaffoldMessenger. of(context).showSnackBar(
      SnackBar(
        backgroundColor:Color.fromARGB(255, 15, 15, 15),
        duration: const Duration(seconds: 2),
        content: Text(content),
        action: SnackBarAction(
          label: '',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
