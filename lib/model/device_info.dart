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
  final String name;
  final String type;
  final int onDuration;
  final String lastOn;
  final String softwareVersion;
  final Map<String, NetworkDevice> ipAddress;
  final String fleet;
  final String internetStatus;

  Device(
      {required this.name,
      required this.type,
      required this.onDuration,
      required this.lastOn,
      required this.softwareVersion,
      required this.ipAddress,
      required this.fleet,
      required this.internetStatus});

  factory Device.fromJson(Map<String, dynamic> json) {
    // Check if `ip_address` is null, if so, set `ipMap` to an empty map
    Map<String, NetworkDevice> ipMap = json['ip_address'] == null
        ? {}
        : (json['ip_address'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, NetworkDevice.fromJson(value)),
          );

    return Device(
        name: json['device_name'] == null
            ? "robotic_default"
            : json['device_name'] as String,
        type: json['device_type'],
        onDuration: json['on_duration'],
        lastOn: json['last_on'],
        softwareVersion: json['software_version'],
        ipAddress: ipMap,
        fleet: json['fleet'],
        internetStatus:
            _statusToMessage(_mapStatusCodeToEnum(json['internet_status'])));
  }
}

enum ConnectionStatus {
  noConnection,
  dnsOnly,
  httpOnly,
  fullConnection,
}

String _statusToMessage(ConnectionStatus status) {
  switch (status) {
    case ConnectionStatus.noConnection:
      return "No connection";
    case ConnectionStatus.dnsOnly:
      return "Limited connection";
    case ConnectionStatus.httpOnly:
      return "Partial connection";
    case ConnectionStatus.fullConnection:
      return "Full connection";
  }
}

// Function to map backend status code to ConnectionStatus enum
ConnectionStatus _mapStatusCodeToEnum(int statusCode) {
  switch (statusCode) {
    case 0:
      return ConnectionStatus.noConnection;
    case 1:
      return ConnectionStatus.dnsOnly;
    case 2:
      return ConnectionStatus.httpOnly;
    case 3:
      return ConnectionStatus.fullConnection;
    default:
      throw Exception("Unknown connection status code");
  }
}
