class MountConfig {
  String type;
  String source;
  String target;

  MountConfig({required this.type, required this.source, required this.target});

  factory MountConfig.fromJson(Map<String, dynamic> json) {
    return MountConfig(
      type: json['type'],
      source: json['source'],
      target: json['target'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'source': source,
      'target': target,
    };
  }
}

class ServicePort {
  String target;
  String protocol;
  String hostIp;
  String hostPort;

  ServicePort(
      {required this.target,
      required this.protocol,
      required this.hostIp,
      required this.hostPort});

  factory ServicePort.fromJson(Map<String, dynamic> json) {
    return ServicePort(
      target: json['target'],
      protocol: json['protocol'],
      hostIp: json['hostIp'],
      hostPort: json['hostPort'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'target': target,
      'protocol': protocol,
      'hostIp': hostIp,
      'hostPort': hostPort,
    };
  }
}
