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
    {
      "icon": Icons.computer,
      "mainText": const SelectableText(
        "Loading",
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            color: Colors.black),
      ),
      "subText": "Type"
    },
    {
      "icon": Icons.calendar_today,
      "mainText": const SelectableText(
        "Loading",
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            color: Colors.black),
      ),
      "subText": "Last on"
    },
    {
      "icon": Icons.watch_later_outlined,
      "mainText": const SelectableText(
        "Loading",
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            color: Colors.black),
      ),
      "subText": "On duration"
    },
    {
      "icon": Icons.collections_bookmark_outlined,
      "mainText": const SelectableText(
        "Loading",
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            color: Colors.black),
      ),
      "subText": "Supervisor version"
    },
    {
      "icon": Icons.settings_ethernet,
      "mainText": const SelectableText(
        "Loading",
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            color: Colors.black),
      ),
      "subText": "IP address"
    },
    {
      "icon": Icons.cloud_done_outlined,
      "mainText": const SelectableText(
        "Loading",
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            color: Colors.black),
      ),
      "subText": "Fleet"
    },
  ];

  Timer? _timer;
  final Duration _refreshDuration = const Duration(seconds: 1);

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
      Uri.parse('http://10.211.55.7:8080/api/v1/device/info'),
      headers: {
        'Authorization': 'Bearer robotics',
        "Content-Type":
            "application/json" // Include your access token or any other headers
      },
    );

    if (response.statusCode == 200) {
      final device = Device.fromJson(json.decode(response.body));
      Map<String, NetworkDevice> devices = Map.from(device.ipAddress);
      devices.removeWhere((key, networkDevice) =>
          !(networkDevice.deviceName.contains('wlan') ||
              networkDevice.deviceName.contains('eth') ||
              networkDevice.deviceName.contains('enp')));
      devices.removeWhere(
          (key, networkDevice) => (networkDevice.deviceName.contains('veth')));
      Widget ipAddressWidget = Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: devices.entries.map((entry) {
              final networkDevice = entry.value;
              return SelectableText(
                '${networkDevice.deviceName}:',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 53, 53, 53)),
              );
            }).toList(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: devices.entries.map((entry) {
              final networkDevice = entry.value;
              return SelectableText(
                networkDevice.ipAddress,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              );
            }).toList(),
          ),
        ],
      );

      setState(() {
        items = [
          {
            "icon": Icons.computer,
            "mainText": SelectableText(
              device.type,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            "subText": "Type"
          },
          {
            "icon": Icons.calendar_today,
            "mainText": SelectableText(
              formatDate(device.lastOn),
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            "subText": "Last on"
          },
          {
            "icon": Icons.watch_later_outlined,
            "mainText": SelectableText(
              formatDuration(device.onDuration),
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            "subText": "On duration"
          },
          {
            "icon": Icons.collections_bookmark_outlined,
            "mainText": SelectableText(
              device.softwareVersion
                  .substring("sha256:".length, "sha256:".length + 8),
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            "subText": "Software version"
          },
          {
            "icon": Icons.settings_ethernet,
            "mainText": ipAddressWidget,
            "subText": "IP address"
          },
          {
            "icon": Icons.cloud_done_outlined,
            "mainText": SelectableText(
              device.fleet,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
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
            return Row(
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
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    item["mainText"] as Widget
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
