import 'package:flutter/material.dart';

class AdaptiveSwitch extends StatefulWidget {
  const AdaptiveSwitch({super.key});

  @override
  AdaptiveSwitchState createState() => AdaptiveSwitchState();
}

class AdaptiveSwitchState extends State<AdaptiveSwitch> {
  bool follow = false;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Transform.scale(
          scale: 0.75,
          child: Switch.adaptive(
            activeColor: Colors.blue,
            activeTrackColor: const Color.fromARGB(255, 171, 171, 171),
            inactiveTrackColor: const Color.fromARGB(255, 171, 171, 171),
            value: follow,
            onChanged: (follow) => setState(() {
              this.follow = follow;
            }),
          )),
      const Text("Follow",
          style: TextStyle(color: Colors.black, fontSize: 12.0))
    ]);
  }
}
