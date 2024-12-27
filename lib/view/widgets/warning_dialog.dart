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

Future<bool> showRestartWarningDialog(BuildContext context) async {
  bool restart = false;
  restart = await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: secondaryColor,
        title: const Text(
          "Restarting device",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        content: const SizedBox(
            width: 250,
            height: 50,
            child: Text("You are about to restart the device. Proceed?")),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true for restart
            },
            child: const Text('Ok'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false to cancel
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
  return restart;
}

Future<bool> showShutdownWarningDialog(BuildContext context) async {
  bool shutdown = false;
  shutdown = await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: secondaryColor,
        title: const Text(
          "Shutting down device",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        content: const SizedBox(
            width: 250,
            height: 50,
            child: Text("You are about to shutdown the device. Proceed?")),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true for restart
            },
            child: const Text('Ok'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false to cancel
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
  return shutdown;
}

Future<bool> showUpdateWarningDialog(BuildContext context) async {
  bool update = false;
  update = await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: secondaryColor,
        title: const Text(
          "Updating device",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        content: const SizedBox(
            width: 250,
            height: 50,
            child: Text(
                "You are about to perform a device-wide update. Proceed?")),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Ok'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
  return update;
}
