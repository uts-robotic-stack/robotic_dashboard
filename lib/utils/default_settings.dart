// Default ENV when runnning any service
const List<String> defaultEnv = [
  "ROS_MASTER_URI=\"http://10.211.55.7:11311\"",
  "ROS_IP=\"192.168.27.1\""
];

const bool defaultPrivileged = true;
const String defaultRestartPolicy = "always";
const bool defaultTTY = true;
