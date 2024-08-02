class Device {
  final String type;
  final int onDuration;
  final String lastOn;
  final String softwareVersion;
  final String ipAddress;
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
    return Device(
      type: json['device_type'],
      onDuration: json['on_duration'],
      lastOn: json['last_on'],
      softwareVersion: json['software_version'],
      ipAddress: json['ip_address'],
      fleet: json['fleet'],
    );
  }
}
