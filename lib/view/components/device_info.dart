import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:robotic_dashboard/model/device_info.dart';
import 'package:robotic_dashboard/utils/common_utils.dart';

class DeviceInfoList extends StatefulWidget {
  const DeviceInfoList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DeviceInfoListState createState() => _DeviceInfoListState();
}

class _DeviceInfoListState extends State<DeviceInfoList> {
  List<Map<String, dynamic>> items = [
    {"icon": Icons.computer, "mainText": "Loading...", "subText": "Type"},
    {
      "icon": Icons.calendar_today,
      "mainText": "Loading...",
      "subText": "Last on"
    },
    {
      "icon": Icons.watch_later_outlined,
      "mainText": "Loading...",
      "subText": "On duration"
    },
    {
      "icon": Icons.collections_bookmark_outlined,
      "mainText": "Loading...",
      "subText": "Software version"
    },
    {
      "icon": Icons.settings_ethernet,
      "mainText": "Loading...",
      "subText": "IP address"
    },
    {
      "icon": Icons.cloud_done_outlined,
      "mainText": "Loading...",
      "subText": "Fleet"
    },
  ];

  Timer? _timer;
  final Duration _refreshDuration = const Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    _fetchData();
    _startPeriodicFetch();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/v1/device/info'),
      headers: {
        'Authorization': 'Bearer robotics',
        "Content-Type":
            "application/json" // Include your access token or any other headers
      },
    );

    if (response.statusCode == 200) {
      final device = Device.fromJson(json.decode(response.body));
      setState(() {
        items = [
          {"icon": Icons.computer, "mainText": device.type, "subText": "Type"},
          {
            "icon": Icons.calendar_today,
            "mainText": formatDate(device.lastOn),
            "subText": "Last on"
          },
          {
            "icon": Icons.watch_later_outlined,
            "mainText": formatDuration(device.onDuration),
            "subText": "On duration"
          },
          {
            "icon": Icons.collections_bookmark_outlined,
            "mainText": device.softwareVersion
                .substring("sha256:".length, "sha256:".length + 8),
            "subText": "Software version"
          },
          {
            "icon": Icons.settings_ethernet,
            "mainText": device.ipAddress,
            "subText": "IP address"
          },
          {
            "icon": Icons.cloud_done_outlined,
            "mainText": device.fleet,
            "subText": "Fleet"
          },
        ];
      });
    } else {}
  }

  void _startPeriodicFetch() {
    _timer = Timer.periodic(_refreshDuration, (Timer t) => _fetchData());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth < 600 ? 1 : 2;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: constraints.maxWidth < 600 ? 8 : 5,
            crossAxisSpacing: 2,
            mainAxisSpacing: 8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Icon(
                      item["icon"] as IconData,
                      size: 25,
                      color: const Color.fromARGB(255, 126, 126, 126),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["subText"] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      SelectableText(
                        item["mainText"] as String,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
