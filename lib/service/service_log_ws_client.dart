import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

// Define a ChangeNotifier class to manage state
class ServiceLogsWSClient with ChangeNotifier {
  final String _baseUrl = dotenv.env['BASE_URL'] ??
      const String.fromEnvironment("BASE_URL", defaultValue: "10.211.55.7");
  String _serviceName = "robotic_supervisor";
  WebSocketChannel? _channel;
  final List<String> _logs = [];

  String get serviceName => _serviceName;
  List<String> get logs => _logs;

  void updateServiceName(String newName) {
    if (_serviceName == newName) {
      return;
    }
    _serviceName = newName;
    // _logs.clear();
    notifyListeners(); // Notify listeners to rebuild the UI
    connectToWebSocket(); // Connect to new WebSocket when service name changes
  }

  void connectToWebSocket() {
    if (_serviceName == "") {
      return;
    }
    // Close any existing WebSocket connection
    _channel?.sink.close(status.normalClosure);

    // Establish new WebSocket connection
    final url =
        'ws://$_baseUrl/api/v1/supervisor/log-stream?container=$_serviceName';
    _channel = WebSocketChannel.connect(Uri.parse(url));

    // Listen to the stream and update logs
    _channel?.stream.listen((message) {
      _logs.add(message);
      notifyListeners();
    }, onError: (error) {
      _logs.add('Error: $error');
      notifyListeners();
    }, onDone: () {
      _logs.add('Connection closed');
      notifyListeners();
    });
  }

  void disconnectWebSocket() {
    _channel?.sink.close(status.normalClosure);
    _serviceName = "";
    notifyListeners();
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
