import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotic_dashboard/service/navigation_provider.dart';
import 'package:robotic_dashboard/service/user_client.dart';
import 'package:robotic_dashboard/utils/constants.dart';
import 'package:robotic_dashboard/view/widgets/warning_dialog.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? forceErrorText;
  bool isLoading = false;

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length != value.replaceAll(' ', '').length) {
      return 'Username must not contain any spaces';
    }
    if (value.length <= 4) {
      return 'Username should be at least 5 characters long';
    }
    return null;
  }

  void onChanged(String value) {
    // Nullify forceErrorText if the input changed.
    if (forceErrorText != null) {
      setState(() {
        forceErrorText = null;
      });
    }
  }

  void _showLoginDialog() {
    Future<void> login() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            backgroundColor: secondaryColor,
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Verifying...")
              ],
            ),
          );
        },
      );

      await Provider.of<UserProvider>(context, listen: false)
          .signIn(_usernameController.text, _passwordController.text);
      if (!mounted) return;
      Navigator.of(context).pop();

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.isSignedIn) {
        String role = "user";
        if (userProvider.token != null && userProvider.token != "") {
          if (userProvider.isAdmin) {
            role = "admin";
          } else {
            role = "maintainer";
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful as $role'),
            duration: const Duration(seconds: 2),
          ),
        );
        _usernameController.text = "";
        _passwordController.text = "";
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Failed'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: const Text(
            "Login",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          content: SizedBox(
            width: 300,
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                      "For regular user (UTS), please use your student ID (or staff ID) to sign in (no need for password)"),
                ),
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: _usernameController,
                    forceErrorText: forceErrorText,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: validator,
                    onChanged: onChanged,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final bool isValid = formKey.currentState?.validate() ?? false;
                if (!isValid) {
                  return;
                }
                login();
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: const Text(
            "Logout",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          content: const SizedBox(
              width: 300, height: 100, child: Text("You are about to logout.")),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false).signOut();
                Navigator.of(context).pop();
              },
              child: const Text('Logout'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showNotLoggedInDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: const Text(
            "Unable to log out",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          content: const SizedBox(
              width: 300,
              height: 50,
              child: Text("Unable to log out as you are not logged in.")),
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      width: 100,
      color: actionColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: IconButton(
              onPressed: () {
                if (!userProvider.isSignedIn) {
                  _showLoginDialog();
                }
              },
              icon: const Icon(Icons.dashboard_rounded,
                  size: 40.0, color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 32.0,
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.account_tree_rounded,
                        size: 28.0, color: Colors.white),
                    onPressed: () {
                      if (!userProvider.isAdmin) {
                        showNotSignInWarning(context);
                        return;
                      }
                      context.read<NavigationProvider>().setPage('fleet');
                    },
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon:
                        const Icon(Icons.home, size: 28.0, color: Colors.white),
                    onPressed: () {
                      context.read<NavigationProvider>().setPage('dashboard');
                    },
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.leaderboard,
                        size: 28.0, color: Colors.white),
                    onPressed: () {
                      context.read<NavigationProvider>().setPage('stats');
                    },
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.settings,
                        size: 28.0, color: Colors.white),
                    onPressed: () {
                      if (!userProvider.isAdmin) {
                        showNotSignInWarning(context);
                        return;
                      }
                      context.read<NavigationProvider>().setPage('settings');
                    },
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon:
                        const Icon(Icons.info, size: 28.0, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          if (userProvider.isSignedIn)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: IconButton(
                icon: const Icon(
                  Icons.logout_sharp,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () {
                  if (userProvider.isSignedIn) {
                    _showLogoutDialog();
                  } else {
                    _showNotLoggedInDialog();
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
