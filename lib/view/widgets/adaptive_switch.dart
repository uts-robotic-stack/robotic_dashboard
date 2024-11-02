import 'package:flutter/material.dart';


class AdaptiveSwitch extends StatefulWidget {
  final ValueChanged<bool>? onChanged;

  const AdaptiveSwitch({Key? key, this.onChanged}) : super(key: key);

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
            activeColor: const Color.fromARGB(255, 21, 167, 77),
            activeTrackColor: const Color.fromARGB(255, 25, 159, 87),
            inactiveTrackColor: const Color.fromARGB(255, 171, 171, 171),
            value: follow,
            onChanged: (value) {
              setState(() {
                follow = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
          )),
      const Text("Follow",
          style: TextStyle(color: Colors.black, fontSize: 12.0))
    ]);
  }
}
