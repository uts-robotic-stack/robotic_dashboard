import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotic_dashboard/service/navigation_provider.dart';
import 'package:robotic_dashboard/service/user_client.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showLoginDialog() {
    Future<void> login() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
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

      // Use UserProvider's signIn function
      await Provider.of<UserProvider>(context, listen: false)
          .signIn(_usernameController.text, _passwordController.text);
      if (!mounted) return;
      Navigator.of(context).pop(); // Close the progress dialog

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.isAdmin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful'),
            duration: Duration(seconds: 2),
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
          title: const Text(
            "Login",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          content: SizedBox(
            width: 300,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  onSubmitted: (_) => login(),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSubmitted: (_) => login(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: login,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      color: Colors.grey[800],
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(2.0),
              child: IconButton(
                  onPressed: () {
                    _showLoginDialog();
                  },
                  icon: const Icon(Icons.dashboard_rounded,
                      size: 40.0, color: Colors.white))),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.account_tree_rounded,
                        color: Colors.white),
                    onPressed: () {
                      context.read<NavigationProvider>().setPage('fleet');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      context.read<NavigationProvider>().setPage('dashboard');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.leaderboard, color: Colors.white),
                    onPressed: () {
                      context.read<NavigationProvider>().setPage('stats');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      context.read<NavigationProvider>().setPage('settings');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.info, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
