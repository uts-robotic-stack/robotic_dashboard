import 'dart:async';
import 'dart:isolate';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  String _url;
  late Isolate _isolate;
  final _dataController = StreamController<String>.broadcast();
  String? _latestData;

  WebSocketClient(this._url) {
    _initialize();
  }

  // Getter for URL
  String get url => _url;

  // Setter for URL
  set url(String newUrl) {
    _url = newUrl;
    dispose();
    _initialize();
  }

  // Getter to obtain the latest value
  String? get latestData => _latestData;

  // Stream to listen for new data
  Stream<String> get dataStream => _dataController.stream;

  Future<void> _initialize() async {
    ReceivePort receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_webSocketIsolate, receivePort.sendPort);
    SendPort sendPort = await receivePort.first;

    // Send the URL to the isolate
    sendPort.send(_url);

    // Listen to data from the isolate
    receivePort.listen((message) {
      if (message is String) {
        _latestData = message;
        if (!_dataController.isClosed) {
          _dataController.add(message);
        }
      }
    });
  }

  static void _webSocketIsolate(SendPort sendPort) async {
    ReceivePort isolateReceivePort = ReceivePort();
    sendPort.send(isolateReceivePort.sendPort);

    // Wait for the URL
    String url = await isolateReceivePort.first;

    // Create the WebSocket connection
    final channel = WebSocketChannel.connect(Uri.parse(url));

    // Listen for data and send it back to the main thread
    channel.stream.listen((data) {
      if (data is String) {
        sendPort.send(data);
      }
    }, onDone: () {
      print("WebSocket connection closed");
    }, onError: (error) {
      print("WebSocket error: $error");
    });
  }

  void dispose() {
    if (!_dataController.isClosed) {
      _dataController.close();
    }
    _isolate.kill(priority: Isolate.immediate);
  }
}
