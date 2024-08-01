import 'package:flutter/material.dart';
import 'package:robotics_dashboard/utils/constants.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 150,
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: const Color.fromARGB(26, 0, 0, 0))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Logs",
                        style: TextStyle(color: Colors.black, fontSize: 14.0),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.play_arrow,
                            size: 17.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.pause,
                            size: 17.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.stop,
                            size: 17.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.restart_alt,
                            size: 17.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.document_scanner,
                            size: 17.0,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            )),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
