import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotic_dashboard/model/device_info.dart';
import 'package:robotic_dashboard/service/device_provider.dart';
import 'package:robotic_dashboard/utils/common_utils.dart';

// ignore: must_be_immutable
class DeviceInfoList extends StatelessWidget {
  DeviceInfoList({Key? key}) : super(key: key);
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
      "icon": Icons.wifi,
      "mainText": const SelectableText(
        "Loading",
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            color: Colors.black),
      ),
      "subText": "Internet status"
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
      "subText": "Serial devices"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final device = Provider.of<DeviceProvider>(context).device;
    Map<String, NetworkDevice> networkDevices = Map.from(device.ipAddress);
    networkDevices.removeWhere((key, networkDevice) =>
        !(networkDevice.deviceName.contains('wlan') ||
            networkDevice.deviceName.contains('eth') ||
            networkDevice.deviceName.contains('enp')));
    networkDevices.removeWhere(
        (key, networkDevice) => (networkDevice.deviceName.contains('veth')));
    Widget networkDeviceWidget = Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: networkDevices.entries.map((entry) {
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
          children: networkDevices.entries.map((entry) {
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

    Widget serialDevicesWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: device.serialDevices
          .map((device) => SelectableText(
                device,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ))
          .toList(),
    );

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
        "icon": Icons.wifi,
        "mainText": SelectableText(
          device.internetStatus,
          style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
        "subText": "Internet status"
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
          device.getSupervisorVersion(),
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
        "mainText": networkDeviceWidget,
        "subText": "IP address"
      },
      {
        "icon": Icons.cable,
        "mainText": serialDevicesWidget,
        "subText": "Serial devices"
      },
    ];

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
