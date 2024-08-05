import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:robotics_dashboard/utils/constants.dart';

class ServiceCardManager extends StatefulWidget {
  const ServiceCardManager({Key? key}) : super(key: key);

  @override
  _ServiceCardManagerState createState() => _ServiceCardManagerState();
}

class _ServiceCardManagerState extends State<ServiceCardManager> {
  late Future<List<ServiceData>> _serviceData;

  @override
  void initState() {
    super.initState();
    _serviceData = fetchServiceData();
  }

  Future<List<ServiceData>> fetchServiceData() async {
    final response =
        await http.get(Uri.parse('https://example.com/api/services'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ServiceData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load service data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ServiceData>>(
      future: _serviceData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data available');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return _buildServiceItem(snapshot.data![index]);
            },
          );
        }
      },
    );
  }

  Widget _buildServiceItem(ServiceData data) {
    return Column(
      children: [
        Container(
          height: 150,
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: const Color.fromARGB(26, 0, 0, 0)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14.0),
                        ),
                        Text(
                          'Status: ${data.status}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12.0),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow, size: 20.0),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.pause, size: 20.0),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.stop, size: 20.0),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.my_library_books_outlined,
                            size: 20.0),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.settings, size: 20.0),
                      )
                    ],
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: data.settings.length,
                  itemBuilder: (context, index) {
                    return Text(
                      data.settings[index],
                      style:
                          const TextStyle(color: Colors.black, fontSize: 12.0),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
