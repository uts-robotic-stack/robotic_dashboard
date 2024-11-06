class NetworkDevice {
  final String deviceType;
  final String deviceName;
  final String ipAddress;

  NetworkDevice({
    required this.deviceType,
    required this.deviceName,
    required this.ipAddress,
  });

  factory NetworkDevice.fromJson(Map<String, dynamic> json) {
    return NetworkDevice(
      deviceType: json['device_type'],
      deviceName: json['device_name'],
      ipAddress: json['ip_address'],
    );
  }
}

class Device {
  final String type;
  final int onDuration;
  final String lastOn;
  final String softwareVersion;
  final Map<String, NetworkDevice> ipAddress;
  final String fleet;

  Device({
    required this.type,
    required this.onDuration,
    required this.lastOn,
    required this.softwareVersion,
    required this.ipAddress,
    required this.fleet,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    // Check if `ip_address` is null, if so, set `ipMap` to an empty map
    Map<String, NetworkDevice> ipMap = json['ip_address'] == null
        ? {}
        : (json['ip_address'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, NetworkDevice.fromJson(value)),
          );

    return Device(
      type: json['device_type'],
      onDuration: json['on_duration'],
      lastOn: json['last_on'],
      softwareVersion: json['software_version'],
      ipAddress: ipMap,
      fleet: json['fleet'],
    );
  }
}
