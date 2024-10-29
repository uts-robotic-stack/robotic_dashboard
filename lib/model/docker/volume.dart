class VolumeConfig {
  final String source;
  final String target;

  VolumeConfig({
    required this.source,
    required this.target,
  });

  factory VolumeConfig.fromJson(Map<String, dynamic> json) {
    return VolumeConfig(
      source: json['source'],
      target: json['target'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'target': target,
    };
  }
}
