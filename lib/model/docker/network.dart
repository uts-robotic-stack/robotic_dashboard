class NetworkConfig {
  final String ipAddress;
  final String gateway;
  final String subnet;

  NetworkConfig({
    required this.ipAddress,
    required this.gateway,
    required this.subnet,
  });

  factory NetworkConfig.fromJson(Map<String, dynamic> json) {
    return NetworkConfig(
      ipAddress: json['ip_address'],
      gateway: json['gateway'],
      subnet: json['subnet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ip_address': ipAddress,
      'gateway': gateway,
      'subnet': subnet,
    };
  }
}
