import 'package:robotics_dashboard/model/docker/network.dart';
import 'package:robotics_dashboard/model/docker/option.dart';
import 'package:robotics_dashboard/model/docker/resource.dart';
import 'package:robotics_dashboard/model/docker/volume.dart';

class Service {
  final String image;
  final String action;
  final String name;
  final List<String> command;

  String? status;
  String? containerID;
  bool? tty;
  bool? privileged;
  String? restart;
  String? network;
  NetworkConfig? networkSettings;
  List<MountConfig>? mounts;
  Map<String, String>? envVars;
  List<VolumeConfig>? volumes;
  ResourceConfig? resources;
  Map<String, String>? sysctls;

  Service({
    required this.image,
    required this.action,
    required this.name,
    required this.command,
    this.containerID,
    this.tty,
    this.privileged,
    this.restart,
    this.network,
    this.networkSettings,
    this.mounts,
    this.envVars,
    this.volumes,
    this.resources,
    this.sysctls,
    this.status,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    // Helper function to safely fetch and parse lists of maps
    List<T>? parseList<T>(
        dynamic data, T Function(Map<String, dynamic>) fromJson) {
      if (data is List) {
        return data
            .map((item) => fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return null;
    }

    return Service(
      image: json['image'] as String? ?? '', // Default empty string if null
      action: json['action'] as String? ?? '', // Default empty string if null
      name: json['name'] as String? ?? '', // Default empty string if null
      command: (json['command'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          [], // Default empty list if null
      containerID: json['container_id'] as String?,
      tty: json['tty'] as bool?,
      privileged: json['privileged'] as bool?,
      restart: json['restart'] as String?,
      network: json['network'] as String?,
      networkSettings: json['network_settings'] != null
          ? NetworkConfig.fromJson(
              json['network_settings'] as Map<String, dynamic>)
          : null,
      mounts: parseList<MountConfig>(
          json['mounts'], (item) => MountConfig.fromJson(item)),
      envVars: json['env_vars'] != null
          ? Map<String, String>.from(json['env_vars'] as Map)
          : null,
      volumes: parseList<VolumeConfig>(
          json['volumes'], (item) => VolumeConfig.fromJson(item)),
      resources: json['resources'] != null
          ? ResourceConfig.fromJson(json['resources'] as Map<String, dynamic>)
          : null,
      sysctls: json['sysctls'] != null
          ? Map<String, String>.from(json['sysctls'] as Map)
          : null,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['action'] = action;
    data['name'] = name;
    data['command'] = command;
    if (tty != null) data['tty'] = tty;
    if (privileged != null) data['privileged'] = privileged;
    if (restart != null) data['restart'] = restart;
    if (network != null) data['network'] = network;
    if (networkSettings != null) {
      data['network_settings'] = networkSettings!.toJson();
    }
    if (mounts != null) {
      data['mounts'] = mounts!.map((v) => v.toJson()).toList();
    }
    if (envVars != null) data['env_vars'] = envVars;
    if (volumes != null) {
      data['volumes'] = volumes!.map((v) => v.toJson()).toList();
    }
    if (resources != null) data['resources'] = resources!.toJson();
    if (sysctls != null) data['sysctls'] = sysctls;
    return data;
  }
}
