import 'package:flutter/material.dart';

class AdaptiveSwitch extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  final double scale;
  final String? label;
  final bool follow;

  const AdaptiveSwitch({
    Key? key,
    this.onChanged,
    this.scale = 0.75, // Default scale
    this.label, // Optional label text
    this.follow = false, // Default follow value
  }) : super(key: key);

  @override
  AdaptiveSwitchState createState() => AdaptiveSwitchState();
}

class AdaptiveSwitchState extends State<AdaptiveSwitch> {
  late bool follow;

  @override
  void initState() {
    super.initState();
    follow = widget
        .follow; // Initialize follow with the value from widget's parameter
  }

  @override
  void didUpdateWidget(covariant AdaptiveSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update follow if the follow prop changes externally
    if (oldWidget.follow != widget.follow) {
      setState(() {
        follow = widget.follow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: widget.scale, // Use the scale from widget's parameter
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
          ),
        ),
        if (widget.label != null)
          Text(
            widget.label!,
            style: const TextStyle(color: Colors.black, fontSize: 12.0),
          ),
      ],
    );
  }
}
