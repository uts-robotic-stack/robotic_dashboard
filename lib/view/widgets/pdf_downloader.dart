import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:robotic_dashboard/utils/constants.dart';
import 'package:yaml/yaml.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFDownloadListWidget extends StatefulWidget {
  const PDFDownloadListWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PDFDownloadListWidgetState createState() => _PDFDownloadListWidgetState();
}

class _PDFDownloadListWidgetState extends State<PDFDownloadListWidget> {
  List<Map<String, String>> pdfFiles = [];

  @override
  void initState() {
    super.initState();
    loadPdfFiles();
  }

  Future<void> loadPdfFiles() async {
    try {
      final String yamlString =
          await rootBundle.loadString('assets/pdfs/pdf_lists.yaml');
      final YamlMap yamlMap = loadYaml(yamlString);
      final YamlList instructions = yamlMap['instructions'];
      setState(() {
        pdfFiles = List<Map<String, String>>.from(
          instructions.map((item) => Map<String, String>.from(item)),
        );
      });
    } catch (e) {
      // print("Failed to load PDF list: $e");
    }
  }

  Future<void> downloadFile(String assetPath, String fileName) async {
    try {
      // Load the file from assets
      final ByteData data = await rootBundle.load(assetPath);
      final blob = html.Blob([data.buffer.asUint8List()]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create an anchor element and trigger a download
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", fileName)
        ..click();

      html.Url.revokeObjectUrl(url);
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: secondaryColor,
            title: const Text("Download Failed"),
            content: Text("Failed to download the file: $e"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void viewPdf(String assetPath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 800,
            width: 1000,
            child: SfPdfViewer.asset(assetPath),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              children: [
                SizedBox(width: 56.0), // Space for the icon column
                Expanded(
                  child: Text(
                    "Name",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Version",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "File Size",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                    width: 112.0), // Space for the view and download buttons
              ],
            ),
          ),
          ...pdfFiles.map((pdf) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.picture_as_pdf,
                    size: 40.0,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      pdf["name"]!,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      pdf["version"] ?? "N/A",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      pdf["size"] ?? "Unknown",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () => viewPdf(pdf["path"]!),
                  ),
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () =>
                        downloadFile(pdf["path"]!, "${pdf["name"]}.pdf"),
                  ),
                  const SizedBox(
                    height: 12.0,
                  )
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

/* Example of assets/pdf_list.yaml:
instructions:
  - name: "Sample PDF 1"
    version: "1.0"
    size: "2 MB"
    description: "This is a description for Sample PDF 1."
    path: "assets/pdf/sample1.pdf"
  - name: "Sample PDF 2"
    version: "1.1"
    size: "3.5 MB"
    description: "This is a description for Sample PDF 2."
    path: "assets/pdf/sample2.pdf"
  - name: "Sample PDF 3"
    version: "2.0"
    size: "1.8 MB"
    description: "This is a description for Sample PDF 3."
    path: "assets/pdf/sample3.pdf"
*/
