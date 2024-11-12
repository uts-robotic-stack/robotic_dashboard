import 'package:flutter/material.dart';
import 'package:robotic_dashboard/utils/constants.dart';

void showNotAdminWarning(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      // Use UserProvider's signIn function
      return AlertDialog(
        backgroundColor: secondaryColor,
        title: const Text(
          "Unable to change this setting",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        content: const SizedBox(
            width: 250,
            height: 50,
            child: Text("You need to sign in as admin to change this setting")),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}

void showNotSignInWarning(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      // Use UserProvider's signIn function
      return AlertDialog(
        backgroundColor: secondaryColor,
        title: const Text(
          "Please sign in",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        content: const SizedBox(
            width: 250,
            height: 50,
            child: Text("You need to sign in to use this feature")),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
