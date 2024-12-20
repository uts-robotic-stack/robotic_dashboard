import 'package:provider/provider.dart';
import 'package:robotic_dashboard/service/service_log_ws_client.dart';
import 'package:robotic_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:robotic_dashboard/view/widgets/adaptive_switch.dart';

// ignore: must_be_immutable
class LogsViewer extends StatelessWidget {
  LogsViewer({super.key});

  final ScrollController _controller = ScrollController();
  bool _follow = false;

  @override
  Widget build(BuildContext context) {
    final logsProvider = Provider.of<ServiceLogsWSClient>(context);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: secondaryColor,
              // borderRadius: const BorderRadius.only(
              //     topLeft: Radius.circular(10),
              //     topRight: Radius.circular(10)),
              border: Border.all(color: borderColor)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Text(
                    "Logs",
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Row(
                  children: [
                    AdaptiveSwitch(
                      onChanged: (value) {
                        _follow = value;
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.refresh,
                        size: 17.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.download,
                        size: 17.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        logsProvider.disconnectWebSocket();
                        logsProvider.logs.clear();
                      },
                      icon: const Icon(
                        Icons.clear,
                        size: 17.0,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: SelectionArea(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                // borderRadius: BorderRadius.only(
                //     bottomLeft: Radius.circular(10),
                //     bottomRight: Radius.circular(10)),
                color: Colors.black87,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                itemCount: logsProvider.logs.length,
                itemBuilder: (context, index) {
                  if (_follow) {
                    var scrollPosition = _controller.position;
                    _controller.jumpTo(scrollPosition.maxScrollExtent);
                  }
                  return ListTile(
                    minVerticalPadding: 2.0,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(vertical: -4),
                    title: Text(
                      logsProvider.logs[index],
                      style: const TextStyle(
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Ubuntu Mono',
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              )),
        ))
      ],
    );
  }
}

// ignore: must_be_immutable
class _LogDetails extends StatelessWidget {
  String? timestamp;
  String? logType;
  String? containerName;
  String? content;
  String? remainder;
  String? _originalEntry;

  _LogDetails(String logEntry, String containerName) {
    parseLogEntry(logEntry, containerName);
  }

  void parseLogEntry(String logEntry, String containerName) {
    // Split the log entry by whitespace
    _originalEntry = logEntry;
    List<String> logParts = logEntry.split(" ");

    // Extract timestamp and log type
    timestamp = logParts[0];
    logType =
        logParts[2].length >= 4 ? logParts[2].substring(0, 4) : logParts[2];
    remainder = logParts[2].replaceAll(logType!, "");
    content = logEntry.replaceAll(logParts[0], "");
    content = content!.replaceAll(logParts[2], "");
  }

  Color logTypeColor(String type) {
    if (type.contains("INFO")) {
      return Colors.green;
    }
    if (type.contains("WARN")) {
      return Colors.yellow;
    }
    if (type.contains("ERRO")) {
      return Colors.red;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: _originalEntry,
            style: const TextStyle(
              fontStyle: FontStyle.normal,
              fontFamily: 'Ubuntu Mono',
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
      // Optional cursor customization
      showCursor: true,
      cursorColor: Colors.white,
      cursorWidth: 1.5,
    );
  }
}
