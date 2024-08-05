class Service {
  String name;
  String action;
  ShellCommand command;
  List<String> environment;

  String? status;
  String? hostname;
  String? user;
  List<String>? capAdd;
  List<String>? capDrop;
  ServiceBuild? buildOpt;
  String? cgroupParent;
  String? containerName;
  String? domainName;
  List<String>? dependsOn;
  List<String>? devices;
  ShellCommand? entryPoint;
  List<String>? envFile;
  List<String>? expose;
  List<String>? extraHosts;
  String? ipcMode;
  ServiceResources? resources;
  List<ServiceNetwork>? networks;
  String? networkMode;
  List<ServicePort>? ports;
  bool? privileged;
  Map<String, String>? sysctls;
  String? restart;
  bool? tty;
  List<ServiceVolume>? volumes;
  String? workingDir;
  String? image;

  Service({
    required this.name,
    required this.action,
    required this.command,
    required this.environment,
    this.status,
    this.hostname,
    this.user,
    this.capAdd,
    this.capDrop,
    this.buildOpt,
    this.cgroupParent,
    this.containerName,
    this.domainName,
    this.dependsOn,
    this.devices,
    this.entryPoint,
    this.envFile,
    this.expose,
    this.extraHosts,
    this.ipcMode,
    this.resources,
    this.networks,
    this.networkMode,
    this.ports,
    this.privileged,
    this.sysctls,
    this.restart,
    this.tty,
    this.volumes,
    this.workingDir,
    this.image,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      name: json['name'],
      action: json['action'],
      command: ShellCommand.fromJson(json['command']),
      environment: List<String>.from(json['environment']),
      status: json['status'],
      hostname: json['hostname'],
      user: json['user'],
      capAdd: (json['cap_add'] as List?)?.map((e) => e as String).toList(),
      capDrop: (json['cap_drop'] as List?)?.map((e) => e as String).toList(),
      buildOpt: json['build_opt'] != null
          ? ServiceBuild.fromJson(json['build_opt'])
          : null,
      cgroupParent: json['cgroup_parent'],
      containerName: json['container_name'],
      domainName: json['domain_name'],
      dependsOn:
          (json['depends_on'] as List?)?.map((e) => e as String).toList(),
      devices: (json['devices'] as List?)?.map((e) => e as String).toList(),
      entryPoint: json['entrypoint'] != null
          ? ShellCommand.fromJson(json['entrypoint'])
          : null,
      envFile: (json['env_file'] as List?)?.map((e) => e as String).toList(),
      expose: (json['expose'] as List?)?.map((e) => e as String).toList(),
      extraHosts:
          (json['extra_hosts'] as List?)?.map((e) => e as String).toList(),
      ipcMode: json['ipc_mode'],
      resources: json['resources'] != null
          ? ServiceResources.fromJson(json['resources'])
          : null,
      networks: (json['networks'] as List?)
          ?.map((e) => ServiceNetwork.fromJson(e))
          .toList(),
      networkMode: json['network_mode'],
      ports: (json['ports'] as List?)
          ?.map((e) => ServicePort.fromJson(e))
          .toList(),
      privileged: json['privileged'],
      sysctls: (json['sysctls'] as Map?)
          ?.map((k, v) => MapEntry(k as String, v as String)),
      restart: json['restart'],
      tty: json['tty'],
      volumes: (json['volumes'] as List?)
          ?.map((e) => ServiceVolume.fromJson(e))
          .toList(),
      workingDir: json['working_dir'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'action': action,
      'command': command.toJson(),
      'environment': environment,
      'status': status,
      'hostname': hostname,
      'user': user,
      'cap_add': capAdd,
      'cap_drop': capDrop,
      'build_opt': buildOpt?.toJson(),
      'cgroup_parent': cgroupParent,
      'container_name': containerName,
      'domain_name': domainName,
      'depends_on': dependsOn,
      'devices': devices,
      'entrypoint': entryPoint?.toJson(),
      'env_file': envFile,
      'expose': expose,
      'extra_hosts': extraHosts,
      'ipc_mode': ipcMode,
      'resources': resources?.toJson(),
      'networks': networks?.map((x) => x.toJson()).toList(),
      'network_mode': networkMode,
      'ports': ports?.map((x) => x.toJson()).toList(),
      'privileged': privileged,
      'sysctls': sysctls,
      'restart': restart,
      'tty': tty,
      'volumes': volumes?.map((x) => x.toJson()).toList(),
      'working_dir': workingDir,
      'image': image,
    };
  }
}

class ServiceBuild {
  String context;
  String dockerfile;
  Map<String, String?> args;

  ServiceBuild({
    required this.context,
    required this.dockerfile,
    required this.args,
  });

  factory ServiceBuild.fromJson(Map<String, dynamic> json) {
    return ServiceBuild(
      context: json['context'],
      dockerfile: json['dockerfile'],
      args: Map<String, String?>.from(json['args']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'context': context,
      'dockerfile': dockerfile,
      'args': args,
    };
  }
}

class ShellCommand {
  List<String> commands;

  ShellCommand({required this.commands});

  factory ShellCommand.fromJson(List<dynamic> json) {
    return ShellCommand(
      commands: List<String>.from(json),
    );
  }

  List<String> toJson() {
    return commands;
  }
}

class ServiceResources {
  int? cpuPeriod;
  int? cpuQuota;
  String? cpusetCpus;
  String? cpusetMems;
  int? memoryLimit;
  int? memoryReservation;
  int? memorySwap;
  int? memorySwappiness;
  bool? oomKillDisable;

  ServiceResources({
    this.cpuPeriod,
    this.cpuQuota,
    this.cpusetCpus,
    this.cpusetMems,
    this.memoryLimit,
    this.memoryReservation,
    this.memorySwap,
    this.memorySwappiness,
    this.oomKillDisable,
  });

  factory ServiceResources.fromJson(Map<String, dynamic> json) {
    return ServiceResources(
      cpuPeriod: json['cpu_period'],
      cpuQuota: json['cpu_quota'],
      cpusetCpus: json['cpuset_cpus'],
      cpusetMems: json['cpuset_mems'],
      memoryLimit: json['memory_limit'],
      memoryReservation: json['memory_reservation'],
      memorySwap: json['memory_swap'],
      memorySwappiness: json['memory_swappiness'],
      oomKillDisable: json['oom_kill_disable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpu_period': cpuPeriod,
      'cpu_quota': cpuQuota,
      'cpuset_cpus': cpusetCpus,
      'cpuset_mems': cpusetMems,
      'memory_limit': memoryLimit,
      'memory_reservation': memoryReservation,
      'memory_swap': memorySwap,
      'memory_swappiness': memorySwappiness,
      'oom_kill_disable': oomKillDisable,
    };
  }
}

class ServiceNetwork {
  String name;
  List<String>? aliases;
  String? ipv4;
  String? ipv6;

  ServiceNetwork({
    required this.name,
    this.aliases,
    this.ipv4,
    this.ipv6,
  });

  factory ServiceNetwork.fromJson(Map<String, dynamic> json) {
    return ServiceNetwork(
      name: json['name'],
      aliases: (json['aliases'] as List?)?.map((e) => e as String).toList(),
      ipv4: json['ipv4'],
      ipv6: json['ipv6'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'aliases': aliases,
      'ipv4': ipv4,
      'ipv6': ipv6,
    };
  }
}

class ServicePort {
  String target;
  String protocol;
  String hostIp;
  String hostPort;

  ServicePort({
    required this.target,
    required this.protocol,
    required this.hostIp,
    required this.hostPort,
  });

  factory ServicePort.fromJson(Map<String, dynamic> json) {
    return ServicePort(
      target: json['target'],
      protocol: json['protocol'],
      hostIp: json['host_ip'],
      hostPort: json['host_port'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'target': target,
      'protocol': protocol,
      'host_ip': hostIp,
      'host_port': hostPort,
    };
  }
}

class ServiceVolume {
  String type;
  String source;
  String destination;
  String? option;

  ServiceVolume({
    required this.type,
    required this.source,
    required this.destination,
    this.option,
  });

  factory ServiceVolume.fromJson(Map<String, dynamic> json) {
    return ServiceVolume(
      type: json['type'],
      source: json['source'],
      destination: json['destination'],
      option: json['option'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'source': source,
      'destination': destination,
      'option': option,
    };
  }
}

class Image {
  String id;
  String name;
  String tag;
  String created;

  Image({
    required this.id,
    required this.name,
    required this.tag,
    required this.created,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'],
      name: json['name'],
      tag: json['tag'],
      created: json['created'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tag': tag,
      'created': created,
    };
  }
}

class Labels {
  Map<String, String> labels;

  Labels({required this.labels});

  factory Labels.fromJson(Map<String, dynamic> json) {
    return Labels(
      labels: Map<String, String>.from(json),
    );
  }

  Map<String, String> toJson() {
    return labels;
  }
}

class Network {
  String name;
  String id;
  bool checkDuplicate;
  Labels labels;
  bool internal;
  bool attachable;
  String driver;
  bool enableIPv6;
  // Assuming network.IPAM is another class you need to define

  Network({
    required this.name,
    required this.id,
    required this.checkDuplicate,
    required this.labels,
    required this.internal,
    required this.attachable,
    required this.driver,
    required this.enableIPv6,
    // required this.ipam, // Uncomment when IPAM is defined
  });

  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(
      name: json['name'],
      id: json['id'],
      checkDuplicate: json['check_duplicate'],
      labels: Labels.fromJson(json['labels']),
      internal: json['internal'],
      attachable: json['attachable'],
      driver: json['driver'],
      enableIPv6: json['enable_ipv6'],
      // ipam: IPAM.fromJson(json['ipam']), // Uncomment when IPAM is defined
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'check_duplicate': checkDuplicate,
      'labels': labels.toJson(),
      'internal': internal,
      'attachable': attachable,
      'driver': driver,
      'enable_ipv6': enableIPv6,
      // 'ipam': ipam.toJson(), // Uncomment when IPAM is defined
    };
  }
}
