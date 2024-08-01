import 'package:robotics_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robotics_dashboard/view/widgets/adaptive_switch.dart';

// ignore: must_be_immutable
class LogsViewer extends ConsumerWidget {
  LogsViewer({super.key});

  bool follow = false;

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        Container(
          color: logWindowColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Text(
                    "Logs",
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Row(
                  children: [
                    const AdaptiveSwitch(),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () {
                        // logContent.setClear(false);
                      },
                      icon: const Icon(
                        Icons.refresh,
                        size: 17.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.download,
                        size: 17.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // logContent.setClear(true);
                        // ref.invalidate(logsServiceProvider);
                      },
                      icon: const Icon(
                        Icons.clear,
                        size: 17.0,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: SelectionArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: Colors.black87,
            ),
            // child: logContent,
          ),
        ))
      ],
    );
  }
}
