import 'package:aviation_tracking/api_data/aviation_data.dart';
import 'package:flutter/material.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late Future<List<Map<String, dynamic>>> flightDetails;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, String> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    flightDetails = FlightService().getFlightDetails(
      args['airline'].toString(),
      args['flightNumber'].toString(),
      args['date'].toString(),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    'Search Results...',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: flightDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.blueGrey[50],
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: Colors.blueGrey,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data![index]['flight']
                                                    ['icao'],
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${snapshot.data![index]['airline']['name'] ?? 'N/A'} (${snapshot.data![index]['airline']['icao']})',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        width: 120,
                                        height: 72.5,
                                        color: Colors.green[600],
                                        child: Center(
                                          child: Text(
                                            snapshot.data![index]
                                                    ['flight_status']
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Depature Time: \n${snapshot.data![index]['departure']['scheduled']}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Arrival Time: \n${snapshot.data![index]['arrival']['scheduled']}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            snapshot.data![index]['departure']
                                                    ['iata'] ??
                                                'N/A',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(snapshot.data![index]
                                                  ['departure']['airport'] ??
                                              'N/A'),
                                        ],
                                      ),
                                      SizedBox(width: 40),
                                      const Icon(
                                        Icons.connecting_airports_sharp,
                                        size: 40,
                                      ),
                                      SizedBox(width: 40),
                                      Column(
                                        children: [
                                          Text(
                                            snapshot.data![index]['arrival']
                                                    ['iata'] ??
                                                'N/A',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(snapshot.data![index]['arrival']
                                                  ['airport'] ??
                                              'N/A'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
