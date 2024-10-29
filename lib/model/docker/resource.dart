class ResourceConfig {
  final int cpu;
  final int memory;

  ResourceConfig({
    required this.cpu,
    required this.memory,
  });

  factory ResourceConfig.fromJson(Map<String, dynamic> json) {
    return ResourceConfig(
      cpu: json['cpu'],
      memory: json['memory'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpu': cpu,
      'memory': memory,
    };
  }
}
