import 'package:robotics_dashboard/model/docker/network.dart';
import 'package:robotics_dashboard/model/docker/option.dart';
import 'package:robotics_dashboard/model/docker/resource.dart';
import 'package:robotics_dashboard/model/docker/volume.dart';

class Service {
  final String image;
  final String action;
  final String name;
  final List<String> command;
  final String status = "starting";

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
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      image: json['image'],
      action: json['action'],
      name: json['name'],
      command: List<String>.from(json['command']),
      containerID: json['container_id'],
      tty: json['tty'],
      privileged: json['privileged'],
      restart: json['restart'],
      network: json['network'],
      networkSettings: json['network_settings'] != null
          ? NetworkConfig.fromJson(json['network_settings'])
          : null,
      mounts: json['mounts'] != null
          ? (json['mounts'] as List)
              .map((i) => MountConfig.fromJson(i))
              .toList()
          : null,
      envVars: json['env_vars'] != null
          ? Map<String, String>.from(json['env_vars'])
          : null,
      volumes: json['volumes'] != null
          ? (json['volumes'] as List)
              .map((i) => VolumeConfig.fromJson(i))
              .toList()
          : null,
      resources: json['resources'] != null
          ? ResourceConfig.fromJson(json['resources'])
          : null,
      sysctls: json['sysctls'] != null
          ? Map<String, String>.from(json['sysctls'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['action'] = action;
    data['name'] = name;
    data['command'] = command;
    if (containerID != null) data['container_id'] = containerID;
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
